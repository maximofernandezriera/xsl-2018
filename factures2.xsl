<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html"/>
    <xsl:template match="celler">
        <html>
            <head>
                <title>Celler</title>
                <link rel="stylesheet" href="celler2.css"/>
            </head>
            <body>
                <!--                <xsl:apply-templates select="productes"/>-->
                <!--                <xsl:apply-templates select="clients"/>-->
                <!--                <xsl:apply-templates select="clients" mode="factures"/>-->
                <xsl:apply-templates select="factures/factura"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="productes">
        <table>
            <tr>
                <td>CODI</td>
                <td>DESCRIPCIO</td>
                <td>PREU</td>
            </tr>
            <xsl:apply-templates select="producte"/>
        </table>
    </xsl:template>
    <xsl:template match="producte">
        <tr>
            <td><xsl:value-of select="@codi"/></td>
            <td><xsl:value-of select="current()"/></td>
            <td><xsl:value-of select="format-number(number(@preu), '#.00 €')"/> €</td>
        </tr>
    </xsl:template>
    <xsl:template match="clients">
        <table>
            <tr>
                <td>CODI</td>
                <td>LLINATGES I NOM</td>
                <td>TELEFONS</td>
            </tr>
            <xsl:apply-templates select="client"/>
        </table>
    </xsl:template>
    <xsl:template match="client">
        <tr>
            <td><xsl:value-of select="@codi"/></td>
            <td>
                <xsl:value-of select="cognoms"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="nom"/>
            </td>
            <td>
                <xsl:for-each select="contacte/telefon">
                    <xsl:value-of select="."/>
                    <xsl:text> . </xsl:text>
                </xsl:for-each>
            </td>
        </tr>

    </xsl:template>
    <xsl:template match="clients" mode="factures">
        <table>
            <tr>
                <td>CLIENT</td>
                <td>FACTURES</td>
            </tr>
            <xsl:apply-templates select="client" mode="factures"/>
        </table>
    </xsl:template>
    <xsl:template match="client" mode="factures">
        <tr>
            <xsl:variable name="codi_client" select="@codi"/>
            <td><xsl:value-of select="$codi_client"/></td>
            <xsl:for-each select="//factura[comprador/@codi = $codi_client]">
                <td><xsl:value-of select="@numero"/></td>
            </xsl:for-each>
        </tr>
    </xsl:template>


    <xsl:template match="factura">
        <table>
            <tr>
                <td>FACTURA</td>
                <td>CLIENT</td>
                <td>NOM</td>
            </tr>
            <tr>
                <td><xsl:value-of select="@numero"/></td>
                <xsl:variable name="codi_client" select="comprador/@codi"/>
                <xsl:variable name="client" select="//client[@codi = $codi_client]"/>
                <td><xsl:value-of select="$client/@codi"/></td>
                <td>
                    <xsl:value-of select="$client/cognoms"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$client/nom"/>
                </td>
            </tr>
            <xsl:for-each select="unitats">
                <tr>
                    <xsl:variable name="codi_producte" select="@codi"/>
                    <td><xsl:value-of select="$codi_producte"/></td>
                    <xsl:variable name="unitats" select="current()"/>
                    <td><xsl:value-of select="$unitats"/></td>
                    <xsl:variable name="producte" select="//producte[@codi = $codi_producte]"/>
                    <td><xsl:value-of select="$producte"/></td>
                    <xsl:variable name="preu" select="$producte/@preu"/>
                    <td><xsl:value-of select="$preu"/> €</td>
                    <td><xsl:value-of select="format-number($unitats * number($preu), '#.00 €')"/></td>
                </tr>
            </xsl:for-each>
            <tr>
                <td>TOTAL:</td>
                <td>
                    <xsl:call-template name="calcular">
                        <xsl:with-param name="llista_compra" select="unitats2"/>
                        <xsl:with-param name="total" select="0"/>
                    </xsl:call-template>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template name="calcular">
        <xsl:param name="llista_compra"/>
        <xsl:param name="total"/>
        <xsl:choose>
            <xsl:when test="$llista_compra">
                <xsl:variable name="unitats" select="$llista_compra[1]/."/>
                <xsl:variable name="codi_producte" select="$llista_compra[1]/@codi"/>
                <xsl:variable name="preu" select="//producte[@codi=$codi_producte]/@preu"/>
                <xsl:call-template name="calcular">
                    <xsl:with-param name="llista_compra" select="$llista_compra[position() > 1]"/>
                    <xsl:with-param name="total" select="$total + $unitats2 * number($preu)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$total + $unitats * number($preu)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>