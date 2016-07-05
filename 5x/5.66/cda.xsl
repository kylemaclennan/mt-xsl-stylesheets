<?xml version="1.0" encoding="windows-1252"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n3="http://www.w3.org/1999/xhtml" xmlns:n1="urn:hl7-org:v3" xmlns:n2="urn:hl7-org:v3/meta/voc" xmlns:voc="urn:hl7-org:v3/voc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc">
<xsl:output method="html" indent="yes" version="4.01" encoding="ISO-8859-1" doctype-public="-//W3C//DTD HTML 4.01//EN"/>

<!-- CDA document -->

<!-- Variables -->
<xsl:variable name="title">
	<xsl:choose>
		<xsl:when test="/n1:ClinicalDocument/n1:title">
			<xsl:value-of select="/n1:ClinicalDocument/n1:title"/>
		</xsl:when>
		<xsl:otherwise>Clinical Document</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="relations">
	<xsl:choose>
		<xsl:when test="/n1:ClinicalDocument/n1:participant/n1:associatedEntity/n1:code[@code]">
			1
		</xsl:when>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

<xsl:template match="/">
	<xsl:apply-templates select="n1:ClinicalDocument"/>
</xsl:template>

<xsl:template match="n1:ClinicalDocument">
	<html>
		<head>
			<xsl:comment>
				Do NOT edit this HTML directly, it was generated via an XSLT
				transformation.
			</xsl:comment>
			<title>
				<xsl:value-of select="$title"/>
			</title>
			<xsl:call-template name="addCSS"/>
			<xsl:call-template name="addJS"/>
		</head>
		<body>  
			<xsl:variable name="patientRole" select="/n1:ClinicalDocument/n1:recordTarget/n1:patientRole"/>
			<br/>
			<table width='100%'>
				<tr>
					<td width='50%'>
						<b>
							<xsl:text>Patient: </xsl:text> 
						</b>
						<xsl:call-template name="getName">
								<xsl:with-param name="name" select="$patientRole/n1:patient/n1:name"/>
						</xsl:call-template>
					</td>
					<td align='right'>
						<b>
							<xsl:text>Sex: </xsl:text>
						</b>
						<xsl:variable name="sex" select="/n1:ClinicalDocument/n1:recordTarget/n1:patientRole/n1:patient/n1:administrativeGenderCode/@code"/>
						<xsl:choose>
							<xsl:when test="$sex='M'">Male</xsl:when>
							<xsl:when test="$sex='F'">Female</xsl:when>
							<xsl:otherwise>Undifferentiated</xsl:otherwise>
						</xsl:choose>
					</td>
					<td align='right'>
						<b>
							<xsl:text>   DOB: </xsl:text>
						</b>
						<xsl:call-template name="formatDate">
							<xsl:with-param name="date" select="/n1:ClinicalDocument/n1:recordTarget/n1:patientRole/n1:patient/n1:birthTime/@value"/>
						</xsl:call-template>
					</td>
					<td align='right'>
						<b>
							<xsl:text>   External Reference #: </xsl:text>
						</b>
						<xsl:value-of select="$patientRole/n1:id/@extension"/>
					</td>
				</tr>
			</table>
			<p/>
			<hr/>		
			<h2 align="center">
				<xsl:value-of select="$title"/>
			</h2>
			<p align='center'>
				<b>
					<xsl:text>Created On: </xsl:text>
				</b>
				<xsl:call-template name="formatDate">
					<xsl:with-param name="date" select="/n1:ClinicalDocument/n1:effectiveTime/@value"/>
				</xsl:call-template>
			</p>
			<ul>
				<li>
					<span style="color:blue;text-decoration:underline;cursor:pointer;" onclick="Toggle('demo')">
						<xsl:text>Demographics</xsl:text>
					</span>
				</li>
				<div id="demo" style="display:none">
					<xsl:call-template name="demographics">
						<xsl:with-param name="patientRole" select="/n1:ClinicalDocument/n1:recordTarget/n1:patientRole"/>
					</xsl:call-template>
					<p/>
				</div>
				<xsl:if test="/n1:ClinicalDocument/n1:author/n1:assignedAuthor/n1:representedOrganization">
					<li>
						<span style="color:blue;text-decoration:underline;cursor:pointer;" onclick="Toggle('from')">
							<xsl:text>Author</xsl:text>
						</span>
					</li>
					<div id="from" style="display:none">
						<xsl:variable name="author" select="/n1:ClinicalDocument/n1:author/n1:assignedAuthor"/>
						<br/>
						<table summary="document source" class="gridtable">
							<xsl:if test="$author/n1:representedOrganization">
								<tr>
									<td>
										<b>Organization</b>
									</td>
									<td>
										<xsl:value-of select="$author/n1:representedOrganization/n1:name"/>
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="$author/n1:representedOrganization/n1:addr">
								<tr>
									<td>
										<b>Address</b>
									</td>
									<td>
										<xsl:call-template name="getAddress"> 
											<xsl:with-param name="addr" select="$author/n1:representedOrganization/n1:addr"/>
										</xsl:call-template>
									</td>
								</tr>
							</xsl:if>
					<xsl:if test="$author/n1:representedOrganization/n1:telecom">
						<tr>
							<td>
								<b>Phone</b>
							</td>
							<td>
								<xsl:call-template name="getTelecom"> 
									<xsl:with-param name="telecom" select="$author/n1:representedOrganization/n1:telecom"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>
						</table>
						<p/>
					</div>
				</xsl:if>
				<xsl:if test="/n1:ClinicalDocument/n1:participant">
					<li>
						<span style="color:blue;text-decoration:underline;cursor:pointer;" onclick="Toggle('support')">
							<xsl:text>Support </xsl:text>
						</span>
					</li>
					<div id="support" style="display:none">
						<br/>
						<table summary="Support" class="gridtable">
							<tr>
								<th>Name</th>
								<xsl:if test="$relations = 1">
									<th>Relationship</th>
								</xsl:if>
								<th>Role</th>
								<th>Address</th>
								<th>Phone</th>
							</tr>
							<xsl:apply-templates select="/n1:ClinicalDocument/n1:participant"/>
						</table>
						<p/>
					</div>
				</xsl:if>
				<xsl:if test="/n1:ClinicalDocument/n1:documentationOf/n1:serviceEvent/n1:performer">
					<li>
						<span style="color:blue;text-decoration:underline;cursor:pointer;" onclick="Toggle('providers')">
							<xsl:text>Care Team Providers </xsl:text>
						</span>
					</li>
					<div id="providers" style="display:none">
						<br/>
						<table summary="Support" class="gridtable">
							<tr>
								<th>Care Team Member Name</th>
								<th>Role</th>
								<th>Phone</th>
							</tr>
							<xsl:apply-templates select="/n1:ClinicalDocument/n1:documentationOf/n1:serviceEvent/n1:performer"/>
						</table>
						<p/>
					</div>
				</xsl:if>
			</ul>
			<xsl:apply-templates select="n1:component/n1:structuredBody"/> 
		</body>
	</html>
</xsl:template>

