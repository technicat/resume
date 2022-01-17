<?xml version="1.0"?>

<!-- Copyright (c) 2003 Phil Chu -->

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"/>

  <xsl:template match="/">
	<xsl:apply-templates select="resume"/>
  </xsl:template>

  <xsl:template match="resume">
      Resume of <xsl:apply-templates select="person"/>
      <xsl:apply-templates select="address"/>
      Email: <xsl:value-of select="email"/>
      Web: <xsl:value-of select="url"/>

	<xsl:apply-templates select="summary"/>
	<xsl:apply-templates select="category"/>
	<xsl:apply-templates select="copyright"/>
  </xsl:template>

  <xsl:template match="summary">

    SUMMARY
    <xsl:apply-templates select="career"/>
    <xsl:apply-templates select="education"/>
  </xsl:template>

  <xsl:template match="category">
    <xsl:value-of select="name"/>
    <xsl:apply-templates select="genre"/>
  </xsl:template>

  <xsl:template match="genre">
	<xsl:value-of select="name"/>
      <xsl:apply-templates select="stint"/>
  </xsl:template>

  <xsl:template match="stint">
    <xsl:text>
 </xsl:text>
    <xsl:apply-templates select="place"/>
    <xsl:text>
 </xsl:text>
    <xsl:apply-templates select="role"/>
  </xsl:template>

<xsl:template match="project">
  <xsl:if test="count(name)>0">
    [<xsl:value-of select="name"/>]
  </xsl:if> <xsl:apply-templates select="description"/>
</xsl:template>

<xsl:template match="place">
<xsl:value-of select="name"/>
<!-- <xsl:text> </xsl:text>
<xsl:value-of select="url"/> -->
<xsl:text> </xsl:text>
<xsl:apply-templates select="address"/>
  </xsl:template>

  <xsl:template match="role">
    <xsl:text>
 </xsl:text>
	<xsl:value-of select="name"/>
    <xsl:text> </xsl:text>
      <xsl:apply-templates select="period"/>
<xsl:apply-templates select="project"/>
  </xsl:template>

  <xsl:template match="period">
    <xsl:apply-templates select="from"/><xsl:text> - </xsl:text><xsl:apply-templates select="to"/>
  </xsl:template>

  <xsl:template match="from">
    <xsl:apply-templates select="date"/>
  </xsl:template>

  <xsl:template match="to">
    <xsl:apply-templates select="date"/>
  </xsl:template>

  <xsl:template match="date">
    <xsl:value-of select="month"/><xsl:text>, </xsl:text><xsl:value-of select="year"/>
  </xsl:template>

  <xsl:template match="present">Present</xsl:template>

  <xsl:template match="academics">
    ACADEMICS
    <xsl:apply-templates select="stint"/>
  </xsl:template>

  <xsl:template match="copyright">
      Copyright 
      <xsl:text>(c) </xsl:text>
      <xsl:value-of select="year"/> by
      <xsl:apply-templates select="name"/>.
      <xsl:value-of select="legalnotice"/>
  </xsl:template>

  <xsl:template match="person">
    <xsl:value-of select="firstname"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="surname"/>
  </xsl:template>

  <xsl:template match="address">
    <xsl:value-of select="city"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="state"/>
  </xsl:template>

  <xsl:template match="link">
<xsl:value-of select="name"/>
	</xsl:template>

</xsl:stylesheet>

