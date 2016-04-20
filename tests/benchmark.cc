#include <iostream>
#include <sigc++/signal.h>
#include <sigc++/functors/mem_fun.h>
#include <glibmm/timeval.h>

using namespace std;
using namespace sigc;
using namespace sigc::functor;

struct foo : public trackable
{
  int bar(int a);
  int c;
};

int foo::bar(int a)
{
  int b = c;
  c = a;
  return b;
}

int main()
{
  Glib::TimeVal t1, t2;

  foo foobar1, foobar2, foobar3, foobar4, foobar5;
  closure<int,int> slot;
  signal<int,int> emitter;
  signal<int,int>::iterator it;


  // slot benchmark ...

  slot = mem_fun(&foobar1, &foo::bar);

  t1.assign_current_time();

  for (int i=0; i < 5000; ++i)
    slot(i);

  t2.assign_current_time();
  t2.subtract(t1);

  cout << "elapsed time for calling a slot 5000 times: " << t2.tv_sec << "s " << t2.tv_usec << "us" << endl;


  // emission benchmark (zero slots) ...

  t1.assign_current_time();

  for (int i=0; i < 1000; ++i)
    emitter(i);

  t2.assign_current_time();
  t2.subtract(t1);

  cout << "elapsed time for 1000 emissions (0 slots): " << t2.tv_sec << "s " << t2.tv_usec << "us" << endl;


  // emission benchmark (one slot) ...

  emitter.connect(mem_fun(&foobar1, &foo::bar));

  t1.assign_current_time();

  for (int i=0; i < 1000; ++i)
    emitter(i);

  t2.assign_current_time();
  t2.subtract(t1);

  cout << "elapsed time for 1000 emissions (1 slot): " << t2.tv_sec << "s " << t2.tv_usec << "us" << endl;


  // emission benchmark (five slot) ...

  emitter.connect(mem_fun(&foobar2, &foo::bar));
  emitter.connect(mem_fun(&foobar3, &foo::bar));
  emitter.connect(mem_fun(&foobar4, &foo::bar));
  emitter.connect(mem_fun(&foobar5, &foo::bar));

  t1.assign_current_time();

  for (int i=0; i < 1000; ++i)
    emitter(i);

  t2.assign_current_time();
  t2.subtract(t1);

  cout << "elapsed time for 1000 emissions (5 slots): " << t2.tv_sec << "s " << t2.tv_usec << "us" << endl;


  // connection / disconnection benchmark ...

  emitter.clear();

  t1.assign_current_time();

  for (int i=0; i < 1000; ++i)
    {
      it = emitter.connect(mem_fun(&foobar1, &foo::bar));
      it->disconnect();
    }

  t2.assign_current_time();
  t2.subtract(t1);

  cout << "elapsed time for 1000 connections/disconnections: " << t2.tv_sec << "s " << t2.tv_usec << "us" << endl;

}
