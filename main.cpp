#include <QApplication>
#include <QQmlApplicationEngine>
#include<QIcon>

#include <QSystemTrayIcon>
#include <QAction>
#include <QMenu>
#include <QQmlContext>

#include"filemanager.h"
#include"clipboardmanager.h"

void registerQmlClasses(){
    qmlRegisterType<ClipboardManager>("org.mehmetali.clipboard",1,0,"Clipboard");
    qmlRegisterType<FileManager>("org.mehmetali.filemanager",1,0,"FileManager");
}

void addSysTrayIcon(QQmlApplicationEngine* engine) {
    QObject *root = 0;
    if (engine->rootObjects().size() > 0)
    {
        root = engine->rootObjects().at(0);

        QAction *restoreAction = new QAction(QObject::tr("Show  |  Hide"), root);
        root->connect(restoreAction, &QAction::triggered, [=](){
            root->setProperty("visible", !root->property("visible").toBool());
        });

        QAction *quitAction = new QAction(QObject::tr("Quit"), root);
        root->connect(quitAction, SIGNAL(triggered()), qApp, SLOT(quit()));

        QMenu *trayIconMenu = new QMenu();
        trayIconMenu->addAction(restoreAction);
        trayIconMenu->addSeparator();
        trayIconMenu->addAction(quitAction);
        trayIconMenu->setToolTip("copy&manage");

        QSystemTrayIcon *trayIcon = new QSystemTrayIcon(root);
        trayIcon->setContextMenu(trayIconMenu);
        trayIcon->setIcon(QIcon(":/icons/trayIcon.svg"));
        trayIcon->show();
        trayIcon->connect(trayIcon, &QSystemTrayIcon::activated, [=](QSystemTrayIcon::ActivationReason reason){
            if ( reason == QSystemTrayIcon::Trigger || reason == QSystemTrayIcon::DoubleClick){
                root->setProperty("visible", !root->property("visible").toBool());
            }
        });
    }
}

int main(int argc, char *argv[])
{

    QApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/icons/trayIcon.svg"));

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    registerQmlClasses();
    engine.load(url);

    addSysTrayIcon(&engine);

    return app.exec();
}
