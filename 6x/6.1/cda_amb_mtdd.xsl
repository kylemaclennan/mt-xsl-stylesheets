<?xml version="1.0" encoding="windows-1252"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n3="http://www.w3.org/1999/xhtml" xmlns:n1="urn:hl7-org:v3" xmlns:n2="urn:hl7-org:v3/meta/voc" xmlns:voc="urn:hl7-org:v3/voc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc">
	<xsl:output method="html" indent="yes" version="4.01" encoding="ISO-8859-1" doctype-public="-//W3C//DTD HTML 4.01//EN"/>

	<!-- CDA document -->

	<xsl:variable name="title">
		<xsl:choose>
			<xsl:when test="/n1:ClinicalDocument/n1:title">
				<xsl:value-of select="/n1:ClinicalDocument/n1:title"/>
			</xsl:when>
			<xsl:otherwise>Clinical Document</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

	<xsl:template match="/">
		<xsl:apply-templates select="n1:ClinicalDocument"/>
	</xsl:template>

	<xsl:template match="n1:ClinicalDocument">
		<xsl:element name="html">
			<xsl:element name="body">
				<xsl:element name="h2">
					<xsl:element name="br"/>
					<xsl:element name="center">
						<xsl:value-of select="$title"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="br"/>
				<xsl:element name="center">
					<xsl:element name="b">
						<xsl:text>Created On:</xsl:text>
					</xsl:element>
					<xsl:text> </xsl:text>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="date" select="/n1:ClinicalDocument/n1:effectiveTime/@value"/>
					</xsl:call-template>
				</xsl:element>	

				<!-- Demographics -->	
				<xsl:element name="p"/>				
				<xsl:element name="h3">
					<xsl:text>Demographics</xsl:text>
				</xsl:element>
				<xsl:element name="br"/>
				<xsl:call-template name="demographics">
					<xsl:with-param name="patientRole" select="/n1:ClinicalDocument/n1:recordTarget/n1:patientRole"/>
				</xsl:call-template>

				<!-- Author -->
				<xsl:if test="/n1:ClinicalDocument/n1:author/n1:assignedAuthor/n1:representedOrganization">
					<xsl:element name="br"/>
					<xsl:call-template name="author">
						<xsl:with-param name="author" select="/n1:ClinicalDocument/n1:author/n1:assignedAuthor"/>
					</xsl:call-template>
				</xsl:if>

				<!-- Participant -->
				<xsl:if test="/n1:ClinicalDocument/n1:participant">
					<xsl:element name="br"/>
					<xsl:element name="h3">
						<xsl:text>Support</xsl:text>
					</xsl:element>
					<xsl:element name="br"/>
					<xsl:element name="table">
						<xsl:element name="tr">
							<xsl:element name="th">Name</xsl:element>
							<xsl:element name="th">Relationship</xsl:element>
							<xsl:element name="th">Role</xsl:element>
							<xsl:element name="th">Address</xsl:element>
							<xsl:element name="th">Phone</xsl:element>
						</xsl:element>
						<xsl:apply-templates select="/n1:ClinicalDocument/n1:participant"/>
					</xsl:element>
				</xsl:if>

				<!-- Performer -->
				<xsl:if test="/n1:ClinicalDocument/n1:documentationOf/n1:serviceEvent/n1:performer">
					<xsl:element name="br"/>
					<xsl:element name="h3">
						<xsl:text>Care Team Providers</xsl:text>
					</xsl:element>
					<xsl:element name="br"/>
					<xsl:element name="table">
						<xsl:element name="tr">
							<xsl:element name="th">Care Team Member Name</xsl:element>
							<xsl:element name="th">Role</xsl:element>
							<xsl:element name="th">Phone</xsl:element>
						</xsl:element>
						<xsl:apply-templates select="/n1:ClinicalDocument/n1:documentationOf/n1:serviceEvent/n1:performer"/>
					</xsl:element>
				</xsl:if>

				<!-- Encounter Participant -->
				<xsl:if test="/n1:ClinicalDocument/n1:componentOf/n1:encompassingEncounter/n1:encounterParticipant/n1:assignedEntity">
					<xsl:element name="br"/>
					<xsl:element name="h3">
						<xsl:text>Provider Referred From</xsl:text>
					</xsl:element>
					<xsl:element name="br"/>
					<xsl:variable name="assigned" select="/n1:ClinicalDocument/n1:componentOf/n1:encompassingEncounter/n1:encounterParticipant/n1:assignedEntity"/>
					<xsl:element name="br"/>
					<xsl:element name="table">
						<xsl:if test="$assigned/n1:assignedPerson">
							<xsl:element name="tr">
								<xsl:element name="th">Name</xsl:element>
								<xsl:element name="td">
									<xsl:choose>
										<xsl:when test="$assigned/n1:assignedPerson/n1:name/@nullFlavor">
											<xsl:text>Unavailable</xsl:text>
										</xsl:when>
										<xsl:when test="$assigned/n1:assignedPerson/n1:name">									   
											<xsl:value-of select="$assigned/n1:assignedPerson/n1:name"/>
										</xsl:when>  
									</xsl:choose>   
								</xsl:element>
							</xsl:element>
						</xsl:if>
						<xsl:if test="$assigned/n1:addr">
							<xsl:element name="tr">
								<xsl:element name="th">Address</xsl:element>
								<xsl:element name="td">
									<xsl:choose>
										<xsl:when test="$assigned/n1:addr/@nullFlavor">
											<xsl:text>Unavailable</xsl:text>
										</xsl:when>
										<xsl:when test="$assigned/n1:addr">
											<xsl:call-template name="getAddress"> 
												<xsl:with-param name="addr" select="$assigned/n1:addr"/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>									   
								</xsl:element>
							</xsl:element>
						</xsl:if>
						<xsl:if test="$assigned/n1:telecom">
							<xsl:for-each select="$assigned/n1:telecom">
								<xsl:choose>
									<xsl:when test="self::node()[@use='HP']">
										<xsl:element name="tr">
											<xsl:element name="th">Phone</xsl:element>
											<xsl:element name="td">
												<xsl:call-template name="getTelecom"> 
													<xsl:with-param name="telecom" select="self::node()[@value]"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:element name="tr">
											<xsl:element name="th">Email Address</xsl:element>
											<xsl:element name="td">
												<xsl:call-template name="getEmail"> 
													<xsl:with-param name="email" select="self::node()[@value]"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:element>
									</xsl:otherwise>
								</xsl:choose>	
							</xsl:for-each>	
						</xsl:if>
					</xsl:element>
				</xsl:if>

				<xsl:apply-templates select="n1:component/n1:structuredBody"/> 
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<!-- Demographics -->
	<xsl:template name="demographics">
		<xsl:param name="patientRole"/>
		<xsl:element name="table">
			<xsl:element name="tr">
				<xsl:element name="th">Patient Name</xsl:element>
				<xsl:element name="td">
					<xsl:call-template name="getName">
						<xsl:with-param name="name" select="$patientRole/n1:patient/n1:name"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
			<xsl:if test="$patientRole/n1:addr">
				<xsl:element name="tr">
					<xsl:element name="th">Address</xsl:element>			
					<xsl:element name="td">
						<xsl:call-template name="getAddress"> 
							<xsl:with-param name="addr" select="$patientRole/n1:addr[1]"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$patientRole/n1:addr[2]">
				<xsl:element name="tr">
					<xsl:element name="th">Previous Address</xsl:element>			
					<xsl:element name="td">
						<xsl:call-template name="getPreviousAddress"> 
							<xsl:with-param name="addr" select="$patientRole/n1:addr[2]"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:for-each select="$patientRole/n1:telecom">
				<xsl:choose>
					<xsl:when test="self::node()[@nullFlavor='UNK']">
						<xsl:element name="tr">
							<xsl:element name="th">Phone</xsl:element>			
							<xsl:element name="td">Unknown</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="self::node()[@use='HP']">
						<xsl:element name="tr">
							<xsl:element name="th">Home Phone</xsl:element>			
							<xsl:element name="td">
								<xsl:call-template name="getTelecom"> 
									<xsl:with-param name="telecom" select="self::node()[@value]"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="self::node()[@use='WP']">
						<xsl:element name="tr">
							<xsl:element name="th">Work Phone</xsl:element>			
							<xsl:element name="td">
								<xsl:call-template name="getTelecom"> 
									<xsl:with-param name="telecom" select="self::node()[@value]"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="tr">
							<xsl:element name="th">Email Address</xsl:element>			
							<xsl:element name="td">
								<xsl:call-template name="getEmail"> 
									<xsl:with-param name="email" select="self::node()[@value]"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:element>					
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<xsl:element name="tr">
				<xsl:element name="th">Sex</xsl:element>
				<xsl:element name="td">
					<xsl:variable name="sex" select="/n1:ClinicalDocument/n1:recordTarget/n1:patientRole/n1:patient/n1:administrativeGenderCode/@code"/>
					<xsl:choose>
						<xsl:when test="$sex='M'">Male</xsl:when>
						<xsl:when test="$sex='F'">Female</xsl:when>
						<xsl:otherwise>Undifferentiated</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:element>
			<xsl:element name="tr">
				<xsl:element name="th">Birthdate</xsl:element>
				<xsl:element name="td">
					<xsl:call-template name="formatDate">
						<xsl:with-param name="date" select="/n1:ClinicalDocument/n1:recordTarget/n1:patientRole/n1:patient/n1:birthTime/@value"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
			<xsl:element name="tr">
				<xsl:element name="th">Marital Status</xsl:element>
				<xsl:element name="td">
					<xsl:call-template name="getMaritalStatus">
						<xsl:with-param name="maritalStatus" select="$patientRole/n1:patient/n1:maritalStatusCode"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
			<xsl:element name="tr">
				<xsl:element name="th">Religious Affiliation</xsl:element>
				<xsl:element name="td">
					<xsl:call-template name="getReligion">
						<xsl:with-param name="religion" select="$patientRole/n1:patient/n1:religiousAffiliationCode"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
			<xsl:element name="tr">
				<xsl:element name="th">Race</xsl:element>
				<xsl:element name="td">
					<xsl:call-template name="getRaceCode">
						<xsl:with-param name="raceCode" select="$patientRole/n1:patient/n1:raceCode"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
			<xsl:if test="$patientRole/n1:patient/sdtc:raceCode">
				<xsl:element name="tr">
					<xsl:element name="th">Additional Race(s)</xsl:element>
					<xsl:element name="td">
						<xsl:for-each select="$patientRole/n1:patient/sdtc:raceCode">
							<xsl:call-template name="getRaceCode">
								<xsl:with-param name="raceCode" select="."/>
							</xsl:call-template>
							<xsl:if test="position()!=last()">
								<xsl:element name="br"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:element name="tr">
				<xsl:element name="th">Ethnic Group</xsl:element>
				<xsl:element name="td">
					<xsl:call-template name="getEthnicGroup">
						<xsl:with-param name="ethnicGroup" select="$patientRole/n1:patient/n1:ethnicGroupCode"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
			<xsl:if test="$patientRole/n1:patient/n1:birthplace">
				<xsl:element name="tr">
					<xsl:element name="th">Birth Place</xsl:element>
					<xsl:element name="td">
						<xsl:call-template name="getBirthPlace">
							<xsl:with-param name="birthplace" select="$patientRole/n1:patient/n1:birthplace"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:element name="tr">
				<xsl:element name="th">Preferred Language</xsl:element>
				<xsl:element name="td">
					<xsl:call-template name="getLang">
						<xsl:with-param name="lang" select="$patientRole/n1:patient/n1:languageCommunication/n1:languageCode"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<!-- Author -->
	<xsl:template name="author">
		<xsl:param name="author"/>
		<xsl:element name="h3">
			<xsl:text>Author</xsl:text>
		</xsl:element>
		<xsl:element name="br"/>
		<xsl:element name="table">
			<xsl:if test="$author/n1:representedOrganization">
				<xsl:element name="tr">
					<xsl:element name="th">Organization</xsl:element>
					<xsl:element name="td">
						<xsl:value-of select="$author/n1:representedOrganization/n1:name"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$author/n1:representedOrganization/n1:addr">
				<xsl:element name="tr">
					<xsl:element name="th">Address</xsl:element>
					<xsl:element name="td">
						<xsl:call-template name="getAddress"> 
							<xsl:with-param name="addr" select="$author/n1:representedOrganization/n1:addr"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$author/n1:representedOrganization/n1:telecom">
				<xsl:element name="tr">
					<xsl:element name="th">Phone</xsl:element>
					<xsl:element name="td">
						<xsl:call-template name="getTelecom"> 
							<xsl:with-param name="telecom" select="$author/n1:representedOrganization/n1:telecom"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>

	<!-- participant -->
	<xsl:template match="/n1:ClinicalDocument/n1:participant">
		<xsl:element name="tr">
			<xsl:element name="td">
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
			</xsl:element>
			<xsl:element name="td">
				<xsl:choose>
					<xsl:when test="n1:associatedEntity/n1:code/@nullFlavor">
						<xsl:text>Unavailable</xsl:text>
					</xsl:when>
					<xsl:when test="n1:associatedEntity/n1:code/@displayName">
						<xsl:value-of select="n1:associatedEntity/n1:code/@displayName"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Unavailable</xsl:text>
					</xsl:otherwise>
				</xsl:choose>			   
			</xsl:element>
			<xsl:element name="td">
				<xsl:apply-templates select="n1:associatedEntity/@classCode"/>
			</xsl:element>
			<xsl:element name="td">
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
			</xsl:element>
			<xsl:element name="td">
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
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<!-- performer -->
	<xsl:template match="/n1:ClinicalDocument/n1:documentationOf/n1:serviceEvent/n1:performer">
		<xsl:element name="tr">
			<xsl:element name="td">
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
			</xsl:element>
			<xsl:element name="td">
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
			</xsl:element>
			<xsl:element name="td">
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
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<!-- StructuredBody -->
	<xsl:template match="n1:component/n1:structuredBody">
		<xsl:apply-templates select="n1:component/n1:section"/>
	</xsl:template>

	<!-- Component/Section -->
	<xsl:template match="n1:component/n1:section">
		<xsl:apply-templates select="n1:title"/>
		<xsl:apply-templates select="n1:text"/>
		<xsl:apply-templates select="n1:component/n1:section"/>
	</xsl:template>

	<!-- Filter Blank Component/Section -->
	<xsl:template match="n1:component/n1:section[@nullFlavor='NI']"/>

	<!--   Title  -->
	<xsl:template match="n1:title">
		<xsl:element name="br"/>
		<xsl:element name="h3">
			<xsl:call-template name="mixedCase"> 
				<xsl:with-param name="toconvert">
					<xsl:value-of select="."/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>

	<!--   Text   -->
	<xsl:template match="n1:text">
		<xsl:if test="text()">
			<xsl:element name="br"/>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<!--   paragraph  -->
	<xsl:template match="n1:paragraph">
		<xsl:element name="p">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<!--   break   -->
	<xsl:template match="n1:br">
		<xsl:element name="br"/>
	</xsl:template>

	<!--   content  -->
	<xsl:template match="n1:content">
		<xsl:element name="h4">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<!--   list  -->
	<xsl:template match="n1:list">
		<xsl:element name="ul">
			<xsl:for-each select="n1:item">
				<xsl:element name="li">
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<xsl:template match="n1:list[@listType='ordered']">
		<xsl:element name="ol">
			<xsl:for-each select="n1:item">
				<xsl:element name="li">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<!-- *************************************************************************************************************************
							Tables
