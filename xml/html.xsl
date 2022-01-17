<?xml version="1.0"?>

<!-- Copyright (c) 2003 Phil Chu -->

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="xml" omit-xml-declaration="no" indent="yes"
	 doctype-public="-//W3C//DTD XHTML 1.1 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
<xsl:strip-space elements="*"/>

<xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en-US" xml:lang="en-US">
<head>
<title>
<xsl:apply-templates select="resume/person"/>'s Resume
</title>
<link rel="stylesheet" type="text/css" href="/style.css"/>
</head>
<body>
<xsl:apply-templates select="resume"/>
</body>
</html>
</xsl:template>

<xsl:template match="resume">
<h1 class="title">
<xsl:text disable-output-escaping="yes">
R&amp;eacute;sum&amp;eacute; of
</xsl:text>
<xsl:apply-templates select="person"/>
</h1>

<table width="100%">
<tr>
<td align="left" valign="top">
<xsl:apply-templates select="address"/>
<br/>
Email:
<xsl:call-template name="link">
<xsl:with-param name="url" select="concat('mailto:',email)"/>
<xsl:with-param name="text" select="email"/>
</xsl:call-template>
<br/>
Web:
<xsl:call-template name="link">
<xsl:with-param name="url" select="url"/>
<xsl:with-param name="text" select="url"/>
</xsl:call-template>
<!-- <br/>
Phone:
<xsl:value-of select="phone"/> -->
</td>
<td align="right" valign="top" class="nav">

<xsl:call-template name="link">
<xsl:with-param name="url" select="'/'"/>
<xsl:with-param name="text" select="'technicat'"/>
</xsl:call-template>

<xsl:text disable-output-escaping="yes"> -&amp;gt; </xsl:text>
resume

<br/>
<xsl:call-template name="link">
<xsl:with-param name="url" select="'about.html'"/>
<xsl:with-param name="text" select="'about this resume'"/>
</xsl:call-template>

<br/>
<xsl:call-template name="link">
<xsl:with-param name="url" select="'resume.pdf'"/>
<xsl:with-param name="text" select="'PDF version'"/>
</xsl:call-template>
<!--
<xsl:call-template name="img">
<xsl:with-param name="url" select="'resume.pdf'"/>
<xsl:with-param name="text" select="'PDF version'"/>
<xsl:with-param name="imgurl" select="'/pdf.gif'"/>
</xsl:call-template>
-->
|
<xsl:call-template name="link">
<xsl:with-param name="url" select="'resume.svg'"/>
<xsl:with-param name="text" select="'SVG version'"/>
</xsl:call-template>
<br/>
<xsl:call-template name="link">
<xsl:with-param name="url" select="'resume.rtf'"/>
<xsl:with-param name="text" select="'RTF (Word) version'"/>
</xsl:call-template>
|
<xsl:call-template name="link">
<xsl:with-param name="url" select="'resume.txt'"/>
<xsl:with-param name="text" select="'text version'"/>
</xsl:call-template>
|
<xsl:call-template name="link">
<xsl:with-param name="url" select="'resume.wml'"/>
<xsl:with-param name="text" select="'WML (WAP) version'"/>
</xsl:call-template>
</td>
<td>
<xsl:call-template name="img">
  <xsl:with-param name="url" select="'westhigh/hacker.jpg'"/>
  <xsl:with-param name="imgurl" select="'westhigh/minime.jpg'"/>
<xsl:with-param name="text" select="'hacker'"/>
<!-- <xsl:with-param name="height" select="'31'"/>
<xsl:with-param name="width" select="'88'"/> -->
</xsl:call-template>
</td>
</tr>
</table>
<hr/>
<xsl:apply-templates select="summary"/>
<hr/>
<xsl:apply-templates select="category"/>
<hr/>
<xsl:apply-templates select="copyright"/>
</xsl:template>

<xsl:template match="summary">
  <h2>Summary</h2>
  <p>
  <b>Objective</b>
 <xsl:value-of select="objective"/>
</p>
<table width="100%">
<tr>
<td class="summary">
  <b>Career</b>
<xsl:apply-templates select="career"/>
</td>
<td class="summary">
  <b>Education</b>
<xsl:apply-templates select="education"/>
<br/>
<!--
<b>Writing</b>
<xsl:apply-templates select="publications"/>
-->
</td>
</tr>
</table>
  <!--
<p>
  <b>Skills </b>
<xsl:apply-templates select="skillset"/>
</p>
-->
</xsl:template>

<xsl:template match="category">
  <h2><xsl:value-of select="name"/></h2>
<xsl:apply-templates select="genre"/>
</xsl:template>

<xsl:template match="genre">
<h3 class="genre">
<xsl:attribute name="id">
<xsl:value-of select="name"/>
</xsl:attribute>
<xsl:value-of select="name"/>
</h3>
<xsl:apply-templates select="stint"/>
</xsl:template>

<!-- callable template for links -->
<xsl:template name="link">
<xsl:param name="url"/>
<xsl:param name="text"/>
<a>
<xsl:attribute name="href">
<xsl:value-of select="$url"/>
</xsl:attribute>
<xsl:value-of select="$text"/>
</a>
</xsl:template>

