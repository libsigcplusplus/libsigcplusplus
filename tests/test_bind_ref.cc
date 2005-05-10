#include <sigc++/sigc++.h>
#include <iostream>
#include <string>


class Param : public sigc::trackable
{
public:
  Param(const std::string& name)
  : name_(name)
  {}

  std::string name_;

private:
  //non-copyable, so it can only be used with sigc::bind() via sigc::ref()
  Param(const Param&);
  Param& operator=(const Param&);
};


void handler(Param& param)
{
  std::cout << "  handler(param): param.name_=" << param.name_ << std::endl;
}


int main()
{
  sigc::slot<void, Param &> slot_full = sigc::ptr_fun(&handler);
  sigc::slot<void> slot_bound;

  //slot_bound();

  {
    //Because Param derives from sigc::trackable(), sigc::ref() should disconnect the signal handler when param is destroyed.
    Param param("murrayc");
    // A convoluted way to do
    // slot_bound = sigc::bind(slot_full, sigc::ref(param));
    slot_bound = sigc::bind< -1, sigc::reference_wrapper<Param> >(slot_full, sigc::ref(param));

    std::cout << "Calling slot when param exists:" << std::endl;
    slot_bound();
  }    // auto-disconnect

  
  std::cout << "Calling slot when param does not exist:" << std::endl;
  slot_bound();
  // This causes a crash when using g++ 3.3.4 or 3.3.5 (but not 3.4.x) when not specifying the exact template
  // specialization in visit_each_type() - see the comments there.
  // It looks like the auto-disconnect does not work, so the last sl() call tries to access the guest_book data again.
}
