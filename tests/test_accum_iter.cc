#include <sigc++/sigc++.h>
#include <iostream>
#include <algorithm>
#include <functional>

#include <new>
SIGC_USING_STD(new)

static int ident(int i)
{
    return i;
}

template<typename T>
struct min_accum
{
    typedef T result_type;

    template<class I>
#ifndef SIGC_HAVE_SUN_REVERSE_ITERATOR  
        typename std::iterator_traits<I>::value_type operator()(I i1, I i2)
#else
        typename I::value_type operator()(I i1, I i2)
#endif  
        {
            return *std::min_element(i1, i2);
        }
};

int main()
{
    sigc::signal0<int,min_accum<int> > signal;

    signal.connect(
            sigc::bind(sigc::ptr_fun(ident), 3));
    signal.connect(
            sigc::bind(sigc::ptr_fun(ident), 1));
    signal.connect(
            sigc::bind(sigc::ptr_fun(ident), 42));

    int rv = signal();
    std::cout <<rv <<std::endl;
    if (rv != 1)
        return 1;
    else
        return 0;
}
