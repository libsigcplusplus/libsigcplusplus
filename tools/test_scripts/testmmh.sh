#!/bin/bash

# Check if all header files are included in file sigc++/sigc++.h.

# For each file sigc++/*/<name>.h except sigc++/sigc++.h, check if
# sigc++/*/<name>.h is included in sigc++/sigc++.h.
# If the file is not included in sigc++/sigc++.h, search for inclusion
# in any of the files sigc++/*/<name>.h. Thus you can see if it's included
# indirectly via another header file.

# Some manual checking of sigc++/sigc++.h is usually necessary.
# Perhaps some header files shall not be included, such as files that only
# contain API in namespace sigc::internal.
# Other header files shall perhaps be surrounded by #ifdef/#ifndef/#endif
# directives.

dir=sigc++
file=sigc++.h

# If sigc++/adaptors/adaptors.h and sigc++/functors/functors.h are included
# by sigc++/sigc++.h, don't report a file as missing if it is included by
# sigc++/adaptors/adaptors.h or sigc++/functors/functors.h.
extra_files=
for headerfile in $dir/adaptors/adaptors.h $dir/functors/functors.h
do
  h2="${headerfile//./\.}" # Replace each "." by "\."
  grep -q  "^ *# *include  *<$h2>" $dir/$file
  if [ $? -eq 0 ]
  then
    extra_files="$extra_files $headerfile"
  fi
done

for headerfile in $dir/*.h $dir/*/*.h
do
  if [ $headerfile != $dir/$file ]
  then
    h2="${headerfile//./\.}" # Replace each "." by "\."
    echo "=== $headerfile"
    grep -q  "^ *# *include  *<$h2>" $dir/$file $extra_files
    if [ $? -ne 0 ]
    then
      echo "  Missing"
      grep "<$h2>" $dir/*.h $dir/*/*.h
    fi
  fi
done

exit 0