<!-- callable template for image links -->
<xsl:template name="img">
<xsl:param name="url"/>
<xsl:param name="text"/>
<xsl:param name="imgurl"/>
<xsl:param name="width"/>
<xsl:param name="height"/>
<a>
<xsl:attribute name="href">
<xsl:value-of select="$url"/>
</xsl:attribute>
<img>
<xsl:attribute name="src">
<xsl:value-of select="$imgurl"/>
</xsl:attribute>
<xsl:attribute name="alt">
<xsl:value-of select="$text"/>
</xsl:attribute>
<xsl:attribute name="width">
<xsl:value-of select="$width"/>
</xsl:attribute>
<xsl:attribute name="height">
<xsl:value-of select="$height"/>
</xsl:attribute>
<xsl:attribute name="class">
<xsl:value-of select="'w3c'"/>
</xsl:attribute>
</img>
</a>
</xsl:template>

<xsl:template match="place">
<table width="100%" class="place">
<tr>
<td>
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
</td>
<td class="type">
  <xsl:value-of select="description"/>
</td>
<td class="address">
<xsl:apply-templates select="address"/>
</td>
</tr>
</table>
</xsl:template>

<xsl:template match="skillset">
  <span class="tool">
<xsl:apply-templates select="tool"/>
</span>
</xsl:template>

<xsl:template match="tool">
<!-- if url is supplied, make a link -->
<xsl:choose>
<xsl:when test="count(url)>0">
<xsl:call-template name="link">
<xsl:with-param name="url" select="url"/>
<xsl:with-param name="text" select="name"/>
</xsl:call-template>
</xsl:when>
<!-- otherwise just use the text -->
<xsl:otherwise>
<xsl:value-of select="name"/>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="position()!=last()">,
</xsl:when>
<xsl:otherwise>.
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="stint">
<xsl:apply-templates select="place"/>
<table width="100%">
<xsl:apply-templates select="role"/>
</table>
</xsl:template>

<xsl:template match="period">
<xsl:apply-templates select="from"/>-<xsl:apply-templates select="to"/>
<br/>
</xsl:template>

<xsl:template match="role">
<tr>
<td class="role">
<strong>
<xsl:value-of select="name"/>
</strong>
<br/>
<xsl:apply-templates select="period"/>
</td>
<td class="description">
<xsl:apply-templates select="project"/>
</td>
<td valign="top" align="right">
<xsl:apply-templates select="reference"/>
</td>
</tr>
</xsl:template>

<xsl:template match="project">
<xsl:if test="count(name)>0">
<strong>
<xsl:value-of select="name"/>
</strong>
</xsl:if>
<xsl:apply-templates select="description"/>
<xsl:if test="count(skillset)>0">
  <!-- <em>Tools</em> -->
<xsl:apply-templates select="skillset"/>
</xsl:if>
</xsl:template>

<xsl:template match="link">
<xsl:call-template name="link">
<xsl:with-param name="url" select="url"/>
<xsl:with-param name="text" select="name"/>
</xsl:call-template>
</xsl:template>

<xsl:template match="reference">
<xsl:call-template name="link">
<xsl:with-param name="url" select="url"/>
<xsl:with-param name="text" select="name"/>
</xsl:call-template>
<br/>
</xsl:template>

<xsl:template match="date">
<xsl:value-of select="month"/>
<xsl:text> </xsl:text>
<xsl:value-of select="year"/>
</xsl:template>

<xsl:template match="present">Present</xsl:template>

<xsl:template match="copyright">
<table width="100%">
<tr>
<td class="copyright">
Copyright 
<xsl:text disable-output-escaping="yes">&amp;copy; </xsl:text>
<xsl:value-of select="year"/> by
<xsl:apply-templates select="person"/>.
</td>
<td class="copyright">
<xsl:value-of select="legalnotice"/>
</td>

<td class="w3c">
<xsl:call-template name="img">
<xsl:with-param name="url" select="'http://validator.w3.org/check/referer'"/>
<xsl:with-param name="imgurl" select="'/valid-xhtml11.png'"/>
<xsl:with-param name="text" select="'Valid XHTML 1.1!'"/>
<xsl:with-param name="height" select="'31'"/>
<xsl:with-param name="width" select="'88'"/>
</xsl:call-template>
</td>

<td class="w3c">
<xsl:call-template name="img">
<xsl:with-param name="url" select="'http://jigsaw.w3.org/css-validator/'"/>
<xsl:with-param name="imgurl" select="'/vcss.png'"/>
<xsl:with-param name="text" select="'Valid CSS!'"/>
<xsl:with-param name="height" select="'31'"/>
<xsl:with-param name="width" select="'88'"/>
</xsl:call-template>
</td>

</tr>
</table>
</xsl:template>

<xsl:template match="publication">
  <xsl:value-of select="pubtype"/>:
  <em>
<xsl:value-of select="title"/>.
</em>
</xsl:template>

<xsl:template match="address">
<xsl:value-of select="city"/>,
<xsl:value-of select="state"/>
</xsl:template>

<xsl:template match="person">
<xsl:value-of select="firstname"/>
<xsl:text> </xsl:text>
<xsl:value-of select="surname"/>
</xsl:template>

<xsl:template match="para">
</xsl:template>

</xsl:stylesheet>
