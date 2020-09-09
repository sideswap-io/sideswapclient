#include "clipboardhelper.h"
#include <QGuiApplication>
#include <QClipboard>


ClipboardHelper::ClipboardHelper(QObject *parent /* = nullptr*/)
    : QObject(parent)
{
}

void ClipboardHelper::copy(QString text)
{
    auto* clipboard = qApp->clipboard();
    clipboard->setText(text);
}

QString ClipboardHelper::get() const
{
    auto* clipboard = qApp->clipboard();
    return clipboard->text();
}

bool ClipboardHelper::empty() const
{
    return qApp->clipboard()->text().isEmpty();
}
