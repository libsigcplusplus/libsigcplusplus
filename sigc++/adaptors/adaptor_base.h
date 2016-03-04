#ifndef _SIGC_ADAPTORS_DEDUCE_RESULT_TYPE_H_
#define _SIGC_ADAPTORS_DEDUCE_RESULT_TYPE_H_

namespace sigc {

//TODO: Is this necessary now that we don't need deduce_result_type?
/** A hint to the compiler.
 * Functors which have all methods based on templates
 * should publicly inherit from this hint.
 *
 * adaptor_base inherits from the functor_base hint so
 * derived types should also have a result_type defined.
 *
 * Adaptors don't inherit from this type directly. They use
 * use sigc::adapts as a base type instead. sigc::adaptors
 * wraps arbitrary functor types as well as function pointers
 * and class methods.
 *
 * @ingroup adaptors
 */
struct adaptor_base : public functor_base {};

} /* namespace sigc */
#endif /* _SIGC_ADAPTORS_DEDUCE_RESULT_TYPE_H_ */
