# libsigc++ with Qt

It is possible to use libsigc++ with Qt.  However, because of the signals/slots
mechanism of Qt, there is some setup that must be done in order for this to
happen correctly.

Steps to use libsigc++ with Qt:
1. In your .pro file, add `CONFIG += no_keywords`.  This configures Qt to not
define the keywords `emit`, `signals`, and `slot`.
2. In your header files, change the `signals:` section of your class to instead
be `Q_SIGNALS`
3. In your header files, change the `public slots:` section of your class to
instead be `public Q_SLOTS:`
4. In any class that you emit a signal, change `emit` to be `Q_EMIT`.

Here's an example of a class before and after this conversion(note: irrelevant
code has been removed):

```
class ExampleClass : public QObject {
signals:
	void exampleSignal();
public slots:
	void example_slot(){
		emit exampleSignal();
	}
};
```

After conversion:
```
class ExampleClass : public QObject {
Q_SIGNALS:
	void exampleSignal();
public Q_SLOTS:
	void example_slot(){
		Q_EMIT exampleSignal();
	}
};
```

## Qt Slots Notes
Since libsigc++ simply requires a slot to be a function, you can call Qt
slots easily using libsigc++.  Similarly, a function that is a libsigc++ slot
can also be used as a Qt slot.
