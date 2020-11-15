<?xml version='1.0'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:u="urn:schemas-upnp-org:device-1-0"
	xmlns:s="urn:schemas-upnp-org:service-1-0"
	xmlns:fn="http://www.w3.org/2005/xpath-functions">
<xsl:output method="text" />

<xsl:param name="DOC_ROOT"/>

<!-- 
<xsl:variable name="DOC_ROOT" select="'../../samples/Basic_ControlPoint/config'"/>
 -->

<xsl:template match="u:root">
<xsl:apply-templates select="u:device"/>
</xsl:template>

<xsl:template match="u:device">
/**
 * @brief ControlPoint device description for <xsl:value-of select="u:deviceType"/>
 *
 * @note This file is auto-generated ** DO NOT EDIT **
 *
 */

#pragma once

#include &lt;Network/UPnP/DeviceControl.h>
#include &lt;Network/UPnP/ServiceControl.h>

<xsl:variable name="type" select="substring-before(substring-after(u:deviceType, ':device:'), ':')"/>
<xsl:variable name="deviceClass">DeviceClass_<xsl:value-of select="$type"/></xsl:variable>

<xsl:for-each select="u:serviceList/u:service">
<xsl:call-template name="service">
<xsl:with-param name="deviceClass" select="$deviceClass"/>
</xsl:call-template>
</xsl:for-each>

class <xsl:value-of select="$deviceClass"/>: public UPnP::DeviceClass
{
public:
	<xsl:value-of select="$deviceClass"/>():
		<xsl:for-each select="u:serviceList/u:service">
		<xsl:if test="position() > 1">,
		</xsl:if><xsl:call-template name="serviceType"/>(*this)</xsl:for-each>
	{<xsl:text/>
		<xsl:for-each select="u:serviceList/u:service">
		serviceClasses.add(&amp;<xsl:call-template name="serviceType"/>);<xsl:text/>
		</xsl:for-each>
	}

	/**
	 * @brief Core field definitions
	 */
	String getField(Field desc) const override
	{
		switch(desc) {
		case Field::domain:
			return F("<xsl:value-of select="substring-before(substring-after(u:deviceType, ':'), ':')"/>");
		case Field::friendlyName:
			return F("<xsl:value-of select="u:friendlyName"/>");
		case Field::type:
			return F("<xsl:value-of select="$type"/>");
		case Field::version:
			return F("<xsl:value-of select="substring-after(substring-after(u:deviceType, ':device:'), ':')"/>");
		case Field::manufacturer:
			return F("<xsl:value-of select="u:manufacturer"/>");
		case Field::modelName:
			return F("<xsl:value-of select="u:modelName"/>");
		case Field::modelNumber:
			return F("<xsl:value-of select="u:modelNumber"/>");
		case Field::UDN:
			return F("<xsl:value-of select="u:UDN"/>");
		default:
			return DeviceClass::getField(desc);
		}
	}

	UPnP::DeviceControl* createObject() const override
	{
		return new UPnP::DeviceControl(*this);
	}

	<xsl:for-each select="u:serviceList/u:service">
	const <xsl:call-template name="serviceClass"/><xsl:text> </xsl:text><xsl:call-template name="serviceType"/>;<xsl:text/>
	</xsl:for-each>
};

</xsl:template>


<xsl:template name="serviceType"><xsl:value-of select="substring-before(substring-after(u:serviceType, ':service:'), ':')"/></xsl:template>
<xsl:template name="serviceClass">ServiceClass_<xsl:call-template name="serviceType"/></xsl:template>
<xsl:template name="serviceControl">Service_<xsl:call-template name="serviceType"/></xsl:template>

<xsl:template name="service">
<xsl:param name="deviceClass"/>
<xsl:variable name="SCPDURL" select="concat($DOC_ROOT,u:SCPDURL)"/>
<xsl:variable name="type"><xsl:call-template name="serviceType"/></xsl:variable>
<xsl:variable name="serviceClass"><xsl:call-template name="serviceClass"/></xsl:variable>
<xsl:variable name="serviceControl"><xsl:call-template name="serviceControl"/></xsl:variable>

