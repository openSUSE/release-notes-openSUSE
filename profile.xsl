<?xml version="1.0" ?>
<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- usage: xsltproc -\-stringparam profile.os "slprof;slpers"
                     -\-stringparam profile.arch "x86"
                     profile.xsl file.xml -->

<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/profiling/profile.xsl"/>

<xsl:output method="xml"
            encoding="UTF-8"
            doctype-public="-//OASIS//DTD DocBook XML V4.2//EN"
            doctype-system="http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" />

</xsl:stylesheet>
