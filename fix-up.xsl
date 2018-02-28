<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:db="http://docbook.org/ns/docbook"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:dm="urn:x-suse:ns:docmanager">

  <xsl:param name="version" select="''"/>

  <xsl:param name="dmurl" select="''"/>
  <xsl:param name="dmproduct" select="''"/>
  <xsl:param name="dmcomponent" select="''"/>
  <xsl:param name="dmassignee" select="''"/>


  <xsl:template match="node() | @*" name="copy">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>


  <!-- Use the correct version number -->
  <xsl:template match="db:releaseinfo">
    <xsl:if test="$version != ''">
      <releaseinfo><xsl:value-of select="$version"/></releaseinfo>
    </xsl:if>
  </xsl:template>

  <!-- While itstool can translate to xlink:href just fine, some translations
  may need work in this area. -->
  <xsl:template match="@*[local-name() = 'href']">
    <xsl:attribute name="xlink:href"><xsl:value-of select="."/></xsl:attribute>
  </xsl:template>

  <!-- This might help for the DocBook 4->5 transition period. -->
  <xsl:template match="*[local-name() = 'ulink']">
    <db:link>
      <xsl:apply-templates select="@* | node()"/>
    </db:link>
  </xsl:template>
  <xsl:template match="*[local-name() = 'ulink']/@*[local-name() = 'url']">
    <xsl:attribute name="xlink:href"><xsl:value-of select="."/></xsl:attribute>
  </xsl:template>

  <!-- The DocManager tags should never be translated. -->
  <xsl:template match="*[local-name() = 'docmanager']">
   <xsl:if test="$dmurl != '' and $dmproduct != '' and $dmcomponent != '' and $dmassignee != ''">
     <dm:docmanager>
       <dm:bugtracker>
         <dm:url><xsl:value-of select="$dmurl"/></dm:url>
         <dm:product><xsl:value-of select="$dmproduct"/></dm:product>
         <dm:component><xsl:value-of select="$dmcomponent"/></dm:component>
         <dm:assignee><xsl:value-of select="$dmassignee"/></dm:assignee>
       </dm:bugtracker>
     </dm:docmanager>
   </xsl:if>
  </xsl:template>

  <!-- GeekoDoc doesn't allow the holder element which renders this a bit
  pointless (though it does allow copyright and year) -->
  <xsl:template match="db:copyright"/>

</xsl:stylesheet>
