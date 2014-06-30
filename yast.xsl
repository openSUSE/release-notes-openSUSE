<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'
                xml:lang="en">

<xsl:output omit-xml-declaration = "yes" 
            encoding = "UTF-8" />

<xsl:template match="sect1/title">
  <h1><xsl:apply-templates /></h1>
</xsl:template>
<xsl:template match="sect2/title">
  <h2><xsl:apply-templates /></h2>
</xsl:template>
<xsl:template match="sect3/title">
  <h3><xsl:apply-templates /></h3>
</xsl:template>

<!-- remove remark unconditionally -->
<xsl:template match="remark">
<xsl:text></xsl:text>
</xsl:template>

<xsl:template match="para">
  <p><xsl:apply-templates /></p>
</xsl:template>

<xsl:template match="screen">
  <pre><xsl:apply-templates /></pre>
</xsl:template>

<xsl:template match="itemizedlist">
  <ul><xsl:apply-templates /></ul>
</xsl:template>
<xsl:template match="orderedlist">
  <ol><xsl:apply-templates /></ol>
</xsl:template>
<xsl:template match="listitem">
  <li><xsl:apply-templates /></li>
</xsl:template>

<xsl:template match="command|filename|literal|option|systemitem">
  <tt><xsl:apply-templates /></tt>
</xsl:template>
<xsl:template match="ulink">
  <tt><xsl:value-of select="@url" /></tt>
</xsl:template>

<xsl:template match="emphasis">
  <b><xsl:apply-templates /></b>
</xsl:template>

<xsl:template match="quote">
  "<xsl:apply-templates />"
</xsl:template>

</xsl:stylesheet>
