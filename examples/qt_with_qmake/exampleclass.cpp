#include <QCoreApplication>

#include "exampleclass.h"

ExampleClass::ExampleClass(QObject *parent) :
    QObject(parent)
{
    /* Create a slot from our example_slot method. */
    m_sigc_slot = sigc::mem_fun( *this, &ExampleClass::example_slot );

    /* Connect our sigc++ signal to our sigc++ slot */
    m_sigc_signal.connect( m_sigc_slot );

    /* Emit a sigc++ signal */
    m_sigc_signal.emit();

    /* Connect the Qt signal to our Qt slot */
    connect( &m_timer, &QTimer::timeout,
             this, &ExampleClass::timer_slot );
    m_timer.start( 200 );

    /* Emit a Qt signal */
    Q_EMIT example_signal();
}

void ExampleClass::timer_slot(){
    qDebug() << "Timer slot called";

    QCoreApplication::exit( 0 );
}

void ExampleClass::example_slot(){
    qDebug() << "Example slot called";
}
