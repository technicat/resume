<?xml version="1.0"?>

<!-- Copyright (c) 2003 Philip Chu -->

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
>

  <xsl:output method="xml" omit-xml-declaration="no" indent="yes"/>
  <xsl:output doctype-public=""/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
	<fo:simple-page-master master-name="first" page-height="11in"
			       page-width="8.5in" margin-top="0.1in"
			       margin-bottom="0.1in" margin-left="0.1in"
			       margin-right="0.1in"
			       overflow="visible">
	  <fo:region-before extent="0.5in"/>
	  <fo:region-body margin-left="0.5in" margin-right="0.5in"
			  margin-top="0.5in" margin-bottom="0.8in"
			  column-count="1"/>
	  <fo:region-after extent="0.5in"/>
	</fo:simple-page-master>
      </fo:layout-master-set>

      <fo:page-sequence master-reference="first">
	 <fo:static-content flow-name="xsl-region-before">

	<fo:block text-align-last="justify" font-size="8pt">
          <xsl:apply-templates select="resume/address"/>
	<fo:leader leader-pattern="space"/>
      <xsl:value-of select="resume/url"/>
      	<fo:leader leader-pattern="space"/>
      <xsl:value-of select="resume/email"/>

      <!--      	<fo:leader leader-pattern="space"/>
      <xsl:value-of select="resume/phone"/>m -->
	</fo:block>
</fo:static-content>

	<fo:static-content flow-name="xsl-region-after">
	  <fo:block font-size="8pt" text-align-last="justify">
	    <xsl:apply-templates select="resume/person"/>'s
		Resume - page <fo:page-number/>
	<fo:leader leader-pattern="space"/>
      Copyright &#169; <xsl:value-of select="resume/copyright/year"/>
      by <xsl:apply-templates select="resume/person"/>
	<fo:leader leader-pattern="space"/>
	<xsl:value-of select="resume/copyright/legalnotice"/>
	  </fo:block>
	</fo:static-content>

	<fo:flow flow-name="xsl-region-body">
	<fo:block font-size="10pt">
	  <xsl:apply-templates select="resume"/>
	</fo:block>
	</fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

<xsl:template match="resume">
	<fo:block>
	<fo:block font-weight="bold" text-align="center" font-size="14pt">
R&#233;sum&#233; of
<xsl:apply-templates select="person"/>
</fo:block>
	<fo:block space-before="0.2in">
	<xsl:apply-templates select="summary"/>
	</fo:block>
	<fo:block>
	<xsl:apply-templates select="category"/>
	</fo:block>
<!-- place all reference pages after main resume -->
<!--	<xsl:apply-templates select="//reference"/> -->
	</fo:block>
</xsl:template>

<xsl:template match="reference">
<!-- only print jpeg files -->
<xsl:if test="contains(url,'.jpg')">
<fo:block break-before="page">
<fo:external-graphic>
<xsl:attribute name="src">
<xsl:value-of select="url"/>
</xsl:attribute>
<xsl:attribute name="width">4in</xsl:attribute>
</fo:external-graphic>
</fo:block>
<!-- caption -->
<!--
<fo:block text-align="center">
<xsl:value-of select="name"/>
</fo:block> 
-->
</xsl:if>
</xsl:template>

  <xsl:template match="person">
	<fo:inline>
    <xsl:value-of select="firstname"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="surname"/>
	</fo:inline>
  </xsl:template>
  
  <xsl:template match="address">
	<fo:inline>
	<xsl:value-of select="city"/>,
        <xsl:value-of select="state"/>
	</fo:inline>
  </xsl:template>

  <xsl:template match="summary">
    <fo:block font-family="serif">

      <fo:block>
        <fo:inline font-weight="bold">Objective</fo:inline>
        <xsl:value-of select="objective"/>
      </fo:block>

      <fo:table table-layout="fixed">
        <fo:table-column column-number="1" column-width="3.6in"/>
        <fo:table-column column-number="2" column-width="3.6in"/>
        <fo:table-body>

          <fo:table-row>
            <fo:table-cell padding="4pt">
              <fo:block text-align="justify">
                <fo:inline font-weight="bold">Career</fo:inline>

                <xsl:apply-templates select="career"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell padding="4pt">
              <fo:block text-align="justify">
                <fo:inline font-weight="bold">Education</fo:inline>
                <xsl:apply-templates select="education"/>
              </fo:block>
              <!--
              <fo:block text-align="justify">
                <fo:inline font-weight="bold">Writing</fo:inline>
                <xsl:apply-templates select="publications"/>
              </fo:block>
