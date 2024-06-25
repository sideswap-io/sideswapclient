package io.sideswap

import android.annotation.SuppressLint
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothProfile
import android.bluetooth.BluetoothStatusCodes
import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.bluetooth.le.ScanSettings.SCAN_MODE_LOW_LATENCY
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.ParcelUuid
import androidx.core.content.ContextCompat
import uniffi.sideswap_jade.BleApi
import uniffi.sideswap_jade.BleApiException
import java.util.UUID
import kotlin.concurrent.thread

// TODO: Replace with CompletableFuture from stdlib once minSdkVersion is 24+
class CompletableFuture<T> {
    private val lock = Object()
    private var value: T? = null

    fun get(timeoutSeconds: Long): T {
        synchronized(lock) {
            while (value == null) {
                lock.wait(timeoutSeconds * 1000, 0)
            }
            val resultValue = value
            if (resultValue == null) {
                throw BleApiException.General("timeout")
            }
            return resultValue
        }
    }

    fun complete(newValue: T) {
        synchronized(lock) {
            value = newValue
            lock.notifyAll()
        }
    }
}

class Connection(val device: BluetoothDevice, val gatt: BluetoothGatt) : AutoCloseable {
    var resFut = CompletableFuture<Boolean>()

    var readData: ByteArray = ByteArray(0)
    var disconnected: Boolean = false

    @SuppressLint("MissingPermission")
    override fun close() {
        gatt.close()
    }
}

class BleApiImpl(private var mActivity: Activity): BleApi {
    private var mBondStateReceiverStarted = false

    private var mFoundDevices: MutableMap<String, BluetoothDevice> = LinkedHashMap()

    private var mConnections: MutableMap<String, Connection> = LinkedHashMap()

    private val mBondStateReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        @SuppressLint("MissingPermission")
        override fun onReceive(context: Context, intent: Intent) {
            if (intent.action != BluetoothDevice.ACTION_BOND_STATE_CHANGED) {
                return
            }

            @Suppress("DEPRECATION")
            val device = intent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE)
            if (device == null) {
                return
            }

            val connection = getConnectionWithAddress(device.address)
            if (connection == null) {
                return
            }