<xsl:template name="getAddress">
	<xsl:param name="addr"/>
	<xsl:choose>
		<xsl:when test="$addr/n1:streetAddressLine">
			<xsl:for-each select="$addr/n1:streetAddressLine">
				<xsl:value-of select="current()"/>
				<br/>
			</xsl:for-each>
			<xsl:if test="$addr/n1:city or $addr/n1:state or $addr/n1:postalCode">
				<xsl:if test="$addr/n1:city">
					<xsl:value-of select="$addr/n1:city"/>
					<xsl:text>, </xsl:text>
				</xsl:if>
				<xsl:if test="$addr/n1:state">
					<xsl:value-of select="$addr/n1:state"/>
					<xsl:text>, </xsl:text>
				</xsl:if>
				<xsl:if test="$addr/n1:postalCode">
					<xsl:value-of select="$addr/n1:postalCode"/>
				</xsl:if>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$addr"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="getTelecom">
	<xsl:param name="telecom"/>
	<xsl:choose>
		<xsl:when test="contains($telecom/attribute::value,':')">
			<xsl:value-of select="substring-after($telecom/attribute::value,':')"/>
		</xsl:when>
		<xsl:when test="$telecom/attribute::value">
			<xsl:value-of select="$telecom/attribute::value"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Unavailable</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
    
<!-- Get a Name  -->
<xsl:template name="getName">
	<xsl:param name="name"/>
	<xsl:choose>
		<xsl:when test="$name/n1:family">
			<xsl:value-of select="$name/n1:family"/>
			<xsl:if test="$name/n1:suffix">
				<xsl:text> </xsl:text>
				<xsl:value-of select="$name/n1:suffix"/>
			</xsl:if>
			<xsl:if test="$name/n1:prefix|$name/n1:given">
				<xsl:text>,</xsl:text>
			</xsl:if>
			<xsl:if test="$name/n1:prefix">
				<xsl:text> </xsl:text>
				<xsl:value-of select="$name/n1:prefix"/>
			</xsl:if>
			<xsl:if test="$name/n1:given">
				<xsl:text> </xsl:text>
				<xsl:value-of select="$name/n1:given"/>
			</xsl:if>
			<xsl:if test="$name/n1:given[2]">
				<xsl:text> </xsl:text>
				<xsl:value-of select="$name/n1:given[2]"/>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$name"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="demographics">
	<xsl:param name="patientRole"/>
	<br/>
	<table summary="Demographics" class="gridtable">
		<xsl:if test="$patientRole/n1:addr">
			<tr>
				<td>
					<b><xsl:text>Address </xsl:text></b>
				</td>			
				<td>
					<xsl:call-template name="getAddress"> 
							<xsl:with-param name="addr" select="$patientRole/n1:addr"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:for-each select="$patientRole/n1:telecom">
			<xsl:choose>
				<xsl:when test="self::node()[@use='HP']">
					<tr>
						<td>
							<b><xsl:text>Home Phone</xsl:text></b>	
						</td>			
						<td>
							<xsl:call-template name="getTelecom"> 
								<xsl:with-param name="telecom" select="self::node()[@value]"/>
							</xsl:call-template>
						</td>
					</tr>
				</xsl:when>
				<xsl:when test="self::node()[@use='WP']">
					<tr>
						<td>
							<b><xsl:text>Work Phone</xsl:text></b>	
						</td>			
						<td>
							<xsl:call-template name="getTelecom"> 
								<xsl:with-param name="telecom" select="self::node()[@value]"/>
							</xsl:call-template>
						</td>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td>
							<b><xsl:text>Email Address</xsl:text></b>	
						</td>			
						<td>
							<xsl:call-template name="getEmail"> 
								<xsl:with-param name="email" select="self::node()[@value]"/>
							</xsl:call-template>
						</td>
					</tr>					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<tr>
			<td>
				<b><xsl:text>Preferred Language</xsl:text></b>
			</td>
			<td>
				<xsl:call-template name="getLang">
					<xsl:with-param name="lang" select="$patientRole/n1:patient/n1:languageCommunication/n1:languageCode"/>
				</xsl:call-template>
			</td>
		</tr>
		<tr>
			<td>
				<b><xsl:text>Marital Status</xsl:text></b>
			</td>
			<td>
				<xsl:call-template name="getMaritalStatus">
					<xsl:with-param name="maritalStatus" select="$patientRole/n1:patient/n1:maritalStatusCode"/>
				</xsl:call-template>
			</td>
		</tr>
		<tr>
			<td>
				<b><xsl:text>Religious Affiliation</xsl:text></b>
			</td>
			<td>
				<xsl:call-template name="getReligion">
					<xsl:with-param name="religion" select="$patientRole/n1:patient/n1:religiousAffiliationCode"/>
				</xsl:call-template>
			</td>
		</tr>
		<tr>
			<td>
				<b><xsl:text>Race</xsl:text></b>
			</td>
			<td>
				<xsl:call-template name="getRaceCode">
					<xsl:with-param name="raceCode" select="$patientRole/n1:patient/n1:raceCode"/>
				</xsl:call-template>
			</td>
		</tr>
		<xsl:if test="$patientRole/n1:patient/sdtc:raceCode">
			<tr>
				<td>
					<b><xsl:text>Additional Race(s)</xsl:text></b>
				</td>
				<td>
					<xsl:for-each select="$patientRole/n1:patient/sdtc:raceCode">
						<xsl:call-template name="getRaceCode">
							<xsl:with-param name="raceCode" select="."/>
						</xsl:call-template>
						<xsl:if test="position()!=last()">
							<br/>
						</xsl:if>
					</xsl:for-each>
				</td>
			</tr>
		</xsl:if>
		<tr>
			<td>
				<b><xsl:text>Ethnic Group</xsl:text></b>
			</td>
			<td>
				<xsl:call-template name="getEthnicGroup">
					<xsl:with-param name="ethnicGroup" select="$patientRole/n1:patient/n1:ethnicGroupCode"/>
				</xsl:call-template>
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template name="getEmail">
	<xsl:param name="email"/>
	<xsl:value-of select="substring-after(attribute::value,':')"/>
</xsl:template>

<!--  Format Date 
    
      outputs a date in Month Day, Year form
      e.g., 19991207  ==> December 07, 1999
-->
<xsl:template name="formatDate">
	<xsl:param name="date"/>
	<xsl:variable name="month" select="substring ($date, 5, 2)"/>
	<xsl:choose>
		<xsl:when test="$month='01'">
			<xsl:text>January </xsl:text>
		</xsl:when>
		<xsl:when test="$month='02'">
			<xsl:text>February </xsl:text>
		</xsl:when>
		<xsl:when test="$month='03'">
			<xsl:text>March </xsl:text>
		</xsl:when>
		<xsl:when test="$month='04'">
			<xsl:text>April </xsl:text>
		</xsl:when>
		<xsl:when test="$month='05'">
			<xsl:text>May </xsl:text>
		</xsl:when>
		<xsl:when test="$month='06'">
			<xsl:text>June </xsl:text>
		</xsl:when>
		<xsl:when test="$month='07'">
			<xsl:text>July </xsl:text>
		</xsl:when>
		<xsl:when test="$month='08'">
			<xsl:text>August </xsl:text>
		</xsl:when>
		<xsl:when test="$month='09'">
			<xsl:text>September </xsl:text>
		</xsl:when>
		<xsl:when test="$month='10'">
			<xsl:text>October </xsl:text>
		</xsl:when>
		<xsl:when test="$month='11'">
			<xsl:text>November </xsl:text>
		</xsl:when>
		<xsl:when test="$month='12'">
			<xsl:text>December </xsl:text>
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test='substring ($date, 7, 1)="0"'>
			<xsl:value-of select="substring ($date, 8, 1)"/>
			<xsl:text>, </xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="substring ($date, 7, 2)"/>
			<xsl:text>, </xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:value-of select="substring ($date, 1, 4)"/>
