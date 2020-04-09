#include <QClipboard>
#include <QApplication>
#include<QDebug>
#include <typeinfo>
#include<QMimeData>



#include "clipboardmanager.h"


ClipboardManager::ClipboardManager(QObject *parent) : QObject(parent)
{
    cb = QApplication::clipboard();
    fileManager = new FileManager();
}


QString ClipboardManager::getClipboardData(){
    if (fileManager->file.open(QIODevice::ReadWrite|QIODevice::Append)){
        connect(cb, &QClipboard::dataChanged,[&]
        {
            md = cb->mimeData();

            if(md->hasText()){
                fileManager->saveFile(md->text());
                _cbList.append(md->text());
                emit clipboardChanged();
            }
            else if(md->hasImage()){
                qDebug()<<md->imageData();
            }

        }
        );
    }


    return cb->text();
}


void ClipboardManager::setClipboardData(const QString& text){

    QMimeData * mime = new QMimeData;
    mime->setText(text);
    cb->setMimeData(mime,QClipboard::Clipboard);
    fileManager->readFile();

}

ClipboardManager::~ClipboardManager(){
    delete fileManager;
}
