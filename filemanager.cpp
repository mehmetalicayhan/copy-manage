#include <QTextStream>
#include<QDebug>
#include <QRegExp>

#include "filemanager.h"


FileManager::FileManager(QObject *parent) : QObject(parent)
{
    file.setFileName("clipboard.txt");

}


void FileManager::saveFile(QString data){
    QTextStream stream( &file );
    stream <<"[record:]"<<endl<< data <<endl<<"[endrecord:]"<<endl;
}



QString FileManager::readFile(){
   // QRegExp rx("(record:)((.|\\n)*?)(endrecord:)");

    // do parsing in qml with xsame rege return from here the all of the file

    if(!file.isOpen())
        file.open(QIODevice::ReadOnly | QIODevice::Text);

    QString data = file.readAll();
  //  int pos = 0;

  //  while ((pos = rx.indexIn(data, pos)) != -1) {
  //      list << rx.cap(1);
  //      pos += rx.matchedLength();
  //  }

    return data;
}