-->
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
      <!--
      <fo:block>
        <fo:inline font-weight="bold">Skills</fo:inline>
        <xsl:apply-templates select="skillset"/>
      </fo:block> -->
    </fo:block>
  </xsl:template>

  <xsl:template match="category">
	<fo:block font-weight="bold" font-size="13pt" text-align-last="justify" space-before="0.1in">
	<fo:leader leader-pattern="rule"/>
        <xsl:value-of select="name"/>
	</fo:block>
<fo:block font-size="10pt">
    <xsl:apply-templates select="genre"/>
</fo:block>
  </xsl:template>

  <xsl:template match="genre">
	<fo:block space-before="0.2in" text-align="center" font-weight="bold" font-size="12pt">
	<xsl:value-of select="name"/>
	</fo:block>
	<fo:block>
    <xsl:apply-templates select="stint"/>
	</fo:block>
  </xsl:template>

  <xsl:template match="link">
    <xsl:call-template name="link">
      <xsl:with-param name="url" select="url"/>
      <xsl:with-param name="text" select="name"/>
      </xsl:call-template>
	</xsl:template>

<xsl:template name="link">
<xsl:param name="url"/>
<xsl:param name="text"/>
<fo:basic-link>
<xsl:attribute name="external-destination">
<xsl:value-of select="$url"/>
</xsl:attribute>
<xsl:value-of select="$text"/>
</fo:basic-link>
</xsl:template>

  <xsl:template match="place">
	<fo:block text-align-last="justify">
	<fo:inline font-weight="bold">
          <xsl:choose>
            <xsl:when test="count(url)>0">
          <xsl:call-template name="link">
      <xsl:with-param name="url" select="url"/>
      <xsl:with-param name="text" select="name"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="name"/>
</xsl:otherwise>
</xsl:choose>
	</fo:inline>
      	<fo:leader leader-pattern="space"/>
        <fo:inline text-decoration="underline">
          <!-- <xsl:value-of select="url"/> -->
          <xsl:apply-templates select="description"/>
	</fo:inline>
	<fo:leader leader-pattern="space"/>
	<xsl:apply-templates select="address"/>
</fo:block>
	</xsl:template>

  <xsl:template match="role">
<fo:table-row>
<fo:table-cell padding="2pt">
	<fo:block text-align="left">
<fo:block>
<xsl:value-of select="name"/>
</fo:block>
      <fo:block>
<xsl:apply-templates select="period"/>
</fo:block>
</fo:block>

</fo:table-cell>
<fo:table-cell padding="2pt">
	<fo:block text-align="justify" font-family="serif">
	<xsl:apply-templates select="project"/>
	</fo:block>
	</fo:table-cell>
</fo:table-row>
	</xsl:template>


  <xsl:template match="stint">
<fo:block space-before="0.1in">
<xsl:apply-templates select="place"/>
<fo:block>
<fo:table table-layout="fixed">
<fo:table-column column-number="1" column-width="2.5in"/>
<fo:table-column column-number="2" column-width="4.8in"/>
<fo:table-body>
	<xsl:apply-templates select="role"/>
</fo:table-body>
</fo:table>
</fo:block>
	</fo:block>
  </xsl:template>

<xsl:template match="project">
<fo:inline font-weight="bold">
<xsl:value-of select="name"/>
</fo:inline>
<xsl:apply-templates select="description"/>
<xsl:apply-templates select="skillset"/>
</xsl:template>

<xsl:template match="skillset">
  <!-- <xsl:apply-templates select="tool"/> -->
</xsl:template>

<xsl:template match="tool">
<fo:inline font-style="italic">
<xsl:value-of select="name"/>
<xsl:choose>
<xsl:when test="position()!=last()">,
</xsl:when>
<xsl:otherwise>.
</xsl:otherwise>
</xsl:choose>

</fo:inline>
</xsl:template>

  <xsl:template match="copyright">
      Copyright &#169; <xsl:value-of select="year"/>
      by <xsl:apply-templates select="person"/>
	<xsl:value-of select="legalnotice"/>
  </xsl:template>

  <xsl:template match="period">
	<fo:inline>
    <xsl:apply-templates select="from"/>-<xsl:apply-templates select="to"/>
	</fo:inline>
  </xsl:template>

  <xsl:template match="date">
    <xsl:value-of select="month"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="year"/>
  </xsl:template>

  <xsl:template match="publication">
    <xsl:value-of select="pubtype"/>:
<fo:inline font-style="italic">
    <xsl:value-of select="title"/>.
  </fo:inline>
  </xsl:template>

  <xsl:template match="present">Present</xsl:template>

</xsl:stylesheet>
