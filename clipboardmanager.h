#ifndef CLIPBOARDMANAGER_H
#define CLIPBOARDMANAGER_H

#include <QObject>
#include<QClipboard>
#include<QFile>
#include<QMimeData>
#include<QStringList>



#include "filemanager.h"


class ClipboardManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList clipboardList READ clipboardList NOTIFY clipboardChanged)
private:
    QStringList clipboardList() const{
        return ClipboardManager::_cbList;
    }
public:
    ~ClipboardManager();
    QClipboard *cb;
    QStringList _cbList;
    const QMimeData * md;
    QFile file;
    FileManager * fileManager;
    explicit ClipboardManager(QObject *parent = nullptr);
public slots:
    QString getClipboardData();
    void setClipboardData(const QString &text);
signals:
    void clipboardChanged();

};

#endif // CLIPBOARDMANAGER_H