****************************************************************************************************************************-->

	<xsl:template match="n1:table">
		<xsl:element name="br"/>
		<xsl:element name="table">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="n1:thead">
		<xsl:element name="thead">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="n1:tbody">
		<xsl:element name="tbody">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="n1:tr">
		<xsl:element name="tr">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="n1:th">
		<xsl:element name="th">
			<xsl:copy-of select="@*[name()='colspan']"/>
			<xsl:value-of select="normalize-space()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="n1:td">
		<xsl:element name="td">
			<xsl:copy-of select="@*[name()='colspan']"/>
			<xsl:value-of select="normalize-space(.)"/>
		</xsl:element>
	</xsl:template>

	<!-- *************************************************************************************************************************
							Styling
****************************************************************************************************************************-->

	<xsl:template match="n1:linkHtml">
		<xsl:element name="a">
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
		</xsl:element>
	</xsl:template>

	<!-- *************************************************************************************************************************
							CDA Value Sets
****************************************************************************************************************************-->

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
				<xsl:text>Polygamous</xsl:text>
			</xsl:when>
			<xsl:when test="$maritalStatus/@code='S'">
				<xsl:text>Never Married</xsl:text>
			</xsl:when>
			<xsl:when test="$maritalStatus/@code='T'">
				<xsl:text>Domestic Partner</xsl:text>
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

	<!-- *************************************************************************************************************************
							Functions