</xsl:template>

<!-- participant -->
<xsl:template match="/n1:ClinicalDocument/n1:participant">
	<tr>
		<td>
			<xsl:choose>
				<xsl:when test="n1:associatedEntity/n1:associatedPerson/n1:name">
					<xsl:call-template name="getName">
						<xsl:with-param name="name" select="n1:associatedEntity/n1:associatedPerson/n1:name"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Unavailable</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</td>
		<xsl:if test="$relations = 1">
			<td>
				<xsl:call-template name="getRelationship">
					<xsl:with-param name="relat" select="n1:associatedEntity/n1:code"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<td>
			<xsl:apply-templates select="n1:associatedEntity/@classCode"/>
		</td>
		<td>
			<xsl:choose>
				<xsl:when test="n1:associatedEntity/n1:addr/@nullFlavor">
					<xsl:text>Unavailable</xsl:text>
				</xsl:when>
				<xsl:when test="n1:associatedEntity/n1:addr">
					<xsl:call-template name="getAddress">
						<xsl:with-param name="addr" select="n1:associatedEntity/n1:addr"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Unavailable</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</td>
		<td>
			<xsl:choose>
				<xsl:when test="n1:associatedEntity/n1:telecom[1]/@use">
					<xsl:choose>
						<xsl:when test="contains(n1:associatedEntity/n1:telecom[1]/@value,':')">
							<xsl:value-of select="substring-after(n1:associatedEntity/n1:telecom[1]/@value,':')"/>
						</xsl:when>
						<xsl:when test="n1:associatedEntity/n1:telecom[1]/@value">
							<xsl:value-of select="n1:associatedEntity/n1:telecom[1]/@value"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Unavailable</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Unavailable</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</tr>
</xsl:template>

<!-- performer -->
<xsl:template match="/n1:ClinicalDocument/n1:documentationOf/n1:serviceEvent/n1:performer">
	<tr>
		<td>
			<xsl:choose>
				<xsl:when test="n1:assignedEntity/n1:assignedPerson/n1:name">
					<xsl:call-template name="getName">
						<xsl:with-param name="name" select="n1:assignedEntity/n1:assignedPerson/n1:name"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Unavailable</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</td>
		<td style="text-transform: capitalize;">
			<xsl:choose>
				<xsl:when test="n1:functionCode/@code">
					<xsl:apply-templates select="n1:functionCode"/>
				</xsl:when>
				<xsl:when test="n1:functionCode/@displayName">
					<xsl:call-template name="mixedCase"> 
						<xsl:with-param name="toconvert" select="n1:functionCode/@displayName"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Unavailable</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</td>
		<td>
			<xsl:choose>
				<xsl:when test="n1:assignedEntity/n1:telecom[1]/@use">
					<xsl:choose>
						<xsl:when test="contains(n1:assignedEntity/n1:telecom[1]/@value,':')">
							<xsl:value-of select="substring-after(n1:assignedEntity/n1:telecom[1]/@value,':')"/>
						</xsl:when>
						<xsl:when test="n1:assignedEntity/n1:telecom[1]/@value">
							<xsl:value-of select="n1:assignedEntity/n1:telecom[1]/@value"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Unavailable</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Unavailable</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</tr>
</xsl:template>

<!-- StructuredBody -->
<xsl:template match="n1:component/n1:structuredBody">
	<p/>
	<hr/>
	<ul>
	<xsl:apply-templates select="n1:component/n1:section"/>
	</ul>
</xsl:template>

<!-- Component/Section -->    
<xsl:template match="n1:component/n1:section">
	<li>
	<span style="color:blue;text-decoration:underline;cursor:pointer;" onclick="Toggle('{n1:code/@code}')">
	<xsl:apply-templates select="n1:title"/>
	</span>
	</li>
	<div id="{n1:code/@code}" style="display:none">
		<br/>
		<xsl:apply-templates select="n1:text"/>
		<xsl:apply-templates select="n1:component/n1:section"/>
		<p/>
	</div>
</xsl:template>

<!--   Title  -->
<xsl:template match="n1:title">
	<xsl:value-of select="."/>
</xsl:template>

<!--   Text   -->
<xsl:template match="n1:text">
	<xsl:apply-templates />
</xsl:template>

<!--   break   -->
<xsl:template match="n1:br">
	<xsl:copy-of select="."/>
</xsl:template>

<!--   paragraph  -->
<xsl:template match="n1:paragraph">
	<p><xsl:apply-templates/></p>
</xsl:template>

<!--   content  -->
<xsl:template match="n1:content">
	<span style="white-space:pre;">
		<xsl:apply-templates/>
	</span>
</xsl:template>

<!--   list  -->
<xsl:template match="n1:list">
	<xsl:if test="n1:caption">
		<span style="font-weight:bold; ">
			<xsl:apply-templates select="n1:caption"/>
		</span>
	</xsl:if>
	<ul>
		<xsl:for-each select="n1:item">
			<li>
				<xsl:apply-templates />
			</li>
		</xsl:for-each>
	</ul>		 
</xsl:template>

<xsl:template match="n1:list[@listType='ordered']">
	<xsl:if test="n1:caption">
		<span style="font-weight:bold; ">
			<xsl:apply-templates select="n1:caption"/>
		</span>
	</xsl:if>
	<ol>
		<xsl:for-each select="n1:item">
			<li>
				<xsl:apply-templates />
			</li>
		</xsl:for-each>
	</ol>		 
</xsl:template>
		 
<!--      Tables   -->
<xsl:template match="n1:table/@*|n1:thead/@*|n1:tfoot/@*|n1:tbody/@*|n1:colgroup/@*|n1:col/@*|n1:tr/@*|n1:th/@*|n1:td/@*">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:apply-templates/>
	</xsl:copy>
</xsl:template>
		 
<xsl:template match="n1:table">
	<table summary="{../../n1:title}" class="gridtable">		 
		<xsl:copy-of select="@*[name()='ID'] | @*[name()='language'] | @*[name()='styleCode'] | @*[name()='summary'] | @*[name()='width'] | @*[name()='border'] | @*[name()='frame'] | @*[name()='rules'] | @*[name()='cellspacing'] | @*[name()='cellpadding']"/>
		<xsl:apply-templates/>
	</table>		 
</xsl:template>
		 
<xsl:template match="n1:thead">
	<thead>
		<xsl:copy-of select="@*[name()='ID'] | @*[name()='language'] | @*[name()='styleCode'] | @*[name()='align'] | @*[name()='char'] | @*[name()='charoff'] | @*[name()='valign']"/>
		<xsl:apply-templates/>
	</thead>		 
