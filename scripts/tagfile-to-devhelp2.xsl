<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.devhelp.net/book"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--
  Copyright (c) 2009  Daniel Elstner <daniel.kitta@gmail.com>

  XSL transformation from a Doxygen tag file to DevHelp 2 format.

  This script is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published
  by the Free Software Foundation, either version 2 of the License,
  or (at your option) any later version.

  This script is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this script.  If not, see <http://www.gnu.org/licenses/>.
  -->
  <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8"/>

  <xsl:param name="book_title"/>
  <xsl:param name="book_name"/>
  <xsl:param name="book_base"/>

  <xsl:template match="/">
    <book title="{$book_title}" name="{$book_name}" base="{$book_base}"
          link="index.html" version="2" language="c++">
      <chapters>
        <sub name="Classes" link="classes.html">
          <xsl:apply-templates select="tagfile/compound[@kind='class' or @kind='struct']" mode="sub">
            <xsl:sort lang="en" case-order="upper-first" select="name"/>
          </xsl:apply-templates>
        </sub>
        <sub name="Namespaces" link="namespaces.html">
          <xsl:apply-templates select="tagfile/compound[@kind='namespace']" mode="sub">
            <xsl:sort lang="en" case-order="upper-first" select="name"/>
          </xsl:apply-templates>
        </sub>
      </chapters>
      <functions>
        <xsl:apply-templates select="tagfile/compound|tagfile/compound/member" mode="keyword">
          <xsl:sort lang="en" select="concat(../name, '::', name)"/>
        </xsl:apply-templates>
      </functions>
    </book>
  </xsl:template>

  <xsl:template match="compound" mode="sub">
    <sub name="{name}" link="{filename}"/>
  </xsl:template>

  <xsl:template match="compound[@kind='class' or @kind='struct']" mode="keyword">
    <keyword type="struct" name="{name}" link="{filename}"/>
  </xsl:template>
  <xsl:template match="member[@kind='function' or @kind='typedef']" mode="keyword">
    <keyword type="{@kind}" xsl:use-attribute-sets="keyword-member"/>
  </xsl:template>
  <xsl:template match="member[@kind='enumeration']" mode="keyword">
    <keyword type="enum" xsl:use-attribute-sets="keyword-member"/>
  </xsl:template>
  <xsl:template match="member[@kind='enumvalue' or @kind='define']" mode="keyword">
    <keyword type="macro" xsl:use-attribute-sets="keyword-member"/>
  </xsl:template>
  <!-- Ignore keywords of unknown type -->
  <xsl:template match="*" mode="keyword"/>

  <xsl:attribute-set name="keyword-member">
    <xsl:attribute name="name">
      <xsl:value-of select="concat(../name, '::', name)"/>
    </xsl:attribute>
    <xsl:attribute name="link">
      <xsl:value-of select="concat(anchorfile, '#', anchor)"/>
    </xsl:attribute>
  </xsl:attribute-set>

</xsl:stylesheet>
