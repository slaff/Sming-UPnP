<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:d="urn:schemas-upnp-org:device-1-0"
	xmlns:s="urn:schemas-upnp-org:service-1-0">
<xsl:import href="common.xsl"/>
<xsl:output method="text" />

<xsl:template match="root">

<xsl:variable name="domain">
<xsl:for-each select="(s:scpd | d:device)[position()=1]"><xsl:call-template name="urn-domain"/></xsl:for-each>
</xsl:variable>

<xsl:variable name="domain-cpp">
<xsl:for-each select="(s:scpd | d:device)[position()=1]"><xsl:call-template name="urn-domain-cpp"/></xsl:for-each>
</xsl:variable>

/**
 * @brief Class information for "<xsl:value-of select="$domain"/>"
 *
 * @note This file is auto-generated ** DO NOT EDIT **
 */

#include &lt;Network/UPnP/ObjectClass.h>
#include &lt;Network/UPnP/ControlPoint.h>

<xsl:for-each select="s:scpd | d:device">
#include "<xsl:call-template name="urn-kind"/>/<xsl:call-template name="control-class"/>.h"<xsl:text/>
</xsl:for-each>

namespace UPnP {
namespace <xsl:value-of select="$domain-cpp"/> {

DECLARE_FSTR(domain);

extern const ClassGroup classGroup;

inline void registerClasses()
{
	ControlPoint::registerClasses(classGroup);
}

} // namespace <xsl:value-of select="$domain-cpp"/>
} // namespace UPnP

</xsl:template>

</xsl:stylesheet>
