#include <mainInit.h>

#include "client_rs_lib.h"

#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    initAppSettings();
    setFont(app);
    initQMLData(engine, app);

    return app.exec();
}
