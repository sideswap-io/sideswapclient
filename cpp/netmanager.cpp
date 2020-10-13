#include "netmanager.h"

#include <QDir>
#include <QJSValue>
#include <QStandardPaths>

#include "appsettings.h"
#include "client_rs_lib.h"


namespace {
    lsw::RpcServer elements(const QString& host, int port, const QString& user, const QString& pass) {
        lsw::RpcServer elements;
        elements.host = host.toStdString();
        elements.port = uint16_t(port);
        elements.login = user.toStdString();
        elements.password = pass.toStdString();
        return elements;
    }

    lsw::StartParams params() {
        auto dataPath = QDir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
        dataPath.mkpath(".");

        lsw::StartParams result;
        result.data_path = dataPath.absolutePath().toStdString();
        return result;
    }
}

NetManager::NetManager(QObject *parent)
    : QObject(parent)
{
    lsw::Callbacks callbacks;

    callbacks.updateStateCb = [this](rust::Str data) {
        auto dataCopy = QString::fromUtf8(data.data(), int(data.length()));
        QMetaObject::invokeMethod(this, [this, dataCopy] {
            emit stateChanged(dataCopy);
        });
    };

    callbacks.updateHistoryCb = [this](rust::Str data) {
        auto dataCopy = QString::fromUtf8(data.data(), int(data.length()));
        QMetaObject::invokeMethod(this, [this, dataCopy] {
            emit historyChanged(dataCopy);
        });
    };

    callbacks.updateWalletinfoCb = [this](rust::Str data) {
        auto dataCopy = QString::fromUtf8(data.data(), int(data.length()));
        QMetaObject::invokeMethod(this, [this, dataCopy] {
            emit walletInfoChanged(dataCopy);
        });
    };

    callbacks.showNotificationCb = [this](rust::Str data) {
        auto dataCopy = QString::fromUtf8(data.data(), int(data.length()));
        QMetaObject::invokeMethod(this, [this, dataCopy] {
            emit showNotificaton(dataCopy);
        });
    };

    callbacks.txBroadcastedCb = [this](rust::Str data) {
        auto dataCopy = QString::fromUtf8(data.data(), int(data.length()));
        QMetaObject::invokeMethod(this, [this, dataCopy] {
            emit txBroadcasted(dataCopy);
        });
    };

    callbacks.updateAssets = [this](rust::Str data) {
        auto dataCopy = QString::fromUtf8(data.data(), int(data.length()));
        QMetaObject::invokeMethod(this, [this, dataCopy] {
            emit assetsChanged(dataCopy);
        });
    };

    callbacks.updateOrders = [this](rust::Str data) {
        auto dataCopy = QString::fromUtf8(data.data(), int(data.length()));
        QMetaObject::invokeMethod(this, [this, dataCopy] {
            emit updateOrders(dataCopy);
        });
    };

    callbacks.updateRfqClient = [this](rust::Str data) {
        auto dataCopy = QString::fromUtf8(data.data(), int(data.length()));
        QMetaObject::invokeMethod(this, [this, dataCopy] {
            emit updateRfqClient(dataCopy);
        });
    };

    callbacks.updateWalletsList = [this](rust::Str data) {
        auto dataCopy = QString::fromUtf8(data.data(), int(data.length()));
        QMetaObject::invokeMethod(this, [this, dataCopy] {
            emit updateWalletsList(dataCopy);
        });
    };

    callbacks.applyWalletsResult = [this](rust::Str data) {
        auto dataCopy = QString::fromUtf8(data.data(), int(data.length()));
        QMetaObject::invokeMethod(this, [this, dataCopy] {
            emit applyWalletsResult(dataCopy);
        });
    };


    lsw::registerCallbacks(std::move(callbacks));

    client_ = std::make_unique<rust::Box<lsw::Client>>(lsw::create(params()));
}

NetManager::~NetManager() = default;

void NetManager::tryAndApply(QString host, int port, QString user, QString pass)
{
    lsw::try_and_apply(**client_, elements(host, port, user, pass));
}

void NetManager::applyConfig(int index)
{
    lsw::apply_config(**client_, index);
}

void NetManager::removeConfig(int index)
{
    lsw::remove_config(**client_, index);
}