</xsl:template>

<xsl:template match="n1:tfoot">
	<tfoot>
		<xsl:copy-of select="@*[name()='ID'] | @*[name()='language'] | @*[name()='styleCode'] | @*[name()='align'] | @*[name()='char'] | @*[name()='charoff'] | @*[name()='valign']"/>
		<xsl:apply-templates/>
	</tfoot>		 
</xsl:template>

<xsl:template match="n1:tbody">
	<tbody>
		<xsl:copy-of select="@*[name()='ID'] | @*[name()='language'] | @*[name()='styleCode'] | @*[name()='align'] | @*[name()='char'] | @*[name()='charoff'] | @*[name()='valign']"/>
		<xsl:apply-templates/>
	</tbody>		 
</xsl:template>

<xsl:template match="n1:colgroup">
	<colgroup>
		<xsl:copy-of select="@*[name()='ID'] | @*[name()='language'] | @*[name()='styleCode'] | @*[name()='span'] | @*[name()='width'] | @*[name()='align'] | @*[name()='char'] | @*[name()='charoff'] | @*[name()='valign']"/>
		<xsl:apply-templates/>
	</colgroup>		 
</xsl:template>

<xsl:template match="n1:col">
	<col>
		<xsl:copy-of select="@*[name()='ID'] | @*[name()='language'] | @*[name()='styleCode'] | @*[name()='span'] | @*[name()='width'] | @*[name()='align'] | @*[name()='char'] | @*[name()='charoff'] | @*[name()='valign']"/>
		<xsl:apply-templates/>
	</col>		 
</xsl:template>

<xsl:template match="n1:tr">
	<tr>
		<xsl:copy-of select="@*[name()='ID'] | @*[name()='language'] | @*[name()='styleCode'] | @*[name()='align'] | @*[name()='char'] | @*[name()='charoff'] | @*[name()='valign']"/>
		<xsl:apply-templates/>
	</tr>		 
</xsl:template>

<xsl:template match="n1:th">
	<th>
		<xsl:copy-of select="@*[name()='ID'] | @*[name()='language'] | @*[name()='styleCode'] | @*[name()='abbr'] | @*[name()='axis'] | @*[name()='headers'] | @*[name()='scope'] | @*[name()='rowspan'] | @*[name()='colspan'] | @*[name()='align'] | @*[name()='char'] | @*[name()='charoff'] | @*[name()='valign']"/>
		<xsl:apply-templates/>
	</th>		 
</xsl:template>

<xsl:template match="n1:td">
	<td>
		<xsl:copy-of select="@*[name()='ID'] | @*[name()='language'] | @*[name()='styleCode'] | @*[name()='abbr'] | @*[name()='axis'] | @*[name()='headers'] | @*[name()='scope'] | @*[name()='rowspan'] | @*[name()='colspan'] | @*[name()='align'] | @*[name()='char'] | @*[name()='charoff'] | @*[name()='valign']"/>
		<xsl:apply-templates/>
	</td>		 
</xsl:template>

<xsl:template match="n1:table/n1:caption">
	<span style="font-weight:bold; ">		 
		<xsl:apply-templates/>
	</span>		 
</xsl:template>

<xsl:template match="n1:linkHtml">
	<a>
	<xsl:attribute name="href">
		<xsl:value-of select="./@href"/>
	</xsl:attribute>
	<xsl:attribute name="target">
		<xsl:text>_blank</xsl:text>
	</xsl:attribute>
	<xsl:choose>
		<xsl:when test=".!=''">
			<xsl:value-of select="."/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="./@href"/>
		</xsl:otherwise>
	</xsl:choose>
	</a>
</xsl:template>

<!-- 	Stylecode processing   
	  Supports Bold, Underline and Italics display

-->
<xsl:template match="*[contains(@styleCode,'Bold') or contains(@styleCode,'Italics') or contains(@styleCode,'Underline')]">
	<xsl:if test="@styleCode='Bold'">
		<xsl:copy>
			<xsl:attribute name="style">
				<xsl:text>font-weight: bold;</xsl:text>
			</xsl:attribute>	
			<xsl:apply-templates select="node()"/> 
		</xsl:copy>
	</xsl:if> 
	<xsl:if test="@styleCode='Italics'">
		<xsl:copy>
			<xsl:attribute name="style">
				<xsl:text>font-style: italic;</xsl:text>
			</xsl:attribute>	
			<xsl:apply-templates select="node()"/> 
		</xsl:copy>		 
	</xsl:if>
	<xsl:if test="@styleCode='Underline'">
		<xsl:copy>
			<xsl:attribute name="style">
				<xsl:text>text-decoration: underline;</xsl:text>
			</xsl:attribute>	
			<xsl:apply-templates select="node()"/> 
		</xsl:copy>		 
	</xsl:if>
	<xsl:if test="@styleCode='Bold Italics'">
		<xsl:copy>
			<xsl:attribute name="style">
				<xsl:text>font-weight: bold; font-style: italic;</xsl:text>
			</xsl:attribute>	
			<xsl:apply-templates select="node()"/> 
		</xsl:copy>
	</xsl:if> 
	<xsl:if test="@styleCode='Bold Underline'">
		<xsl:copy>
			<xsl:attribute name="style">
				<xsl:text>font-weight: bold; text-decoration: underline;</xsl:text>
			</xsl:attribute>	
			<xsl:apply-templates select="node()"/> 
		</xsl:copy>		 
	</xsl:if>
	<xsl:if test="@styleCode='Italics Underline'">
		<xsl:copy>
			<xsl:attribute name="style">
				<xsl:text>font-style: italic; text-decoration: underline;</xsl:text>
			</xsl:attribute>	
			<xsl:apply-templates select="node()"/> 
		</xsl:copy>		 
	</xsl:if>
	<xsl:if test="@styleCode='Bold Italics Underline'">
		<xsl:copy>
			<xsl:attribute name="style">
				<xsl:text>font-weight: bold; font-style: italic; text-decoration: underline;</xsl:text>
			</xsl:attribute>	
			<xsl:apply-templates select="node()"/> 
		</xsl:copy>		 
	</xsl:if>
</xsl:template>

<!-- 	Superscript   -->
<xsl:template match="n1:sup">
	<xsl:element name='sup'>		 		 		 		 
		<xsl:apply-templates/>
	</xsl:element>		 
</xsl:template>

<!-- 	Subscript   -->
<xsl:template match="n1:sub">
	<xsl:element name='sub'>		 		 		 		 
		<xsl:apply-templates/>
	</xsl:element>		 
</xsl:template>

<!-- 	Support Relationship   -->
<xsl:template match="n1:associatedEntity/@classCode">
	<xsl:variable name="participant" select="."/>
	<xsl:choose>
		<xsl:when test="$participant='CAREGIVER'">
			<xsl:text>Caregiver</xsl:text>
		</xsl:when>
		<xsl:when test="$participant='PRS'">
			<xsl:text>Personal Relationship</xsl:text>
		</xsl:when>
		<xsl:when test="$participant='NOK'">
			<xsl:text>Next of Kin</xsl:text>
		</xsl:when>
		<xsl:when test="$participant='AGNT'">
			<xsl:text>Agent</xsl:text>
		</xsl:when>
		<xsl:when test="$participant='GUAR'">
			<xsl:text>Guarantor</xsl:text>
		</xsl:when>
		<xsl:when test="$participant='ECON'">
			<xsl:text>Emergency Contact</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$participant"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 	Care Team Member Function   -->
