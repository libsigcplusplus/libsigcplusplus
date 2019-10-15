#include <QCoreApplication>
#include <QTimer>

#include "exampleclass.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    ExampleClass ex;

    return a.exec();
}
