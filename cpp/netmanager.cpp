#include "netmanager.h"

#include <QStandardPaths>
#include <QDir>

#include "appsettings.h"
#include "client_rs_lib.h"


namespace {
    lsw::RpcServer elements(const QString& host, int port, const QString& user, const QString& pass) {
        lsw::RpcServer elements;
        elements.host = host.toStdString();
        elements.port = port;
        elements.login = user.toStdString();
        elements.password = pass.toStdString();
        return elements;
    }

    lsw::StartParams params() {
        auto appData = QDir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
        appData.mkpath(".");

        lsw::StartParams result;
        result.host = AppSettings::get()->host().toStdString();
        result.port = AppSettings::get()->port();
        result.use_tls = AppSettings::get()->useTls();
        result.mainnet = AppSettings::get()->mainnet();
        result.db_path = appData.filePath("data.db").toStdString();
        result.is_dealer = false;
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

NetManager::~NetManager() = default;
