#ifndef ADDRESSVERIFICATIONHELPER_H
#define ADDRESSVERIFICATIONHELPER_H

#include <QObject>
#include <QJSValue>

class AddressVerificationHelper : public QObject
{
    Q_OBJECT
public:
    AddressVerificationHelper(QObject *parent = nullptr);
    ~AddressVerificationHelper() override = default;

    Q_INVOKABLE QString getScan(QString addr);
};

#endif // ADDRESSVERIFICATIONHELPER_H
