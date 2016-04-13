#ifndef _SIGC_TUPLE_VISITOR_VISIT_EACH_H_
#define _SIGC_TUPLE_VISITOR_VISIT_EACH_H_

#include <tuple>

namespace sigc
{

namespace internal
{

#ifndef DOXYGEN_SHOULD_SKIP_THIS
template <typename T_element>
struct TupleVisitorVisitEach
{
  template <typename T_action>
  constexpr static void visit(const T_element& element, T_action&& action)
  {
    sigc::visit_each(std::forward<T_action>(action), element);
  }
};
#endif // DOXYGEN_SHOULD_SKIP_THIS

} // namespace internal

} // namespace sigc

#endif /* _SIGC_TUPLE_VISITOR_VISIT_EACH_H_ */
