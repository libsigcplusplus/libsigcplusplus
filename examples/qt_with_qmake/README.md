# libsigc++ with Qt

It is possible to use libsigc++ with Qt.  However, because of the signals/slots
mechanism of Qt, there is some setup that must be done in order for this to
happen correctly.

The official Qt documentation may be found here: https://doc.qt.io/qt-5/signalsandslots.html#using-qt-with-3rd-party-signals-and-slots

Steps to use libsigc++ with Qt:
1. In your .pro file, add `CONFIG += no_keywords`.  This configures Qt to not
define the macros `emit`, `signals`, and `slot`.  These are keywords for moc,
which preprocesses the source files in order to use Qt signals/slots.
2. In your header files, change the `signals:` section of your class to instead
be `Q_SIGNALS`
3. In your header files, change the `public slots:` section of your class to
instead be `public Q_SLOTS:`
4. In any class that you emit a signal, change `emit` to be `Q_EMIT`.

In general, using the Q\_ macros is a good idea if your code is a library
intended to be used by people other than yourself, as they may be using
code(e.g. libsigc++/boost signals) that will conflict with Qt(moc) keywords.

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

# Other Build Systems
If you are not using qmake to build your Qt project, you must tell your
buildsystem to define `QT_NO_KEYWORDS`.  If you're using CMake, this may
be done like the following:

```
add_definitions(-DQT_NO_KEYWORDS)
```

or in a more modern CMake way:

```
target_compile_definitions(some_target PRIVATE QT_NO_KEYWORDS)
```
