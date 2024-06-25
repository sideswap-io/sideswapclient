import Foundation
import CoreBluetooth
import os.log

class CompletableFuture<T> {
    var semaphore = DispatchSemaphore(value: 0)
    var value: T?
   
    func get(timeoutSeconds: Int) throws -> T {
        let _ = semaphore.wait(timeout: .now() + .seconds(timeoutSeconds))
        guard let value = value else {
            throw BleApiError.General(msg: "timeout")
        }
        return value
    }
    
    func complete(_ v: T) {
        value = v
        semaphore.signal()
    }
}

class Connection {
    var peripheral: CBPeripheral

    var writeChar: CBCharacteristic

    init(p: CBPeripheral, w: CBCharacteristic) {
        peripheral = p
        writeChar = w
    }

    var buf = Data()
    let lock = NSLock()

    func appendData(data: Data) {
        lock.lock()
        buf.append(data)
        lock.unlock()
    }

    func takeData() -> Data {
        lock.lock()
        var data = buf
        buf = Data()
        lock.unlock()
        return data
    }
}

class BleApiImpl_: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, BleApi {
    let IO_SERVICE_UUID = CBUUID(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")
    let IO_TX_CHAR_UUID = CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e")
    let IO_RX_CHAR_UUID = CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        l("central state updated: \(central.state)")
        if #available(iOS 13, *) {
            l("authorization: \(central.authorization)")
        }
        resFut.complete(true)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let name = peripheral.name else {
            l("found peripheral without a name")
            return
        }
        l("discovered, name: \(name), RSSI: \(RSSI), identifier: \(peripheral.identifier)")
        foundDevices[name] = peripheral
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        l("connected to \(peripheral.name ?? "")")
        l("discover services...")
        peripheral.discoverServices(nil)
    }
     
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        l("connection to \(peripheral.name ?? "") failed: \(String(describing: error))")
        resFut.complete(false)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            l("discovering services failed: \(error)")
            resFut.complete(false)
            return
        }
        
        guard let services = peripheral.services else {
            l("services is nil")
            resFut.complete(false)
            return
        }
        
        l("discovered services: \(services)")
        guard let mainService = (services.first {$0.uuid == IO_SERVICE_UUID}) else {
            l("can't find main service")
            resFut.complete(false)
            return
        }
        
        l("discover characteristics...")
        peripheral.discoverCharacteristics(nil, for: mainService)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            l("discovering characteristics failed: \(error)")
            resFut.complete(false)
            return
        }
        
        guard let characteristics = service.characteristics else {
            l("characteristics is nil")
            resFut.complete(false)
            return
        }
        
        l("discovered characteristics: \(characteristics)")
        resFut.complete(true)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            l("discovering descriptors failed: \(error)")
            resFut.complete(false)
            return
        }

        guard let descriptors = characteristic.descriptors else {
            l("descriptors is nil")
            resFut.complete(false)
            return
        }

        l("discovered descriptors: \(descriptors)")
        resFut.complete(true)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            l("unsubscribing/subscribing to notifications failed: \(error)")
            resFut.complete(false)
            return
        }
        l("unsubscribing/subscribing to notifications succeed")
        resFut.complete(true)
    }
    
    var centralManager: CBCentralManager?
    
    var resFut = CompletableFuture<Bool>()
    
    var foundDevices = [String : CBPeripheral]()
    
    var connections = [String : Connection]()

    func getMananger() throws -> CBCentralManager {
        if let centralManager = centralManager {
            return centralManager
        }
        
        l("create central...")
        resFut = CompletableFuture<Bool>()
        let manager = CBCentralManager(delegate: self, queue: nil)
        centralManager = manager
        l("wait for central state...")
        let _ = try resFut.get(timeoutSeconds: 10)
        l("central state: \(manager.state)")
        
        switch manager.state {
        case .poweredOn:
            break
        case .poweredOff:
            throw BleApiError.General(msg: "Please enable Bluetooth and try again")
        case .resetting:
            throw BleApiError.General(msg: "unexpected bluetooth state (resetting)")
        case .unauthorized:
            throw BleApiError.General(msg: "unexpected bluetooth state (unauthorized)")
        case .unsupported:
            throw BleApiError.General(msg: "unexpected bluetooth state (unsupported)")
        case .unknown:
            throw BleApiError.General(msg: "unexpected bluetooth state (unknown)")
        default:
            throw BleApiError.General(msg: "unknown bluetooth state: \(manager.state)")
        }
        
        return manager
    }
    
    func startScan() throws {
        l("start scan...")
        let manager = try getMananger()

        foundDevices.removeAll()

        // Keep existing connections in foundDevices so that port scan returns them
        for connection in connections.values {
            if let name = connection.peripheral.name {
                foundDevices[name] = connection.peripheral
            }
        }

        manager.scanForPeripherals(withServices: [IO_SERVICE_UUID])
    }
    
    func stopScan() {
        l("stop scan")
        centralManager?.stopScan()
    }
    
    func deviceNames() -> [String] {
        return foundDevices.keys.sorted()
    }
    
    func open(deviceName: String) throws {
        close(deviceName: deviceName)
        l("open device \(deviceName)")
        
        let device: CBPeripheral? = foundDevices[deviceName]
        guard let device = device else {
            throw BleApiError.General(msg: "device not found")
        }

        let manager = try getMananger()
        resFut = CompletableFuture<Bool>()
        device.delegate = self
        manager.connect(device)
        var res = try resFut.get(timeoutSeconds: 60)
        if (!res) {
            throw BleApiError.General(msg: "connection failed")
        }

        let service = (device.services?.first {$0.uuid == IO_SERVICE_UUID})
        guard let service = service else {
            throw BleApiError.General(msg: "can't find main service")
        }
        
        guard let characteristics = service.characteristics else {
            throw BleApiError.General(msg: "can't find characteristics")
        }
        
        for char in characteristics {
            resFut = CompletableFuture<Bool>()
            device.discoverDescriptors(for: char)
            res = try resFut.get(timeoutSeconds: 10)
            if (!res) {
                throw BleApiError.General(msg: "discovering descriptors failed")
            }
        }

        guard let writeChar = (characteristics.first {$0.uuid == IO_TX_CHAR_UUID}) else {
            throw BleApiError.General(msg: "can't find write characteristic")
        }

        guard let readChar = (characteristics.first {$0.uuid == IO_RX_CHAR_UUID}) else {
            throw BleApiError.General(msg: "can't find read characteristic")
        }
        
        resFut = CompletableFuture<Bool>()
        l("unsubscribe from notifications...")
        device.setNotifyValue(false, for: readChar)
        res = try resFut.get(timeoutSeconds: 10)
        if (!res) {
            throw BleApiError.General(msg: "unsubscribe failed")
        }
        
        var failCount = 0
        while (true) {
            resFut = CompletableFuture<Bool>()
            l("subscribe to notifications...")
            device.setNotifyValue(true, for: readChar)
            res = try resFut.get(timeoutSeconds: 10)
            if res {
                break
            }
            failCount += 1
            if (failCount > 3) {
                throw BleApiError.General(msg: "subscribe failed")
            }
            sleep(1)
        }

        let mtu = device.maximumWriteValueLength(for: .withResponse)
        l("maximumWriteValueLength: \(mtu)")

        let connection = Connection(p: device, w: writeChar)
        l("new connection created \(connection)")
        connections[deviceName] = connection

        l("connected succesfully")
    }
    
    func getConnection(deviceName: String) throws -> Connection {
        guard let connection = connections[deviceName] else {
            throw BleApiError.General(msg: "can't find connection \(deviceName)")
        }
        return connection
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            l("write failed: \(error)")
            resFut.complete(false)
            return
        }
        resFut.complete(true)
    }
    
    func write(deviceName: String, buf: Data) throws {
        let connection = try getConnection(deviceName: deviceName)
        resFut = CompletableFuture<Bool>()
        l("write... \(buf.count)")
        connection.peripheral.writeValue(buf, for: connection.writeChar, type: .withResponse)
        let res = try resFut.get(timeoutSeconds: 10)
        if (!res) {
            throw BleApiError.General(msg: "write failed")
        }
        l("write succeed")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        l("received data")
        guard let name = peripheral.name else {
            l("name is nil")
            return
        }
        guard let data = characteristic.value else {
            l("value is nil")
            return
        }
        guard let connection = connections[name] else {
            l("can't find connection with name \(name)")
            return
        }
        connection.appendData(data: data)
    }

    func read(deviceName: String) throws -> Data {
        let connection = try getConnection(deviceName: deviceName)
        if (connection.peripheral.state != .connected) {
            throw BleApiError.General(msg: "device is not connected")
        }
        return connection.takeData()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        l("disconnect event received")
        guard let name = peripheral.name else {
            l("name is nil")
            return
        }
        guard let connection = connections.removeValue(forKey: name) else {
            l("can't find connection with name \(name)")
            return
        }
        l("connection stopped \(connection)")
    }

    func close(deviceName: String) {
        guard let connection = connections[deviceName] else {
            return
        }
        guard let manager = try? getMananger() else {
            l("can't get manager")
            return
        }

        l("Stop connection \(connection)")
        manager.cancelPeripheralConnection(connection.peripheral)
    }
}

func startBle() {
    let bleApi = BleApiImpl_()
    
    let bleClient = BleClient(bleApi: bleApi)
    
    Thread.detachNewThread {
        bleClient.run()
    }
}

func l(_ msg: String) {
    log(msg: msg)
#if DEBUG
    os_log("BLE: %@", log: .default, type: .error, String(describing: msg))
#endif
}
