#include <QCoreApplication>

#include "exampleclass.h"

ExampleClass::ExampleClass(QObject *parent) :
    QObject(parent),
    m_times(0)
{
    /* Create a slot from our example_slot method. */
    m_slot = sigc::mem_fun( *this, &ExampleClass::example_slot );

    connect( &m_timer, &QTimer::timeout,
             this, &ExampleClass::timer_slot );
    m_timer.start( 200 );
}

void ExampleClass::timer_slot(){
    qDebug() << "Timer slot called";

    /* Call the slot that is used by libsigc++ */
    m_slot();

    /* Emit a Qt signal */
    Q_EMIT example_signal();

    /* Only run for a few times before exiting */
    if( m_times++ > 10 ){
        QCoreApplication::exit( 0 );
    }
}

void ExampleClass::example_slot(){
    qDebug() << "Example slot called";
}
