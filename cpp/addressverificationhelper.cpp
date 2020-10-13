#include "addressverificationhelper.h"

#include "client_rs_gen.h"
#include "appsettings.h"

AddressVerificationHelper::AddressVerificationHelper(QObject *parent)
    : QObject(parent)
{
}

QString AddressVerificationHelper::getScan(QString addr)
{
    auto str = addr.toStdString();
    return lsw::get_qr_code(str).data();
}