<xsl:template match="n1:functionCode">
	<xsl:variable name="performerFunc" select="./@code"/>
	<xsl:choose>
		<xsl:when test="$performerFunc='PCP'">
			<xsl:text>primary care physician</xsl:text>
		</xsl:when>
		<xsl:when test="$performerFunc='ADMPHYS'">
			<xsl:text>admitting physician</xsl:text>
		</xsl:when>
		<xsl:when test="$performerFunc='ANEST'">
			<xsl:text>anesthesist</xsl:text>
		</xsl:when>
		<xsl:when test="$performerFunc='ANRS'">
			<xsl:text>anesthesia nurse</xsl:text>
		</xsl:when>
		<xsl:when test="$performerFunc='ATTPHYS'">
			<xsl:text>attending physician</xsl:text>
		</xsl:when>
		<xsl:when test="$performerFunc='DISPHYS'">
			<xsl:text>discharging physician</xsl:text>
		</xsl:when>
		<xsl:when test="$performerFunc='FASST'">
			<xsl:text>first assistant surgeon</xsl:text>
		</xsl:when>
		<xsl:when test="$performerFunc='MDWF'">
			<xsl:text>midwife</xsl:text>
		</xsl:when>
		<xsl:when test="$performerFunc='NASST'">
			<xsl:text>nurse assistant</xsl:text>
		</xsl:when>
		<xsl:when test="$performerFunc='PRISURG'">
			<xsl:text>primary surgeon</xsl:text>
		</xsl:when>
		<xsl:when test="$performerFunc='RNDPHYS'">
			<xsl:text>rounding physician</xsl:text>
		</xsl:when>
		<xsl:when test="$performerFunc='SASST'">
			<xsl:text>second assistant surgeon</xsl:text>
		</xsl:when>
		<xsl:when test="$performerFunc='SNRS'">
			<xsl:text>scrub nurse</xsl:text>
		</xsl:when>
		<xsl:when test="$performerFunc='TASST'">
			<xsl:text>third assistant</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="mixedCase"> 
				<xsl:with-param name="toconvert" select="./@displayName"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Set Marital Status -->
<xsl:template name="getMaritalStatus">
	<xsl:param name="maritalStatus"/>
	<xsl:choose>
		<xsl:when test="$maritalStatus/@code='A'">
			<xsl:text>Anulled</xsl:text>
		</xsl:when>
		<xsl:when test="$maritalStatus/@code='D'">
			<xsl:text>Divorced</xsl:text>
		</xsl:when>
		<xsl:when test="$maritalStatus/@code='I'">
			<xsl:text>Interlocutory</xsl:text>
		</xsl:when>
		<xsl:when test="$maritalStatus/@code='L'">
			<xsl:text>Legally Separated</xsl:text>
		</xsl:when>
		<xsl:when test="$maritalStatus/@code='M'">
			<xsl:text>Married</xsl:text>
		</xsl:when>
		<xsl:when test="$maritalStatus/@code='P'">
			<xsl:text>Domestic Partner</xsl:text>
		</xsl:when>
		<xsl:when test="$maritalStatus/@code='S'">
			<xsl:text>Never Married</xsl:text>
		</xsl:when>
		<xsl:when test="$maritalStatus/@code='T'">
			<xsl:text>Unreported</xsl:text>
		</xsl:when>
		<xsl:when test="$maritalStatus/@code='W'">
			<xsl:text>Widowed</xsl:text>
		</xsl:when>
		<xsl:when test="$maritalStatus/@displayName">
			<xsl:value-of select="$maritalStatus/@displayName"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Unknown</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Set Religion -->
<xsl:template name="getReligion">
	<xsl:param name="religion"/>
	<xsl:choose>
		<xsl:when test="$religion/@code='1008'"> 
 			<xsl:text>Babi &amp; Baha&apos;I faiths</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1009'"> 
 			<xsl:text>Baptist</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1010'"> 
 			<xsl:text>Bon</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1011'"> 
 			<xsl:text>Cao Dai</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1012'"> 
 			<xsl:text>Celticism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1013'"> 
 			<xsl:text>Christian (non-Catholic, non-specific)</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1014'"> 
 			<xsl:text>Confucianism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1015'"> 
 			<xsl:text>Cyberculture Religions</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1016'"> 
 			<xsl:text>Divination</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1017'"> 
 			<xsl:text>Fourth Way</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1018'"> 
 			<xsl:text>Free Daism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1019'"> 
 			<xsl:text>Gnosis</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1020'"> 
 			<xsl:text>Hinduism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1021'"> 
 			<xsl:text>Humanism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1022'"> 
 			<xsl:text>Independent</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1023'"> 
 			<xsl:text>Islam</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1024'"> 
 			<xsl:text>Jainism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1025'"> 
 			<xsl:text>Jehovah&apos;s Witnesses</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1026'"> 
 			<xsl:text>Judaism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1027'"> 
 			<xsl:text>Latter Day Saints</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1028'"> 
 			<xsl:text>Lutheran</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1029'"> 
 			<xsl:text>Mahayana</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1030'"> 
 			<xsl:text>Meditation</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1031'"> 
 			<xsl:text>Messianic Judaism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1032'"> 
 			<xsl:text>Mitraism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1033'"> 
 			<xsl:text>New Age</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1034'"> 
 			<xsl:text>non-Roman Catholic</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1035'"> 
 			<xsl:text>Occult</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1036'"> 
 			<xsl:text>Orthodox</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1037'"> 
 			<xsl:text>Paganism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1038'"> 
 			<xsl:text>Pentecostal</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1039'"> 
 			<xsl:text>Process, The</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1040'"> 
 			<xsl:text>Reformed/Presbyterian</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1041'"> 
 			<xsl:text>Roman Catholic Church</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1042'"> 
 			<xsl:text>Satanism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1043'"> 
 			<xsl:text>Scientology</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1044'"> 
 			<xsl:text>Shamanism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1045'"> 
 			<xsl:text>Shiite (Islam)</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1046'"> 
 			<xsl:text>Shinto</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1047'"> 
 			<xsl:text>Sikism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1048'"> 
 			<xsl:text>Spiritualism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1049'"> 
 			<xsl:text>Sunni (Islam)</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1050'"> 
 			<xsl:text>Taoism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1051'"> 
 			<xsl:text>Theravada</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1052'"> 
 			<xsl:text>Unitarian-Universalism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1053'"> 
 			<xsl:text>Universal Life Church</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1054'"> 
 			<xsl:text>Vajrayana (Tibetan)</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1055'"> 
 			<xsl:text>Veda</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1056'"> 
 			<xsl:text>Voodoo</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1057'"> 
 			<xsl:text>Wicca</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1058'"> 
 			<xsl:text>Yaohushua</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1059'"> 
 			<xsl:text>Zen Buddhism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1060'"> 
 			<xsl:text>Zoroastrianism</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1062'"> 
 			<xsl:text>Brethren</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1063'"> 
 			<xsl:text>Christian Scientist</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1064'"> 
 			<xsl:text>Church of Christ</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1065'"> 
 			<xsl:text>Church of God</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1066'"> 
 			<xsl:text>Congregational</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1067'"> 
 			<xsl:text>Disciples of Christ</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1068'"> 
 			<xsl:text>Eastern Orthodox</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1069'"> 
 			<xsl:text>Episcopalian</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1070'"> 
 			<xsl:text>Evangelical Covenant</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1071'"> 
 			<xsl:text>Friends</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1072'"> 
 			<xsl:text>Full Gospel</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1073'"> 
 			<xsl:text>Methodist</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1074'"> 
 			<xsl:text>Native American</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1075'"> 
 			<xsl:text>Nazarene</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1076'"> 
 			<xsl:text>Presbyterian</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1077'"> 
 			<xsl:text>Protestant</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1078'"> 
 			<xsl:text>Protestant, No Denomination</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1079'"> 
 			<xsl:text>Reformed</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1080'"> 
 			<xsl:text>Salvation Army</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1081'"> 
 			<xsl:text>Unitarian Universalist</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@code='1082'"> 
 			<xsl:text>United Church of Christ</xsl:text> 
 		</xsl:when>
		<xsl:when test="$religion/@displayName">
			<xsl:value-of select="$religion/@displayName"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Unknown</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Set Race Code -->