            val bondState = intent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, -1)
            when (bondState) {
                BluetoothDevice.BOND_BONDED -> {
                    log("device ${connection.device.address} is now bonded, request MTU")
                    val res = connection.gatt.requestMtu(JADE_MTU)
                    if (!res) {
                        log("Requesting MTU failed")
                        connection.resFut.complete(false)
                        return
                    }
                }

                BluetoothDevice.BOND_BONDING -> {
                    log("Bonding device...")
                }

                BluetoothDevice.BOND_NONE -> {
                    log("Bonding failed")
                    connection.resFut.complete(false)
                }
            }
        }
    }

    private fun getBluetoothAdapter(): BluetoothAdapter {
        val service: BluetoothManager? = ContextCompat.getSystemService(mActivity, BluetoothManager::class.java)
        if (service == null) {
            throw BleApiException.General("BluetoothManager is null")
        }
        return service.adapter
    }

    private fun getScanner(): BluetoothLeScanner {
        val scanner = getBluetoothAdapter().bluetoothLeScanner
        if (scanner == null) {
            throw BleApiException.General("bluetoothLeScanner is null")
        }
        return scanner
    }

    private fun getWriteCharacteristic(gatt: BluetoothGatt): BluetoothGattCharacteristic {
        for (service in gatt.services) {
            for (char in service.characteristics) {
                if (char.uuid == IO_TX_CHAR_UUID) {
                    return char
                }
            }
        }
        throw BleApiException.General("can't find write characteristic, total services: ${gatt.services.size}")
    }

    private val mScanCallback: ScanCallback = object : ScanCallback() {
        override fun onScanResult(callbackType: Int, result: ScanResult) {
            super.onScanResult(callbackType, result)
            val record = result.scanRecord
            if (record != null) {
                val deviceName = record.deviceName
                if (deviceName != null) {
                    log("found device: $deviceName")
                    mFoundDevices[deviceName] = result.device
                }
            }
        }

        override fun onScanFailed(errorCode: Int) {
            super.onScanFailed(errorCode)
            log("scan failed: $errorCode")
        }
    }

    @SuppressLint("MissingPermission")
    private fun getConnectionWithName(name: String): Connection? {
        val connection = mConnections[name]
        if (connection == null) {
            log("Can't find connection with name $name")
        }
        return connection
    }

    private fun getConnectionWithAddress(address: String): Connection? {
        for (connection in mConnections.values) {
            if (connection.device.address == address) {
                return connection
            }
        }
        log("Can't find connection with address $address")
        return null
    }

    private fun getConnectionWithGatt(gatt: BluetoothGatt): Connection? {
        for (connection in mConnections.values) {
            if (connection.gatt == gatt) {
                return connection
            }
        }
        log("Can't find connection")
        return null
    }

    @SuppressLint("MissingPermission")
    val gattCallback = object : BluetoothGattCallback() {
        override fun onConnectionStateChange(
                gatt: BluetoothGatt,
                status: Int,
                newState: Int,
        ) {
            super.onConnectionStateChange(gatt, status, newState)
            log("Connection state change: $status, $newState, bond state: ${gatt.device.bondState}")

            val connection = getConnectionWithGatt(gatt)
            if (connection == null) {
                return
            }

            if (status != BluetoothGatt.GATT_SUCCESS) {
                log("connection failed: $status")
                connection.resFut.complete(false)
                return
            }

            if (newState == BluetoothProfile.STATE_DISCONNECTED) {
                log("Device disconnected")
                connection.resFut.complete(false)
                connection.disconnected = true
                return
            }

            if (connection.device.bondState == BluetoothDevice.BOND_NONE) {
                log("Wait for bonding...")
                return
            }

            if (connection.device.bondState == BluetoothDevice.BOND_BONDING) {
                return
            }

            log("device connected and is already bonded, request MTU")
            val res = gatt.requestMtu(JADE_MTU)
            if (!res) {
                log("Requesting MTU failed")
                connection.resFut.complete(false)
                return
            }
        }

        override fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
            super.onMtuChanged(gatt, mtu, status)
            log("onMtuChanged: $mtu, status: $status")

            val connection = getConnectionWithGatt(gatt)
            if (connection == null) {
                return
            }

            log("mtu changed, discover services")
            val res = gatt.discoverServices()
            if (!res) {
                log("Starting discoverServices failed")
                connection.resFut.complete(false)
            }
        }

        override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
            super.onServicesDiscovered(gatt, status)
            log("services discovered: ${gatt.services.size}")

            val connection = getConnectionWithGatt(gatt)
            if (connection == null) {
                return
            }

            connection.resFut.complete(true)
        }

        override fun onDescriptorWrite(gatt: BluetoothGatt?, descriptor: BluetoothGattDescriptor?, status: Int) {
            super.onDescriptorWrite(gatt, descriptor, status)
            log("onDescriptorWrite: $status")

            if (gatt == null) {
                log("received gatt is null")
                return
            }

            val connection = getConnectionWithGatt(gatt)
            if (connection == null) {
                return
            }

            if (status != BluetoothGatt.GATT_SUCCESS) {
                log("onDescriptorWrite failed")
                connection.resFut.complete(false)
                return
            }

            connection.resFut.complete(true)
        }

        @Deprecated("Deprecated for Android 13+")
        @Suppress("DEPRECATION")
        override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
            super.onCharacteristicChanged(gatt, characteristic)
            // On newer Android versions both onCharacteristicChanged called
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
                newData(gatt, characteristic, characteristic.value)
            }
        }

        override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, data: ByteArray) {
            super.onCharacteristicChanged(gatt, characteristic, data)
            newData(gatt, characteristic, data)
        }

        override fun onCharacteristicWrite(
                gatt: BluetoothGatt?,
                characteristic: BluetoothGattCharacteristic?,
                status: Int,
        ) {
            super.onCharacteristicWrite(gatt, characteristic, status)
            log("onCharacteristicWrite: $status")

            if (gatt == null) {
                log("received gatt is null")
                return
            }

            val connection = getConnectionWithGatt(gatt)
            if (connection == null) {
                return
            }

            if (status != BluetoothGatt.GATT_SUCCESS) {
                log("onCharacteristicWrite failed: $status")
                connection.resFut.complete(false)
                return
            }

            connection.resFut.complete(true)
        }
    }

    @SuppressLint("MissingPermission")
    override fun startScan() {
        log("start scan...")

        mFoundDevices.clear()

        val scanner = getScanner()
        val filter = ScanFilter.Builder().setServiceUuid(IO_SERVICE_UUID).build()
        val filters: Array<ScanFilter> = arrayOf(filter)
        val scanSettings = ScanSettings.Builder().setScanMode(SCAN_MODE_LOW_LATENCY).build()
        scanner.startScan(filters.asList(), scanSettings, mScanCallback)
    }

    @SuppressLint("MissingPermission")
    override fun stopScan() {
        log("stop scan...")
        val scanner = getScanner()
        scanner.stopScan(mScanCallback)
    }

    @SuppressLint("MissingPermission")
    override fun deviceNames(): List<String> {
        val adapter = getBluetoothAdapter()
        log("bonded devices: ${adapter.bondedDevices.size}, found devices: ${mFoundDevices.size}")

        val list: MutableSet<String> = LinkedHashSet()
        for (device in adapter.bondedDevices) {
            if (device.name != null && device.name.startsWith("Jade ")) {
                list.add(device.name)
            }
        }

        for (name in mFoundDevices.keys) {
            list.add(name)
        }

        return list.toList()
    }

    @SuppressLint("MissingPermission")
    fun getDevice(deviceName: String): BluetoothDevice {
        val adapter = getBluetoothAdapter()
        var device = adapter.bondedDevices.find { it.name == deviceName }
        if (device != null) {
            return device
        }
        device = mFoundDevices[deviceName]
        if (device != null) {
            return device
        }
        throw BleApiException.General("Can't find device $deviceName")
    }

    @SuppressLint("MissingPermission")
    fun writeDescriptor(connection: Connection, descriptor: BluetoothGattDescriptor, value: ByteArray): Boolean {
        connection.resFut = CompletableFuture()
        @Suppress("DEPRECATION")
        descriptor.setValue(value)
        @Suppress("DEPRECATION")
        var res = connection.gatt.writeDescriptor(descriptor)
        if (!res) {
            log("starting writeDescriptor failed")
            return false
        }
        res = connection.resFut.get(10)
        return res
    }

    @SuppressLint("MissingPermission")
    override fun open(deviceName: String) {
        if (!mBondStateReceiverStarted) {
            val filter = IntentFilter(BluetoothDevice.ACTION_BOND_STATE_CHANGED)
            mActivity.applicationContext.registerReceiver(mBondStateReceiver, filter)
            mBondStateReceiverStarted = true
        }

        close(deviceName)

        log("connect to: $deviceName")
        val device = getDevice(deviceName)
        log("Bond state: ${device.bondState}")

        val gatt = device.connectGatt(mActivity, false, gattCallback)

        val connection = Connection(device, gatt)
        log("New connection created, connection: $connection")

        mConnections[deviceName] = connection

        var res = connection.resFut.get(60)
        if (!res) {
            throw BleApiException.General("open failed")
        }

        // We shouldn't subscribe to all characteristics, but it looks like Jade sometimes sends read notifications to the service characteristic.
        // As a result, some messages get lost and the connection doesn't work.
        // Subscribing to all characteristics (there are 2 of them) seems to fix the problem.
        // To debug such problems see how to "Enable Bluetooth HCI snoop log" on Android

        for (service in gatt.services) {
            for (char in service.characteristics) {
                if (char.properties and BluetoothGattCharacteristic.PROPERTY_INDICATE != 0) {
                    log("subscribe to ${char.uuid}, descriptor count: ${char.descriptors.size}")
                    res = gatt.setCharacteristicNotification(char, true)
                    if (!res) {
                        throw BleApiException.General("setCharacteristicNotification failed")
                    }
                    if (char.descriptors.size != 1) {
                        throw BleApiException.General("unexpected read descriptor count")
                    }
                    val descriptor = char.descriptors[0]

                    writeDescriptor(connection, descriptor, BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE)

                    var failCount = 0
                    while (true) {
                        res = writeDescriptor(connection, descriptor, BluetoothGattDescriptor.ENABLE_INDICATION_VALUE)
                        if (res) {
                            break
                        }
                        failCount += 1
                        if (failCount >= 5) {
                            throw BleApiException.General("can't enable indication")
                        }
                        Thread.sleep(1000)
                    }
                }
            }
        }

        log("device opened successfully")
    }

    @SuppressLint("MissingPermission")
    override fun write(deviceName: String, buf: ByteArray) {
        val connection = getConnectionWithName(deviceName)
        if (connection == null) {
            throw BleApiException.General("can't find connection with name $deviceName")
        }

        val characteristic = getWriteCharacteristic(connection.gatt)

        connection.resFut = CompletableFuture()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            val res = connection.gatt.writeCharacteristic(characteristic, buf, BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT)
            if (res != BluetoothStatusCodes.SUCCESS) {
                throw BleApiException.General("writeCharacteristic failed: $res")
            }
        } else {
            characteristic.writeType = BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
            @Suppress("DEPRECATION")
            characteristic.value = buf
            @Suppress("DEPRECATION")
            val res = connection.gatt.writeCharacteristic(characteristic)
            if (!res) {
                throw BleApiException.General("writeCharacteristic failed")
            }
        }

        val res = connection.resFut.get(10)
        if (!res) {
            throw BleApiException.General("write failed")
        }
    }

    fun newData(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, data: ByteArray) {
        log("new data: ${data.size} from ${characteristic.uuid}")

        val connection = getConnectionWithGatt(gatt)
        if (connection == null) {
            return
        }

        synchronized(connection) {
            connection.readData += data
        }
    }

    @SuppressLint("MissingPermission")
    override fun read(deviceName: String): ByteArray {
        val connection = getConnectionWithName(deviceName)
        if (connection == null) {
            throw BleApiException.General("can't find connection with name $deviceName")
        }
        if (connection.disconnected) {
            throw BleApiException.General("Device $deviceName disconnected")
        }
        synchronized(connection) {
            val data = connection.readData
            connection.readData = ByteArray(0)
            return data
        }
    }

    @SuppressLint("MissingPermission")
    override fun close(deviceName: String) {
        val connection = mConnections.remove(deviceName)
        log("Close connection, connection: $connection")
        connection?.close()
    }

    companion object {
        private const val JADE_MTU = 515

        private val IO_SERVICE_UUID = ParcelUuid.fromString("6e400001-b5a3-f393-e0a9-e50e24dcca9e")
        private val IO_TX_CHAR_UUID = UUID.fromString("6e400002-b5a3-f393-e0a9-e50e24dcca9e")
        //private val IO_RX_CHAR_UUID = UUID.fromString("6e400003-b5a3-f393-e0a9-e50e24dcca9e")
    }
}

private fun log(msg: String) {
    uniffi.sideswap_jade.log(msg)
}

fun startBle(activity: Activity) {
    val bleApi = BleApiImpl(activity)

    val bleClient = uniffi.sideswap_jade.BleClient(bleApi)

    thread(start = true) {
        bleClient.run()
    }
}