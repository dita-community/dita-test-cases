<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:local="urn:ns:local-functions"
  exclude-result-prefixes="xs local"
  version="2.0">
  
  <xsl:output name="glossentry" method="xml" indent="yes"
    doctype-public="-//OASIS//DTD DITA Glossary Entry//EN"
    doctype-system="glossentry.dtd"
  />
  
  <xsl:output method="xml"
    indent="yes"
    doctype-public="-//OASIS//DTD DITA Map//EN"
    doctype-system="map.dtd"
  />
  
  <xsl:template match="/">
    <map>
      <title>WIPO Glossary Topics Navigation Map</title>
      <mapref href="glossentries/wipo-glossentries-resource.ditamap"/>
      
      <xsl:apply-templates/>
    </map>
    <xsl:result-document href="glossentries/wipo-glossentries-resource.ditamap">
      <xsl:apply-templates mode="make-resource-map"/>
    </xsl:result-document>
    <xsl:result-document href="glossentries/wipo-glossentries-navigation.ditamap">
      <xsl:apply-templates mode="make-navigation-map"/>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="root">
    <xsl:for-each-group select="*" group-starting-with="h2">
      <xsl:if test="self::h2">
        <xsl:variable name="raw-text" select="string(.)"/>
        <xsl:variable name="term">
          <xsl:analyze-string select="$raw-text" regex="^(.+) \(See:.+$">
            <xsl:matching-substring>
              <xsl:sequence select="regex-group(1)"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
              <xsl:sequence select="."/>
            </xsl:non-matching-substring>
          </xsl:analyze-string>
        </xsl:variable>
        <xsl:message> + [DEBUG]   term="<xsl:value-of select="$term"/>"</xsl:message>
        <xsl:variable name="key" 
          select="local:get-navigation-key($term)"
        />
        <xsl:variable name="target-key" select="local:get-resource-key(.)"/>
        <topicref keys="{$key}" keyref="{$target-key}"/>
        <xsl:variable name="target-uri" select="concat('glossentries/', $key, '.dita')"/>      
        <xsl:result-document href="{$target-uri}"
          format="glossentry"
          >
          <glossentry id="{$key}">
            <glossterm>
              <xsl:value-of select="$term"/>
            </glossterm>
            <xsl:choose>
              <xsl:when test="matches($raw-text, '^(.+) \(See:.+$')">
                <xsl:variable name="target-term" as="xs:string"
                  select="substring-before(substring-after($raw-text, '(See: '), ')')"
                />
                <glossdef>
                  <xsl:variable name="target-h2" as="element()*"
                    select="(//h2[. eq $target-term])[1]"
                  />
                  <xsl:variable name="target-key" as="xs:string?"
                    select="if (exists($target-h2))
                            then local:get-navigation-key($target-term)
                            else ()"
                  />
                  <p>See
                    <xsl:choose>
                      <xsl:when test="exists($target-key)">
                        <term keyref="{$target-key}"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <term><xsl:value-of select="$target-term"/></term>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>.</xsl:text>
                  </p>
                </glossdef>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="def-contents" as="node()*">
                  <xsl:for-each-group select="current-group()[position() gt 1]" group-starting-with="h3">
                    <xsl:choose>
                      <xsl:when test="self::h3">
                        <!-- ignore -->
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:sequence select="current-group()"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each-group>
                </xsl:variable>
                <glossdef>
                  <xsl:apply-templates select="$def-contents"/>
                </glossdef>
                <xsl:choose>
                  <xsl:when test="exists(current-group()/self::h3)">
                    <glossBody>
                      <glossUsage>
                        <xsl:for-each-group select="current-group()" group-starting-with="h3">
                          <xsl:choose>
                            <xsl:when test="self::h3">
                              <div>
                                <xsl:apply-templates select="current-group()"/>
                              </div>
                            </xsl:when>
                            <xsl:otherwise>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:for-each-group>
                      </glossUsage>
                    </glossBody>
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- Ignore -->                   
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </glossentry>
        
        </xsl:result-document>
      </xsl:if>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template match="root" mode="make-resource-map">
    <map>
      <title>WIPO Glossary Resource Map</title>
        <xsl:for-each-group select="*" group-starting-with="p[a/@name[matches(., '^[a-z]$')]]">
          <topicgroup>
            <topicmeta><navtitle><xsl:value-of select="upper-case(a/@name)"/></navtitle></topicmeta>
            <xsl:for-each-group select="current-group()[position() gt 1]" group-starting-with="h2">
              <xsl:variable name="raw-text" select="string(current-group()[1])"/>
              <xsl:variable name="term">
                <xsl:analyze-string select="$raw-text" regex="^(.+) \(See:.+$">
                  <xsl:matching-substring>
                    <xsl:sequence select="regex-group(1)"/>
                  </xsl:matching-substring>
                  <xsl:non-matching-substring>
                    <xsl:sequence select="."/>
                  </xsl:non-matching-substring>
                </xsl:analyze-string>
              </xsl:variable>
              <xsl:variable name="filename-base" 
                select="local:get-navigation-key($term)"
              />
              <xsl:variable name="key" select="local:get-resource-key(.)"/>
              <xsl:variable name="target-uri" select="concat($filename-base, '.dita')"/>
              <keydef keys="{$key}" href="{$target-uri}"/>
            </xsl:for-each-group>
          </topicgroup>
        </xsl:for-each-group>
    </map>
  </xsl:template>
  
  <xsl:template match="root" mode="make-navigation-map">
    <map>
      <title>WIPO Glossary Navigation Map</title>
      <topichead>
        <topicmeta>
          <navtitle>Glossary</navtitle>
        </topicmeta>
        <topicgroup toc="no">
          <xsl:for-each-group select="*" group-starting-with="p[a/@name[matches(., '^[a-z]$')]]">
            <topichead>
              <topicmeta><navtitle><xsl:value-of select="upper-case(a/@name)"/></navtitle></topicmeta>
              <xsl:for-each-group select="current-group()[position() gt 1]" group-starting-with="h2">
                <xsl:variable name="raw-text" select="string(current-group()[1])"/>
                <xsl:variable name="term">
                  <xsl:analyze-string select="$raw-text" regex="^(.+) \(See:.+$">
                    <xsl:matching-substring>
                      <xsl:sequence select="regex-group(1)"/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                      <xsl:sequence select="."/>
                    </xsl:non-matching-substring>
                  </xsl:analyze-string>
                </xsl:variable>
                <xsl:variable name="filename-base" 
                  select="local:get-navigation-key($term)"
                />
                <xsl:variable name="key" select="local:get-navigation-key($term)"/>
                <xsl:variable name="target-uri" select="concat($filename-base, '.dita')"/>
                <topicref keys="{$key}" href="{$target-uri}"/>
              </xsl:for-each-group>
            </topichead>
          </xsl:for-each-group>
        </topicgroup>
      </topichead>
    </map>
  </xsl:template>
  
  <xsl:template match="h3">
    <p><b><xsl:apply-templates/></b></p>
  </xsl:template>
  <xsl:template match="p[matches(., '^\s*$')]">
    <!-- Ignore -->
  </xsl:template>
  
  <xsl:template match="a | br">
    <!-- Ignore -->
  </xsl:template>
  
  <xsl:template match="em">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="*" priority="-1">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:function name="local:get-resource-key" as="xs:string">
    <xsl:param name="context" as="element(h2)"/>
    <xsl:variable name="key" select="concat('gloss_wipo_', format-number(count($context/preceding::h2) + 1, '000'))"/>
    <xsl:sequence select="$key"/>
  </xsl:function>
  
  <xsl:function name="local:get-navigation-key" as="xs:string">
    <xsl:param name="term" as="xs:string"/>
    <xsl:variable name="result"
      select="concat('gloss_', 
         translate(translate(translate(lower-case(normalize-space($term)), ' ', '_'), '/', '-'), '()', ''))"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
</xsl:stylesheet>