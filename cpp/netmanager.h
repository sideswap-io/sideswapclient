#ifndef SWAPNETWORKMANAGER_H
#define SWAPNETWORKMANAGER_H

#include "client_rs_gen.h"

#include <memory>
#include <variant>
#include <functional>
#include <QObject>
#include <QJSValue>

using BoolCb = std::function<void(bool)>;
using VariantCb= std::variant<BoolCb>;

class NetManager : public QObject
{
    Q_OBJECT

public:
    NetManager(QObject *parent = nullptr);
    ~NetManager() override;

    Q_INVOKABLE void toggle()
    {
        lsw::pegin_toggle(**client_);
    }

    Q_INVOKABLE void startPeg(QString addr)
    {
        lsw::start_peg(**client_, addr.toStdString());
    }

    Q_INVOKABLE void pegBack()
    {
        lsw::peg_back(**client_);
    }

    Q_INVOKABLE void setPassword(QString pass)
    {
        lsw::wallet_password(**client_, pass.toStdString());
    }

    Q_INVOKABLE void cancelPassword()
    {
        lsw::cancel_passphrase(**client_);
    }

    Q_INVOKABLE void createRfq(QString sellCurrency, qint64 sellAmount, QString receiveCurrency)
    {
        lsw::rfq(**client_,
                 sellCurrency.toStdString(),
                 static_cast<int64_t>(sellAmount),
                 receiveCurrency.toStdString());
    }

    Q_INVOKABLE void quoteRfq(QString orderId, qint64 proposal)
    {
        lsw::quote(**client_, orderId.toStdString(), static_cast<int64_t>(proposal));
    }

    Q_INVOKABLE void cancelRfq(QString orderId)
    {
        lsw::rfq_cancel(**client_, orderId.toStdString());
    }

    Q_INVOKABLE void swapCancel()
    {
        lsw::swap_cancel(**client_);
    }

    Q_INVOKABLE void swapAccept()
    {
        lsw::swap_accept(**client_);
    }

    Q_INVOKABLE void tryAndApply(QString host, int port, QString user, QString pass);
    Q_INVOKABLE void applyConfig(int index);
    Q_INVOKABLE void removeConfig(int index);

signals:
    // callbacks
    void stateChanged(QString data);
    void historyChanged(QString data);
    void walletInfoChanged(QString data);
    void showNotificaton(QString data);
    void txBroadcasted(QString data);
    void assetsChanged(QString data);
    void updateOrders(QString data);
    void updateRfqClient(QString data);
    void updateWalletsList(QString data);
    void applyWalletsResult(QString data);

private:
    std::unique_ptr<rust::Box<lsw::Client>> client_;
};

#endif // SWAPNETWORKMANAGER_H
