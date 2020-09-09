#ifndef CLIPBOARDHELPER_H
#define CLIPBOARDHELPER_H

#include <QObject>

class ClipboardHelper : public QObject
{
    Q_OBJECT
public:
    ClipboardHelper(QObject *parent = nullptr);
    ~ClipboardHelper() override = default;

    Q_INVOKABLE void copy(QString text);
    Q_INVOKABLE QString get() const;
    Q_INVOKABLE bool empty() const;
};

#endif // CLIPBOARDHELPER_H
