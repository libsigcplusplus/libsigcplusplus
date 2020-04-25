#ifndef EXAMPLECLASS_H
#define EXAMPLECLASS_H

#include <QObject>
#include <QTimer>
#include <QDebug>

#include <sigc++/sigc++.h>

class ExampleClass : public QObject
{
  Q_OBJECT
public:
  explicit ExampleClass(QObject* parent = nullptr);

  /* Instead of using the keyword 'signals', use the 'Q_SIGNALS' macro */
Q_SIGNALS:
  void example_signal();

  /* Instead of using the keyword 'slots', use the 'Q_SLOTS' macro */
public Q_SLOTS:
  void timer_slot();

  /**
   * This slot is called using libsigc++, however since it is defined under Q_SLOTS
   * it could also be used with the Qt signals/slots
   */
  void example_slot();

private:
  sigc::slot<void()> m_sigc_slot;
  sigc::signal<void()> m_sigc_signal;
  QTimer m_timer;
};

#endif // EXAMPLECLASS_H
