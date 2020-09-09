#include "addressverificationhelper.h"

#include "client_rs_gen.h"
#include "appsettings.h"

AddressVerificationHelper::AddressVerificationHelper(QObject *parent)
    : QObject(parent)
{
}

void AddressVerificationHelper::checkXBTAddress(const QString &btcAddress, QJSValue jsCallback)
{
    auto str = btcAddress.toStdString();
    QJSValueList args;
    args << QJSValue(lsw::check_xbt_address(str, AppSettings::get()->mainnet()));
    jsCallback.call(args);
}

void AddressVerificationHelper::checkLBTCAddress(const QString &lbtcAddress, QJSValue jsCallback)
{
    auto str = lbtcAddress.toStdString();
    QJSValueList args;
    args << QJSValue(lsw::check_elements_address(str, AppSettings::get()->mainnet()));
    jsCallback.call(args);
}

QString AddressVerificationHelper::getScan(QString addr)
{
    auto str = addr.toStdString();
    return lsw::get_qr_code(str).data();
}
