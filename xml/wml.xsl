<?xml version="1.0"?>

<!-- Copyright (c) 2003 Phil Chu -->

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="no" indent="yes"
	 doctype-public="-//WAPFORUM//DTD WML 1.1//EN"
          media-type="text/vnd.wap.wml"
          doctype-system="http://www.wapforum.org/DTD/wml_1.1.xml"
          encoding="ISO-8859-1"/>

<xsl:strip-space elements="*"/>

<xsl:template match="/">
<wml>
<template>
<do type="accept" label="Top">
<go href="#contents"/>
</do>
</template>
<xsl:apply-templates select="resume"/>
</wml>
</xsl:template>

<xsl:template match="resume">
<xsl:apply-templates select="copyright"/>
<card id="title" title="R&#233;sum&#233;">
<onevent type="ontimer">
<go href="#contents"/>
</onevent>
<timer value="20"/>
<p align="center">
<xsl:apply-templates select="person"/>
</p>
<p>
<xsl:apply-templates select="address"/>
</p>
<p align="left">
<small><xsl:value-of select="email"/></small>
</p>
<p align="left">
<small><xsl:value-of select="url"/></small>
</p>
</card>
<card id="contents" title="R&#233;sum&#233;">
<select>
<xsl:call-template name="option">
<xsl:with-param name="url" select="'#summary'"/>
<xsl:with-param name="text" select="'Summary'"/>
</xsl:call-template>
<xsl:call-template name="option">
<xsl:with-param name="url" select="'#professional'"/>
<xsl:with-param name="text" select="'Professional'"/>
</xsl:call-template>
<xsl:call-template name="option">
<xsl:with-param name="url" select="'#academic'"/>
<xsl:with-param name="text" select="'Academic'"/>
</xsl:call-template>
</select>
</card>

<xsl:apply-templates select="summary"/>

<xsl:apply-templates select="professional"/>

<xsl:apply-templates select="academic"/>

</xsl:template>

<xsl:template match="summary">
<card id="summary" title="summary">
<select>
<xsl:call-template name="option">
<xsl:with-param name="url" select="'#career'"/>
<xsl:with-param name="text" select="'Career'"/>
</xsl:call-template>
<xsl:call-template name="option">
<xsl:with-param name="url" select="'#education'"/>
<xsl:with-param name="text" select="'Education'"/>
</xsl:call-template>
</select>
</card>
<card id="career" title="career">
<xsl:value-of select="career"/>
</card>
<card id="education" title="education">
<xsl:value-of select="education"/>
</card>

</xsl:template>

<xsl:template match="professional">
<card id="professional" title="professional">
<select>
<xsl:for-each select="genre">
<xsl:call-template name="option">
<xsl:with-param name="url" select="concat('#',name)"/>
<xsl:with-param name="text" select="name"/>
</xsl:call-template>
</xsl:for-each>
</select>
</card>
<xsl:apply-templates select="genre"/>
</xsl:template>

<xsl:template match="genre">
<card>
<xsl:attribute name="id">
<xsl:value-of select="name"/>
</xsl:attribute>
<xsl:attribute name="title">
<xsl:value-of select="name"/>
</xsl:attribute>
<select>
<xsl:for-each select="stint">
<xsl:call-template name="option">
<xsl:with-param name="url" select="concat('#',place/name)"/>
<xsl:with-param name="text" select="place/name"/>
</xsl:call-template>
</xsl:for-each>
</select>
</card>
<xsl:apply-templates select="stint"/>
</xsl:template>

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

<xsl:template name="option">
<xsl:param name="url"/>
<xsl:param name="text"/>
<option>
<xsl:attribute name="onpick">
<xsl:value-of select="$url"/>
</xsl:attribute>
<xsl:value-of select="$text"/>
</option>
</xsl:template>

<xsl:template match="place">
<xsl:if test="count(url)>0">
<p>
<small><xsl:value-of select="url"/></small>
</p>
</xsl:if>
<p>
<xsl:apply-templates select="address"/>
</p>
</xsl:template>

<xsl:template match="stint">
<card>
<xsl:attribute name="id">
<xsl:value-of select="place/name"/>
</xsl:attribute>
<xsl:attribute name="title">
<xsl:value-of select="place/name"/>
</xsl:attribute>
<xsl:apply-templates select="place"/>
<xsl:apply-templates select="role"/>
</card>
</xsl:template>

<xsl:template match="period">
<small>
<xsl:apply-templates select="from"/>-<xsl:apply-templates select="to"/>
</small>
</xsl:template>

<xsl:template match="role">
<strong>
<xsl:value-of select="name"/>
</strong>
<br/>
<xsl:apply-templates select="period"/>
<p>
<xsl:value-of select="description"/>
</p>
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

<xsl:template match="academic">
<card id="academic" title="Academic">
<select>
<xsl:for-each select="stint">
<xsl:call-template name="option">
<xsl:with-param name="url" select="concat('#',place/name)"/>
<xsl:with-param name="text" select="place/name"/>
</xsl:call-template>
</xsl:for-each>
</select>
</card>
<xsl:apply-templates select="stint"/>

</xsl:template>

<xsl:template match="copyright">
<card id="copyright">
<onevent type="ontimer">
<go href="#title"/>
</onevent>
<timer value="20"/>
<p align="center">
Copyright 
<xsl:text disable-output-escaping="yes">&amp;copy; </xsl:text>
<xsl:value-of select="year"/>
<br/>
by
<xsl:apply-templates select="person"/>.
</p>
<p>
<xsl:value-of select="legalnotice"/>
</p>
</card>
</xsl:template>

<xsl:template match="address">
<small>
<xsl:value-of select="city"/>,
<xsl:value-of select="state"/>
</small>
</xsl:template>

<xsl:template match="person">
<xsl:value-of select="firstname"/>
<xsl:text> </xsl:text>
<xsl:value-of select="surname"/>
</xsl:template>

</xsl:stylesheet>
