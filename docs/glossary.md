---
layout: default
title: Glossary of Terms
---

**adaptor** *(noun)* - A function which alters a slot&#8217;s
signature.  

**bind** *(verb)* - To fix a value of a callback's argument in the
STL sense.  

**call** *(verb)* - The process of invoking a callback or slot.  

**callback** *(noun)* - A function or a member function which will
be called when a signal is emitted. A slot specifies the callback and any extra
data, such as the object instance, and extra parameters. 

**connect** *(verb)* - The process of specifying the callback
which will be called when the signal is emitted. 

**emit** *(verb)* - When a signal is emitted, the connected slots
will be called.  

**factory** *(noun)* - A function which takes a set of arguments and 
produces a different object based on those arguments.  

**handle** *(noun)* - A safe version of a pointer.  

**marshaller** *(noun)* -  When a signal has a return value, and
several slots are connected to that signal, each one returning a value, then a
marshaller chooses one single return value. 

**safe** *(adj)* - Any structure which falls back into uninitalized state 
when its related resources are destroyed.  Safe resources can be
held throughout the program. Unsafe resources may point to freed
memory.  

**signal** *(noun)* - An object to which callback slots can be
connected. When the signal is emitted, each callback will be invoked. The
signal and the connected slots have a specific return type and parameter types.

**signal handler** *(noun)* - Another name for a callback.   

**signature** *(noun)* - The return type of a function together with
the argument types of that function.  

**slot** *(noun)* - A safe version of a callback.  