class Service_<xsl:value-of select="$type"/>: public UPnP::ServiceControl
{
public:
	using ServiceControl::ServiceControl;
 	<xsl:apply-templates select="document($SCPDURL)/s:scpd/s:serviceStateTable/s:stateVariable"/>
	<xsl:apply-templates select="document($SCPDURL)/s:scpd/s:actionList/s:action"/>
};

class <xsl:value-of select="$serviceClass"/>: public UPnP::ServiceClass
{
public:
	using ServiceClass::ServiceClass;

	String getField(Field desc) const override
	{
		switch(desc) {
		case Field::domain:
			return F("<xsl:value-of select="substring-before(substring-after(u:serviceType, ':'), ':')"/>");
		case Field::type:
			return F("<xsl:value-of select="$type"/>");
		case Field::version:
			return F("<xsl:value-of select="substring-after(substring-after(u:serviceType, ':service:'), ':')"/>");
		case Field::serviceId:
			return F("<xsl:value-of select="u:serviceId"/>");
		case Field::SCPDURL:
			return F("<xsl:value-of select="u:SCPDURL"/>");
		case Field::controlURL:
			return F("<xsl:value-of select="u:controlURL"/>");
		case Field::eventSubURL:
			return F("<xsl:value-of select="u:eventSubURL"/>");
		default:
			return ServiceClass::getField(desc);
		}
	}

	UPnP::ServiceControl* createObject(UPnP::DeviceControl&amp; device) const override
	{
		return new <xsl:value-of select="$serviceControl"/>(device, *this);
	}
};

</xsl:template>

<xsl:template name="out-params">
	<xsl:for-each select="s:argumentList/s:argument[s:direction='out']"><xsl:if test="position() > 1">,</xsl:if>
		<xsl:value-of select="s:relatedStateVariable"/><xsl:text> </xsl:text><xsl:value-of select="s:name"/><xsl:text/>
	</xsl:for-each>
</xsl:template>

<xsl:template match="s:action">
	using <xsl:value-of select="s:name"/>_ResultCallback = Delegate&lt;void(<xsl:call-template name="out-params"/>)>;

	bool action_<xsl:value-of select="s:name"/>(
			<xsl:value-of select="s:name"/>_ResultCallback callback<xsl:for-each select="s:argumentList/s:argument[s:direction='in']">,
			<xsl:value-of select="s:relatedStateVariable"/><xsl:text> </xsl:text><xsl:value-of select="s:name"/>
			</xsl:for-each>)
	{
		ArgList list;<xsl:text/>
		<xsl:for-each select="s:argumentList/s:argument[s:direction='in']">
		list.addInput(F("<xsl:value-of select="s:name"/>"), String(<xsl:value-of select="s:name"/>));<xsl:text/>
		</xsl:for-each>
		<xsl:for-each select="s:argumentList/s:argument[s:direction='out']">
		list.addOutput(F("<xsl:value-of select="s:name"/>"));<xsl:text/>
		</xsl:for-each>
		return DispatchRequest(callback, list);
	}
</xsl:template>


<xsl:template match="s:stateVariable">
	using <xsl:value-of select="s:name"/> = <xsl:call-template name="getvartype"/>;<xsl:text/>
</xsl:template>


<xsl:template name="getvartype">
  <xsl:choose>
    <xsl:when test="s:dataType='string'">String</xsl:when>
    <xsl:when test="s:dataType='ui4'">uint32_t</xsl:when>
    <xsl:when test="s:dataType='ui2'">uint16_t</xsl:when>
    <xsl:when test="s:dataType='i4'">int32_t</xsl:when>
    <xsl:when test="s:dataType='i2'">int16_t</xsl:when>
    <xsl:when test="s:dataType='boolean'">bool</xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="yes">Unknown field type: "<xsl:value-of select="s:dataType"/>"</xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="urn-domain">
	<xsl:value-of select="substring-after(., ':')"/>
</xsl:template>

<xsl:template name="urn-type">
	<xsl:value-of select="substring-after(., ':')"/>
</xsl:template>

</xsl:stylesheet>