<xsl:template name="getRaceCode">
	<xsl:param name="raceCode"/>
	<xsl:choose>
		<xsl:when test="$raceCode/@code='1002-5'">
			<xsl:text>American Indian or Alaska Native</xsl:text>
		</xsl:when>
		<xsl:when test="$raceCode/@code='2028-9'">
			<xsl:text>Asian</xsl:text>
		</xsl:when>
		<xsl:when test="$raceCode/@code='2054-5'">
			<xsl:text>Black or African-American</xsl:text>
		</xsl:when>
		<xsl:when test="$raceCode/@code='2076-8'">
			<xsl:text>Native Hawaiian or Other Pacific Islander</xsl:text>
		</xsl:when>
		<xsl:when test="$raceCode/@code='2131-1'">
			<xsl:text>Other</xsl:text>
		</xsl:when>
		<xsl:when test="$raceCode/@code='2106-3'">
			<xsl:text>White</xsl:text>
		</xsl:when>
		<xsl:when test="$raceCode/@displayName">
			<xsl:value-of select="$raceCode/@displayName"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Unknown</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Set Ethnic Group -->
<xsl:template name="getEthnicGroup">
	<xsl:param name="ethnicGroup"/>
	<xsl:choose>
		<xsl:when test="$ethnicGroup/@code='2135-2'">
			<xsl:text>Hispanic or Latino</xsl:text>
		</xsl:when>
		<xsl:when test="$ethnicGroup/@code='2186-5'">
			<xsl:text>Not Hispanic or Latino</xsl:text>
		</xsl:when>
		<xsl:when test="$ethnicGroup/@displayName">
			<xsl:value-of select="$ethnicGroup/@displayName"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Unknown</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="mixedCase">
	<xsl:param name="toconvert"/>
	<xsl:value-of select="translate($toconvert,$uppercase,$lowercase)"/>
</xsl:template>

