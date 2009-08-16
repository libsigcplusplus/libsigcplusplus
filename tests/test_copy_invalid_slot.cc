#include <iostream>
#include <cstdlib>
#include <cstring>
#include <sigc++/sigc++.h>

#include <stdlib.h>
#include <string.h>

static void Foo(sigc::trackable&) {}

int main(int, char**)
{
   sigc::trackable *t = new sigc::trackable();
   std::cout << "sigc::trackable instance at " << t << std::endl;
   sigc::slot<void> foo = sigc::bind(sigc::ptr_fun(Foo), sigc::ref(*t));
   // This invalidates foo.
   delete t;

   // Try to crash if the invalid slot parameter is used by libsigc++,
   // and get a debugger backtrace at the point that it happens.
   //
   // Comment this out to get a meaningful backtrace from valgrind.
   //
   // Try to pollute the memory previously occupied by the sigc::trackable
   // instance. The hope is that with a regular memory allocator (i.e. not
   // valgrind), we end up with buffer == (void *)t.
   void *buffer = malloc(sizeof(sigc::trackable));
   memset(buffer, 0xFF, sizeof(sigc::trackable));
   std::cout << "         Polluted buffer at " << buffer << std::endl;

   // Now copy foo: up to libsigc++ version 2.0.11, the copy constructor fails
   // because the pointer value it dereferences does not point to a
   // sigc::trackable anymore, it now points to a polluted buffer.
   sigc::slot<void> bar = foo;

   free(buffer);
   return 0;
}
