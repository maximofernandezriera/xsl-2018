<?xml version="1.0"?>

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" />

	<xsl:template match="celler">
		<html>
			<head>
				<title>Celler</title>
				<link rel="stylesheet" href="factures.css" />
			</head>
			<body>
				<xsl:apply-templates select="factures/factura" />
			</body>
		</html>
	</xsl:template>

	<xsl:template match="factura">

		<div class="pagina">
			<span class="numFactura">
				FACTURA
				<xsl:value-of select="@numero" />
			</span>
			<table class="client">
				<xsl:variable name="codi_client"
					select="comprador/@codi" />
				<xsl:variable name="client"
					select="//client[@codi = $codi_client]" />
				<tr>
					<td class="cap">Codi Client:</td>
					<td>
						<xsl:value-of select="$client/@codi" />
					</td>
				</tr>
				<tr>
					<td class="cap">Nom i Llinatges:</td>
					<td>
						<xsl:value-of select="$client/cognoms" />
						<xsl:text>, </xsl:text>
						<xsl:value-of select="$client/nom" />
					</td>
				</tr>
				<tr>
					<td class="cap">Telèfons:</td>
					<td>
					</td>
				</tr>
				<xsl:for-each select="$client/contacte/telefon">
					<tr>
						<td>
							<xsl:value-of select="./@teltipus" />
							<xsl:text>:   </xsl:text>
							<xsl:value-of select="." />
						</td>
						<td>
							<xsl:value-of select="./@telambit" />
							<xsl:text>:   </xsl:text>
							<xsl:value-of select="." />
						</td>
					</tr>
				</xsl:for-each>


			</table>
			<table class="compres">
				<tr>
					<td>CODI PROD.</td>
					<td>UNITATS</td>
					<td>DESCRIPCIÓ</td>
					<td>PREU / UNITAT</td>
					<td>PREU TOTAL PRODUCTE</td>
				</tr>
				<xsl:for-each select="unitats">
					<tr>
						<xsl:variable name="codi_producte" select="@codi" />
						<td>
							<xsl:value-of select="$codi_producte" />
						</td>
						<xsl:variable name="unitats" select="current()" />
						<td>
							<xsl:value-of select="$unitats" />
						</td>
						<xsl:variable name="producte"
							select="//producte[@codi = $codi_producte]" />
						<td>
							<xsl:value-of select="$producte" />
						</td>
						<xsl:variable name="preu" select="$producte/@preu" />
						<td>
							<xsl:value-of select="$preu" />
							€
						</td>
						<td>
							<xsl:value-of
								select="format-number($unitats * number($preu), '#.00 €')" />
						</td>
					</tr>
					<tr>

						<td colspan="4">TOTAL:</td>
						<td>
							<xsl:call-template name="calcular">
								<xsl:with-param name="llista_compra"
									select="unitats" />
								<xsl:with-param name="total" select="0" />
							</xsl:call-template>
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</div>

	</xsl:template>

	<xsl:template name="calcular">
		<xsl:param name="llista_compra" />
		<xsl:param name="total" />
		<xsl:choose>
			<xsl:when test="$llista_compra">
				<xsl:variable name="unitats"
					select="$llista_compra[1]/." />
				<xsl:variable name="codi_producte"
					select="$llista_compra[1]/@codi" />
				<xsl:variable name="preu"
					select="//producte[@codi=$codi_producte]/@preu" />
				<xsl:call-template name="calcular">
					<xsl:with-param name="llista_compra"
						select="$llista_compra[position() > 1]" />
					<xsl:with-param name="total"
						select="$total + $unitats * number($preu)" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number($total, '#.00 €')" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