<!-- Set Language -->
<xsl:template name="getLang">
	<xsl:param name="lang"/>
	<xsl:choose>
	<xsl:when test="$lang/@displayName">
		<xsl:value-of select="$lang/@displayName"/>
	</xsl:when>
	<xsl:when test="$lang/@code='aar'">
		<xsl:text>Afar</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='abk'">
		<xsl:text>Abkhazian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='afr'">
		<xsl:text>Afrikaans</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ain'">
		<xsl:text>Ainu</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='aka'">
		<xsl:text>Akan</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='alb'">
		<xsl:text>Albanian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='amh'">
		<xsl:text>Amharic</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ara'">
		<xsl:text>Arabic</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='arg'">
		<xsl:text>Aragonese</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='arm'">
		<xsl:text>Armenian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='asm'">
		<xsl:text>Assamese</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ava'">
		<xsl:text>Avaric</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ave'">
		<xsl:text>Avestan</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='aym'">
		<xsl:text>Aymara</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='aze'">
		<xsl:text>Azerbaijani</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='bak'">
		<xsl:text>Bashkir</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='bam'">
		<xsl:text>Bambara</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='baq'">
		<xsl:text>Basque</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='bel'">
		<xsl:text>Belarusian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ben'">
		<xsl:text>Bengali</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='bih'">
		<xsl:text>Bihari languages</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='bis'">
		<xsl:text>Bislama</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='bos'">
		<xsl:text>Bosnian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='bre'">
		<xsl:text>Breton</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='bul'">
		<xsl:text>Bulgarian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='bur'">
		<xsl:text>Burmese</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='cat'">
		<xsl:text>Catalan; Valencian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='cha'">
		<xsl:text>Chamorro</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='che'">
		<xsl:text>Chechen</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='chi'">
		<xsl:text>Chinese</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='chu'">
		<xsl:text>Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old Church Slavonic</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='chv'">
		<xsl:text>Chuvash</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='cor'">
		<xsl:text>Cornish</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='cos'">
		<xsl:text>Corsican</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='cre'">
		<xsl:text>Cree</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='cze'">
		<xsl:text>Czech</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='dan'">
		<xsl:text>Danish</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='div'">
		<xsl:text>Divehi; Dhivehi; Maldivian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='dut'">
		<xsl:text>Dutch; Flemish</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='dzo'">
		<xsl:text>Dzongkha</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='eng'">
		<xsl:text>English</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='epo'">
		<xsl:text>Esperanto</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='est'">
		<xsl:text>Estonian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ewe'">
		<xsl:text>Ewe</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='fao'">
		<xsl:text>Faroese</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='fij'">
		<xsl:text>Fijian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='fin'">
		<xsl:text>Finnish</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='fre'">
		<xsl:text>French</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='fry'">
		<xsl:text>Western Frisian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ful'">
		<xsl:text>Fulah</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='geo'">
		<xsl:text>Georgian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ger'">
		<xsl:text>German</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='gla'">
		<xsl:text>Gaelic; Scottish Gaelic</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='gle'">
		<xsl:text>Irish</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='glg'">
		<xsl:text>Galician</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='glv'">
		<xsl:text>Manxs</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='gre'">
		<xsl:text>Greek, Modern (1453-)</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='grn'">
		<xsl:text>Guarani</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='guj'">
		<xsl:text>Gujarati</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='hat'">
		<xsl:text>Haitian; Haitian Creole</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='hau'">
		<xsl:text>Hausa</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='heb'">
		<xsl:text>Hebrew</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='her'">
		<xsl:text>Herero</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='hin'">
		<xsl:text>Hindi</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='hmo'">
		<xsl:text>Hiri Motu</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='hrv'">
		<xsl:text>Croatian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='hun'">
		<xsl:text>Hungarian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ibo'">
		<xsl:text>Igbo</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ice'">
		<xsl:text>Icelandic</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ido'">
		<xsl:text>Ido</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='iii'">
		<xsl:text>Sichuan Yi; Nuosu</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='iku'">
		<xsl:text>Inuktitut</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ile'">
		<xsl:text>Interlingue; Occidental</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ina'">
		<xsl:text>Interlingua (International Auxiliary Language Association)</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ind'">
		<xsl:text>Indonesian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ipk'">
		<xsl:text>Inupiaq</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ita'">
		<xsl:text>Italian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='jav'">
		<xsl:text>Javanese</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='jpn'">
		<xsl:text>Japanese</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='kal'">
		<xsl:text>Kalaallisut; Greenlandic</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='kan'">
		<xsl:text>Kannada</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='kas'">
		<xsl:text>Kashmiri</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='kau'">
		<xsl:text>Kanuri</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='kaz'">
		<xsl:text>Kazakh</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='khm'">
		<xsl:text>Central Khmer</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='kik'">
		<xsl:text>Kikuyu; Gikuyu</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='kin'">
		<xsl:text>Kinyarwanda</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='kir'">
		<xsl:text>Kirghiz; Kyrgyz</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='kom'">
		<xsl:text>Komi</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='kon'">
		<xsl:text>Kongo</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='kor'">
		<xsl:text>Korean</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='kua'">
		<xsl:text>Kuanyama; Kwanyama</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='kur'">
		<xsl:text>Kurdish</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='lao'">
		<xsl:text>Lao</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='lat'">
		<xsl:text>Latin</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='lav'">
		<xsl:text>Latvian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='lez'">
		<xsl:text>Lezghian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='lim'">
		<xsl:text>Limburgan; Limburger; Limburgish</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='lin'">
		<xsl:text>Lingala</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='lit'">
		<xsl:text>Lithuanian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ltz'">
		<xsl:text>Luxembourgish; Letzeburgesch</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='lub'">
		<xsl:text>Luba-Katanga</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='lug'">
		<xsl:text>Ganda</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='mac'">
		<xsl:text>Macedonian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='mah'">
		<xsl:text>Marshallese</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='mal'">
		<xsl:text>Malayalam</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='mao'">
		<xsl:text>Maori</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='mar'">
		<xsl:text>Marathi</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='may'">
		<xsl:text>Malay</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='mlg'">
		<xsl:text>Malagasy</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='mlt'">
		<xsl:text>Maltese</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='mon'">
		<xsl:text>Mongolian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='nau'">
		<xsl:text>Nauru</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='nav'">
		<xsl:text>Navajo; Navaho</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='nbl'">
		<xsl:text>Ndebele, South; South Ndebele</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='nde'">
		<xsl:text>Ndebele, North; North Ndebele</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ndo'">
		<xsl:text>Ndonga</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='nep'">
		<xsl:text>Nepali</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='nno'">
		<xsl:text>Norwegian Nynorsk; Nynorsk, Norwegian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='nob'">
		<xsl:text>Bokmål, Norwegian; Norwegian Bokmål</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='nor'">
		<xsl:text>Norwegian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='nya'">
		<xsl:text>Chichewa; Chewa; Nyanja</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='oci'">
		<xsl:text>Occitan (post 1500); Provençal</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='oji'">
		<xsl:text>Ojibwa</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ori'">
		<xsl:text>Oriya</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='orm'">
		<xsl:text>Oromo</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='oss'">
		<xsl:text>Ossetian; Ossetic</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='pan'">
		<xsl:text>Panjabi; Punjabi</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='per'">
		<xsl:text>Persian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='pli'">
		<xsl:text>Pali</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='pol'">
		<xsl:text>Polish</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='por'">
		<xsl:text>Portuguese</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='pus'">
		<xsl:text>Pushto; Pashto</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='que'">
		<xsl:text>Quechua</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='roh'">
		<xsl:text>Romansh</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='rum'">
		<xsl:text>Romanian; Moldavian; Moldovan</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='run'">
		<xsl:text>Rundi</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='rus'">
		<xsl:text>Russian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='sag'">
		<xsl:text>Sango</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='san'">
		<xsl:text>Sanskrit</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='sin'">
		<xsl:text>Sinhala; Sinhalese</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='slo'">
		<xsl:text>Slovak</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='slv'">
		<xsl:text>Slovenian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='sme'">
		<xsl:text>Northern Sami</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='smo'">
		<xsl:text>Samoan</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='sna'">
		<xsl:text>Shona</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='snd'">
		<xsl:text>Sindhi</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='som'">
		<xsl:text>Somali</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='sot'">
		<xsl:text>Sotho, Southern</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='spa'">
		<xsl:text>Spanish; Castilian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='srd'">
		<xsl:text>Sardinian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='srp'">
		<xsl:text>Serbian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ssw'">
		<xsl:text>Swati</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='sun'">
		<xsl:text>Sundanese</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='swa'">
		<xsl:text>Swahili</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='swe'">
		<xsl:text>Swedish</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='tah'">
		<xsl:text>Tahitian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='tam'">
		<xsl:text>Tamil</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='tat'">
		<xsl:text>Tatar</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='tel'">
		<xsl:text>Telugu</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='tgk'">
		<xsl:text>Tajik</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='tgl'">
		<xsl:text>Tagalog</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='tha'">
		<xsl:text>Thai</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='tib'">
		<xsl:text>Tibetan</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='tir'">
		<xsl:text>Tigrinya</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ton'">
		<xsl:text>Tonga (Tonga Islands)</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='tsn'">
		<xsl:text>Tswana</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='tso'">
		<xsl:text>Tsonga</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='tuk'">
		<xsl:text>Turkmen</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='tur'">
		<xsl:text>Turkish</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='twi'">
		<xsl:text>Twi</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='uig'">
		<xsl:text>Uighur; Uyghur</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ukr'">
		<xsl:text>Ukrainian</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='urd'">
		<xsl:text>Urdu</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='uzb'">
		<xsl:text>Uzbek</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='ven'">
		<xsl:text>Venda</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='vie'">
		<xsl:text>Vietnamese</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='vol'">
		<xsl:text>Volapük</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='wel'">
		<xsl:text>Welsh</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='wln'">
		<xsl:text>Walloon</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='wol'">
		<xsl:text>Wolof</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='xho'">
		<xsl:text>Xhosa</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='yid'">
		<xsl:text>Yiddish</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='yor'">
		<xsl:text>Yoruba</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='zha'">
		<xsl:text>Zhuang; Chuang</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='zul'">
		<xsl:text>Zulu</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code='en-US'">
		<xsl:text>English</xsl:text>
	</xsl:when>
	<xsl:when test="$lang/@code">
		<xsl:value-of select="$lang/@code"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>Unknown</xsl:text>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>
		 
