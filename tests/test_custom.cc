#include <sigc++/sigc++.h>
#include <iostream>
#include <string>
#include <sigc++/sigc++.h>

class BaseDialog;

void test_cast_basedialog(BaseDialog* base);

template <class T_Derived>
void test_cast(T_Derived* base)
{
  std::cout << "  test_cast() base=" << base << std::endl;
  sigc::trackable* trackable = base;
  std::cout << "  test_cast() (trackable*)base=" << trackable << std::endl;
}

class Foo
{
public:
	virtual ~Foo()
        {
          std::cout << "~Foo this=" << this << std::endl;
        }

        //int i;
};

class BaseDialog : virtual public sigc::trackable
{
public:
	BaseDialog()
        {
          std::cout << "BaseDialog::BaseDialog this=" << this << std::endl;
          test_cast(this);
        }

	virtual ~BaseDialog()
        {
          std::cout << "~BaseDialog this=" << this << std::endl;
          test_cast(this);
        }

	sigc::signal<void> clicked;
};

class SpecificDialog
	: virtual public BaseDialog,
	  /* virtual */ public Foo
{
public:
	SpecificDialog()
        : sigc::trackable()
	{
          std::cout << "SpecificDialog::SpecificDialog this=" << this << std::endl;
          test_cast(this);

          clicked.connect(sigc::mem_fun(this, &SpecificDialog::OnClicked));
	}

	virtual ~SpecificDialog()
	{
          std::cout << "~SpecificDialog this=" << this << std::endl;
          test_cast(this);

		// This would fix the crash:
		// notify_callbacks();
	}

private:
	void OnClicked()
	{
                std::cout << "OnClicked 1" << std::endl;
		delete this;
                std::cout << "OnClicked 2" << std::endl;
	}
};


int
main(int argc, char **argv)
{
	SpecificDialog *dlg = new SpecificDialog();
        //delete dlg;

        std::cout << "main 1" << std::endl;
	dlg->clicked.emit();
        std::cout << "main 2" << std::endl;

	return 0;
}