****************************************************************************************************************************-->

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

	<!-- Get a Name -->
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
				<xsl:if test="$name/n1:given[@qualifier='IN']">
					<xsl:text> </xsl:text>
					<xsl:value-of select="$name/n1:given[@qualifier='IN']"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Get Address -->
	<xsl:template name="getAddress">
		<xsl:param name="addr"/>
		<xsl:choose>
			<xsl:when test="$addr/n1:streetAddressLine/@nullFlavor">
				<xsl:text>Unknown</xsl:text>
			</xsl:when>
			<xsl:when test="$addr/n1:streetAddressLine ='' and $addr/n1:city ='' ">
				<xsl:text>Unknown</xsl:text>
			</xsl:when>
			<xsl:when test="$addr/n1:streetAddressLine">
				<xsl:for-each select="$addr/n1:streetAddressLine">
					<xsl:value-of select="current()"/>
					<xsl:element name="br"/>
				</xsl:for-each>
				<xsl:if test="$addr/n1:city or $addr/n1:state or $addr/n1:postalCode">
					<xsl:if test="$addr/n1:city !='' ">
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

	<!-- Get Previous Address -->
	<xsl:template name="getPreviousAddress">
		<xsl:param name="addr"/>
		<xsl:choose>
			<xsl:when test="$addr/n1:streetAddressLine/@nullFlavor">
				<xsl:text>Unknown</xsl:text>
			</xsl:when>
			<xsl:when test="$addr/n1:streetAddressLine ='' and $addr/n1:city ='' ">
				<xsl:text>Unknown</xsl:text>
			</xsl:when>
			<xsl:when test="$addr/n1:streetAddressLine">
				<xsl:for-each select="$addr/n1:streetAddressLine">
					<xsl:value-of select="current()"/>
					<xsl:element name="br"/>
				</xsl:for-each>
				<xsl:if test="$addr/n1:city or $addr/n1:state or $addr/n1:postalCode">
					<xsl:if test="$addr/n1:city !='' ">
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
					<xsl:if test="$addr/n1:useablePeriod/n1:low">
						<xsl:element name="br"/>
						<xsl:text>From: </xsl:text>
						<xsl:call-template name="formatDate">
							<xsl:with-param name="date" select="$addr/n1:useablePeriod/n1:low/@value"/>
						</xsl:call-template>   
					</xsl:if>
					<xsl:if test="$addr/n1:useablePeriod/n1:high">
						<xsl:element name="br"/>
						<xsl:text>To: </xsl:text>
						<xsl:call-template name="formatDate">
							<xsl:with-param name="date" select="$addr/n1:useablePeriod/n1:high/@value"/>
						</xsl:call-template>   
					</xsl:if>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$addr"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Get Telecom -->
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

	<!-- Get Email -->	
	<xsl:template name="getEmail">
		<xsl:param name="email"/>
		<xsl:variable name="emailaddress" select="substring-after(attribute::value,':')"/>
		<xsl:choose>
			<xsl:when test="$emailaddress = '' ">
				<xsl:text>Unknown</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$emailaddress"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Get Birthplace -->
	<xsl:template name="getBirthPlace">
		<xsl:param name="birthplace"/>
		<xsl:choose>
			<xsl:when test="$birthplace/n1:place/n1:addr/n1:state/@nullFlavor and $birthplace/n1:place/n1:addr/n1:city/@nullFlavor and $birthplace/n1:place/n1:addr/n1:country/@nullFlavor">
				<xsl:text>Unknown</xsl:text>
			</xsl:when>
			<xsl:when test="$birthplace/n1:place/n1:addr">
				<xsl:if test="$birthplace/n1:place/n1:addr/n1:city">		   
					<xsl:text>City:</xsl:text>
					<xsl:value-of select="$birthplace/n1:place/n1:addr/n1:city"/>
				</xsl:if>   
				<xsl:if test="$birthplace/n1:place/n1:addr/n1:state"> 
					<br/>
					<xsl:text>State: </xsl:text>
					<xsl:value-of select="$birthplace/n1:place/n1:addr/n1:state"/>
				</xsl:if>
				<xsl:if test="$birthplace/n1:place/n1:addr/n1:country"> 
					<br/>
					<xsl:text>Country: </xsl:text>
					<xsl:value-of select="$birthplace/n1:place/n1:addr/n1:country"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$birthplace"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="mixedCase">
		<xsl:param name="toconvert"/>
		<xsl:choose>
			<xsl:when test="contains($toconvert,' ')">
				<xsl:call-template name="mixedCaseWord">
					<xsl:with-param name="text" select="substring-before($toconvert,' ')"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:call-template name="mixedCase">
					<xsl:with-param name="toconvert" select="substring-after($toconvert,' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="mixedCaseWord">
					<xsl:with-param name="text" select="$toconvert"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="mixedCaseWord">
		<xsl:param name="text"/>
		<xsl:value-of select="translate(substring($text,1,1),$lowercase,$uppercase)"/>
		<xsl:value-of select="translate(substring($text,2,string-length($text)-1),$uppercase,$lowercase)"/>
	</xsl:template>

	<xsl:template match="text()">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>

</xsl:stylesheet>