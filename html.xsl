<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'
                xml:lang="en">

 <xsl:output omit-xml-declaration = "yes" 
              indent="yes"
              encoding = "UTF-8"
              doctype-public= "-//W3C//DTD HTML 4.01//EN"
              method = "html"
              />

 <xsl:include href="yast.xsl"/>

 <xsl:template match="sect1">
    <html>
      <head>
        <title>
          <xsl:value-of select="title" />
        </title>
      </head>
      <body>
        <xsl:apply-templates />
      </body>
    </html>
 </xsl:template>

 <xsl:template match="sect1/para[position()=last()]">
    <!-- At the end of the init blub append are simple TOC -->
    <p><xsl:apply-templates /></p>
    <div>
      <dl>
        <xsl:for-each select="//sect2">
          <dt>
            <!-- <xsl:value-of select="position()"/> -->
            <xsl:value-of select="title"/>
          </dt>
          <dd>
            <ol>
              <xsl:choose>
                <xsl:when test = "sect3">
                  <xsl:for-each select="sect3">
                    <li>
                      <a>
                        <xsl:attribute name="href">
                          <xsl:text>#</xsl:text>
                          <xsl:number value="count(preceding::sect3)+1"
                                      format="01"/>
                        </xsl:attribute>
                        <xsl:value-of select="title"/>
                      </a>
                    </li>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <!-- In case a section is empty, at least a para must
                       be supplied. -->
                  <li>
                    <xsl:value-of select="para"/>
                  </li>
                </xsl:otherwise>
              </xsl:choose>
            </ol>
          </dd>
        </xsl:for-each>
      </dl>
      <hr />
    </div>
 </xsl:template>

 <xsl:template match="sect2|sect3">
    <div>
      <xsl:apply-templates />
    </div>
 </xsl:template>

 <xsl:template match="sect3/title">
  <h3>
    <a>
      <xsl:attribute name="name">
        <xsl:number value="count(preceding::sect3)+1"
                    format="01"/>
      </xsl:attribute>
      <xsl:apply-templates />
    </a>
  </h3>
 </xsl:template>

 <xsl:template match="ulink">
  <a>
   <xsl:attribute name="href">
    <xsl:value-of select="@url" />
   </xsl:attribute>
   <xsl:value-of select="@url" />
  </a>
 </xsl:template>

</xsl:stylesheet>
