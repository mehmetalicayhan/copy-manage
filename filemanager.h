#ifndef FILEMANAGER_H
#define FILEMANAGER_H

#include <QObject>
#include<QFile>


class FileManager : public QObject
{
    Q_OBJECT
public:
    void saveFile(QString fileData);
    QFile file;
    explicit FileManager(QObject *parent = nullptr);

signals:

public slots:
    QString readFile();
};

#endif // FILEMANAGER_H
