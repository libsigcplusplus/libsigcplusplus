// Configuration-time test program, used in Meson build.
// Corresponds to the M4 macro SIGC_CXX_PRAGMA_PUSH_POP_MACRO.

#define BEGIN {
#define END   }
#pragma push_macro("BEGIN")
#pragma push_macro("END")
#undef BEGIN
#undef END

// BEGIN and END are not prepreprocessor macros
struct Test1
{
  int BEGIN;
  double END;
};

#pragma pop_macro("BEGIN")
#pragma pop_macro("END")

// BEGIN and END are prepreprocessor macros
struct Test2
BEGIN
  int i;
  double d;
END;

void func1(Test1& x);
void func2(Test2& x);

int main()
{
  Test1 test1;
  Test2 test2;
  func1(test1);
  func2(test2);
  return 0;
}