<!-- Set Relationship -->
<xsl:template name="getRelationship">
	<xsl:param name="relat"/>
	<xsl:choose>
		<xsl:when test="$relat/@code='FAMMEMB'">
			<xsl:text>Family Member</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='CHILD'">
			<xsl:text>Child</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='CHLDADOPT'">
			<xsl:text>Adopted Child</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='DAUADOPT'">
			<xsl:text>Adopted Daughter</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='SONADOPT'">
			<xsl:text>Adopted Son</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='CHLDFOST'">
			<xsl:text>Foster Child</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='DAUFOST'">
			<xsl:text>Foster Daughter</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='SONFOST'">
			<xsl:text>Foster Son</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='CHLDINLAW'">
			<xsl:text>Child In-law</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='DAUINLAW'">
			<xsl:text>Daughter In-law</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='SONINLAW'">
			<xsl:text>Son In-law</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='DAUC'">
			<xsl:text>Daughter</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='DAUADOPT'">
			<xsl:text>Adopted Daughter</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='DAUFOST'">
			<xsl:text>Foster Daughter</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='DAU'">
			<xsl:text>Daughter</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='STPDAU'">
			<xsl:text>Step-Daughter</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='NCHILD'">
			<xsl:text>Natural Child</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='DAU'">
			<xsl:text>Daughter</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='SON'">
			<xsl:text>Son</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='SONC'">
			<xsl:text>Son</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='SONADOPT'">
			<xsl:text>Adopted Son</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='SONFOST'">
			<xsl:text>Foster Son</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='SON'">
			<xsl:text>Son</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='STPSON'">
			<xsl:text>Step-Son</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='STPCHLD'">
			<xsl:text>Step-Child</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='STPDAU'">
			<xsl:text>Step-Daughter</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='STPSON'">
			<xsl:text>Step-Son</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='EXT'">
			<xsl:text>Extended Family Member</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='AUNT'">
			<xsl:text>Aunt</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='MAUNT'">
			<xsl:text>Maternal Aunt</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='PAUNT'">
			<xsl:text>Paternal Aunt</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='COUSN'">
			<xsl:text>Cousin</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='MCOUSN'">
			<xsl:text>Maternal Cousin</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='PCOUSN'">
			<xsl:text>Paternal Cousin</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='GGRPRN'">
			<xsl:text>Great-Grandparent</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='GGRFTH'">
			<xsl:text>Great-Grandfather</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='GGRMTH'">
			<xsl:text>Great-Grandmother</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='MGGRFTH'">
			<xsl:text>Maternal Great-Grandfather</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='MGGRMTH'">
			<xsl:text>Maternal Great-Grandmother</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='MGGRPRN'">
			<xsl:text>Maternal Great-Grandparent</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='PGGRFTH'">
			<xsl:text>Paternal Great-Grandfather</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='PGGRMTH'">
			<xsl:text>Paternal Great-Grandmother</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='PGGRPRN'">
			<xsl:text>Paternal Great-Grandparent</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='GRNDCHILD'">
			<xsl:text>Grandchild</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='GRNDDAU'">
			<xsl:text>Granddaughter</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='GRNDSON'">
			<xsl:text>Grandson</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='GRPRN'">
			<xsl:text>Grandparent</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='GRFTH'">
			<xsl:text>Grandfather</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='GRMTH'">
			<xsl:text>Grandmother</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='MGRFTH'">
			<xsl:text>Maternal Grandfather</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='MGRMTH'">
			<xsl:text>Maternal Grandmother</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='MGRPRN'">
			<xsl:text>Maternal Grandparent</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='PGRFTH'">
			<xsl:text>Paternal Grandfather</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='PGRMTH'">
			<xsl:text>Paternal Grandmother</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='PGRPRN'">
			<xsl:text>Paternal Grandparent</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='NIENEPH'">
			<xsl:text>Niece/Nephew</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='NEPHEW'">
			<xsl:text>Nephew</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='NIECE'">
			<xsl:text>Niece</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='UNCLE'">
			<xsl:text>Uncle</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='MUNCLE'">
			<xsl:text>Maternal Uncle</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='PUNCLE'">
			<xsl:text>Paternal Uncle</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='PRN'">
			<xsl:text>Parent</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='FTH'">
			<xsl:text>Father</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='MTH'">
			<xsl:text>Mother</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='NPRN'">
			<xsl:text>Natural Parent</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='NFTH'">
			<xsl:text>Natural Father</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='NFTHF'">
			<xsl:text>Natural Father of Fetus</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='NMTH'">
			<xsl:text>Natural Mother</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='PRNINLAW'">
			<xsl:text>Parent In-law</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='FTHINLAW'">
			<xsl:text>Father-In-law</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='MTHINLAW'">
			<xsl:text>Mother-In-law</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='STPPRN'">
			<xsl:text>Step-parent</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='STPFTH'">
			<xsl:text>Step-father</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='STPMTH'">
			<xsl:text>Step-mother</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='SIB'">
			<xsl:text>Sibling</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='BRO'">
			<xsl:text>Brother</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='HSIB'">
			<xsl:text>Half-Sibling</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='HBRO'">
			<xsl:text>Half-Brother</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='HSIS'">
			<xsl:text>Half-Sister</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='NSIB'">
			<xsl:text>Natural Sibling</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='NBRO'">
			<xsl:text>Natural Brother</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='NSIS'">
			<xsl:text>Natural Sister</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='SIBINLAW'">
			<xsl:text>Sibling In-law</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='BROINLAW'">
			<xsl:text>Brother-In-law</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='SISINLAW'">
			<xsl:text>Sister-In-law</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='SIS'">
			<xsl:text>Sister</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='STPSIB'">
			<xsl:text>Step Sibling</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='STPBRO'">
			<xsl:text>Step-Brother</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='STPSIS'">
			<xsl:text>Step-Sister</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='SIGOTHR'">
			<xsl:text>Significant Other</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='DOMPART'">
			<xsl:text>Domestic Partner</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='SPS'">
			<xsl:text>Spouse</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='HUSB'">
			<xsl:text>Husband</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='WIFE'">
			<xsl:text>Wife</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='FRND'">
			<xsl:text>Unrelated Friend</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='NBOR'">
			<xsl:text>Neighbor</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@code='ROOM'">
			<xsl:text>Roommate</xsl:text>
		</xsl:when>
		<xsl:when test="$relat/@displayName">
			<xsl:value-of select="$relat/@displayName"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Unavailable</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
		 
<xsl:template name="addCSS">
	<style type="text/css">
		body {
			color: #000000;
			background-color: #FFFFFF;
			font-family: Verdana, Tahoma, sans-serif;
			font-size: 12px;
			margin-left: 35px;
		}
		
		#mtdd {
			white-space: pre-wrap;
		}
		
		table.gridtable {
			font-family: verdana,arial,sans-serif;
			font-size:12px;
			color:#333333;
			border-width: 1px;
			border-color: #000000;
			border-collapse: collapse;
			margin: 0px auto; 
			text-align:left;
		}
		
		table.gridtable th {
			border-width: 1px;
			padding: 8px;
			border-style: solid;
			border-color: #000000;
			background-color: #ffffff;
		}
		
		table.gridtable td {
			border-width: 1px;
			padding: 8px;
			border-style: solid;
			border-color: #000000;
			background-color: #ffffff;
		}
	</style>
</xsl:template>

<xsl:template name="addJS">
	<script language="JavaScript" type="text/javascript">
		function Toggle(n) {
			var e = document.getElementById(n);
			if(e.style.display == 'block')
				e.style.display = 'none';
			else
				e.style.display = 'block';
		} 
	</script> 
</xsl:template>

</xsl:stylesheet>