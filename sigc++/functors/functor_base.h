#ifndef _SIGC_FUNCTORS_FUNCTOR_BASE_H_
#define _SIGC_FUNCTORS_FUNCTOR_BASE_H_

namespace sigc {

/** A hint to the compiler.
 * All functors which define @p result_type should publically inherit from this hint.
 *
 * @ingroup sigcfunctors
 */
struct functor_base {};


} /* namespace sigc */
#endif /* _SIGC_FUNCTORS_FUNCTOR_BASE_H_ */
