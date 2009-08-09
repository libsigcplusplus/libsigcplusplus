package main;

# Copyright (c) 2009  Daniel Elstner <daniel.kitta@gmail.com>
#
# This file is part of mm-common.
#
# mm-common is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 2 of the License,
# or (at your option) any later version.
#
# mm-common is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with mm-common.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;
use bytes;

foreach my $filename (map(glob, @ARGV))
{
  my @outbuf = ();
  my $file;

  open($file, '<', $filename);

  while (<$file>)
  {
    if (/<a class="el"/)
    {
      # return value
      s/ &amp;&nbsp;/&amp;&#160;/;
      s/ \*&nbsp;/*&#160;/;

      # parameters
      s/ &amp;/&amp;/g;
      s/&amp;\b/&amp; /g;
      s/ \*/*/g;
      s/\*\b/* /g;

      # templates
      s/\btemplate&lt;/template &lt;/;
    }
    elsif (/<td class="md(?:name)?"/)
    {
      # left parenthesis
      s/\(&nbsp;/(/;

      # return value
      s/ &amp; /&amp; /g;
      s/ \* /* /g;

      # parameters
      s/ &amp;&nbsp;/&amp;&#160;/g;
      s/ \*&nbsp;/*&#160;/g;

      # templates
      s/\btemplate&lt;/template &lt;/;
    }
    else
    {
      # template decls
      s/^(<h\d>|)template&lt;/$1template &lt;/;
    }
    s/&nbsp;/&#160;/g;

    push(@outbuf, $_);
  }
  close($file);

  # write the whole buffer back
  open($file, '>', $filename);
  print $file ($_) foreach (@outbuf);
  close($file);
}

exit;
