<?xml version="1.0"?>
<xsl:stylesheet
		version="1.1"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:b="http://www.fatturapa.gov.it/sdi/fatturapa/v1.1"
		xmlns:c="http://www.fatturapa.gov.it/sdi/fatturapa/v1.0"
		xmlns:a="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2"
		xmlns:d="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.0">
	<xsl:output method="html" />

	<xsl:decimal-format name="euro" decimal-separator="," grouping-separator="."/>

	<xsl:template name="FormatDateIta">
		<xsl:param name="DateTime" />
		<xsl:variable name="year" select="substring($DateTime,1,4)" />
		<xsl:variable name="month" select="substring($DateTime,6,2)" />
		<xsl:variable name="day" select="substring($DateTime,9,2)" />
		<xsl:value-of select="$day" />
		<xsl:value-of select="'-'" />
		<xsl:value-of select="$month" />
		<xsl:value-of select="'-'" />
		<xsl:value-of select="$year" />
	</xsl:template>
	<xsl:template name="FormatIVA">
		<xsl:param name="Natura" />
		<xsl:param name="IVA" />
		<xsl:choose>
			<xsl:when test="$Natura">
				<xsl:value-of select="$Natura" />

			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$IVA">
					<xsl:value-of select="format-number($IVA,  '###.###.##0,00', 'euro')" />
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="FormatSconto">
		<xsl:param name="tipo" />
		<xsl:param name="percentuale" />
		<xsl:param name="importo" />
		<xsl:choose>
			<xsl:when test="$tipo = 'SC' ">
				<xsl:text>-</xsl:text>
			</xsl:when>
			<xsl:when test="$tipo = 'MG'">
				<xsl:text>+</xsl:text>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$percentuale">
				<xsl:value-of select="$percentuale" />
				<xsl:text>%</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$importo">
					<xsl:value-of select="format-number($importo,  '###.###.##0,00', 'euro')" />
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text/>
	</xsl:template>
	<xsl:template name="FormatColSconto">
		<xsl:param name="tipo" />
		<xsl:param name="percentuale" />
		<xsl:param name="importo" />
		<xsl:choose>
			<xsl:when test="$tipo = 'SC' ">
				<xsl:text>-</xsl:text>
			</xsl:when>
			<xsl:when test="$tipo = 'MG'">
				<xsl:text>+</xsl:text>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$percentuale">
				<xsl:value-of select="$percentuale" />
				<xsl:text>%</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$importo">
					<xsl:value-of select="format-number($importo,  '###.###.##0,00', 'euro')" />
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="DettaglioLinee">
		<xsl:param name="r" />
		<xsl:param name="posASWRELSTD" />
		<!--Pre LINEA OpzPreLineaDatiDDT -->
		<xsl:for-each select="OpzPreLineaDatiDDT"  >
			<xsl:call-template name="AltraDescrizioneLinea">
				<xsl:with-param name="textDescrizione" select = "." />
			</xsl:call-template>
		</xsl:for-each>
		<!--Pre LINEA OpzPreLineaDatiOrdineAcquisto  -->
		<xsl:for-each select="OpzPreLineaDatiOrdineAcquisto"  >
			<xsl:call-template name="AltraDescrizioneLinea">
				<xsl:with-param name="textDescrizione" select = "." />
			</xsl:call-template>
		</xsl:for-each>
		<!--Pre LINEA OpzPreLineaDatiContratto  -->
		<xsl:for-each select="OpzPreLineaDatiContratto"  >
			<xsl:call-template name="AltraDescrizioneLinea">
				<xsl:with-param name="textDescrizione" select = "." />
			</xsl:call-template>
		</xsl:for-each>
		<!--Pre LINEA OpzPreLineaDatiFattureCollegate  -->
		<xsl:for-each select="OpzPreLineaDatiFattureCollegate"  >
			<xsl:call-template name="AltraDescrizioneLinea">
				<xsl:with-param name="textDescrizione" select = "." />
			</xsl:call-template>
		</xsl:for-each>
		<!--DETTAGLIO LINEE -->
		<xsl:choose>
			<xsl:when test="$posASWRELSTD = $r">
				<xsl:call-template name="DettaglioLineeASW"/>
			</xsl:when>
			<xsl:otherwise>
				<tr class="trclass-light-gray">
					<td class="textCenter" >
						<xsl:if test="NumeroLinea">
							<span class="tx-xsmall">
								<xsl:value-of select="NumeroLinea" />
							</span>
						</xsl:if>
					</td>
					<td>
						<xsl:for-each select="CodiceArticolo"  >
							<div class="tx-xsmall">
								<xsl:if test="CodiceValore">
									<xsl:text/>
									<xsl:value-of select="CodiceValore" />
								</xsl:if>
								<xsl:if test="CodiceTipo">
									(
									<xsl:value-of select="CodiceTipo" />
									)
								</xsl:if>
							</div>
						</xsl:for-each>
					</td>
					<td>
						<xsl:if test="Descrizione">
							<xsl:value-of select="Descrizione" />
						</xsl:if>
						<xsl:if test="TipoCessionePrestazione">
							(
							<xsl:value-of select="TipoCessionePrestazione" />
							)
						</xsl:if>
						<xsl:for-each select="AltriDatiGestionali"  >
							<xsl:if test=" translate( TipoDato,
								'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
								'abcdefghijklmnopqrstuvwxyz'
								) != 'aswrelstd' 
								and 									
								translate( TipoDato,
								'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
								'abcdefghijklmnopqrstuvwxyz'
								) != 'aswswhouse'  
								and 									
								translate( TipoDato,
								'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
								'abcdefghijklmnopqrstuvwxyz'
								) != 'aswtriga'   ">
								<div class="tx-xsmall">
									<xsl:text>Tipo dato: </xsl:text>
									<xsl:value-of select="TipoDato" />
									<xsl:if test=" translate( TipoDato,
										'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
										'abcdefghijklmnopqrstuvwxyz'
										) = 'aswlottsca' ">
										<xsl:text> (dati relativi a lotti e scadenze) </xsl:text>
									</xsl:if>
								</div>
								<xsl:if test="(RiferimentoTesto or RiferimentoData)">
									<div class="tx-xsmall">
										<span>
											<xsl:choose>
												<xsl:when test=" translate( TipoDato,
													'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
													'abcdefghijklmnopqrstuvwxyz'
													) = 'aswlottsca' ">
													<xsl:text>Lotto: </xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>Rif. testo: </xsl:text>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:value-of select="RiferimentoTesto" />
										</span>
										<xsl:if test="RiferimentoData">
											<span style="margin-left:5px">
												<xsl:choose>
													<xsl:when test=" translate( TipoDato,
														'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
														'abcdefghijklmnopqrstuvwxyz'
														) = 'aswlottsca' ">
														<xsl:text>Scadenza: </xsl:text>
													</xsl:when>
													<xsl:otherwise>
														<xsl:text>Rif. data: </xsl:text>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:call-template name="FormatDateIta">
													<xsl:with-param name="DateTime" select="RiferimentoData" />
												</xsl:call-template>
											</span>
										</xsl:if>
									</div>
								</xsl:if>
								<!--
                           <xsl:if test="RiferimentoData">
                           	<div class="tx-xsmall">
                           		<xsl:choose>
                           			<xsl:when test=" translate( TipoDato,
                                                        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                                                        'abcdefghijklmnopqrstuvwxyz'
                                                       ) = 'aswlottsca' ">
                           
                           				<xsl:text>Scadenza: </xsl:text>
                           			</xsl:when>
                           			<xsl:otherwise>
                           				<xsl:text>Rif. data: </xsl:text>
                           			</xsl:otherwise>
                           		</xsl:choose>
                           
                           		<xsl:call-template name="FormatDateIta">
                           			<xsl:with-param name="DateTime" select="RiferimentoData" />
                           		</xsl:call-template>
                           
                           	</div>
                           </xsl:if>
                           -->
								<xsl:if test="RiferimentoNumero">
									<div class="tx-xsmall">
										<xsl:choose>
											<xsl:when test=" translate( TipoDato,
												'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
												'abcdefghijklmnopqrstuvwxyz'
												) = 'aswlottsca' ">
												<xsl:text>Quantità del suddetto lotto: </xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>Rif. numero: </xsl:text>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:value-of select="format-number(RiferimentoNumero,  '###.###.##0,########', 'euro')" />
									</div>
								</xsl:if>
							</xsl:if>
						</xsl:for-each>
						<xsl:if test="RiferimentoAmministrazione">
							<div class="tx-xsmall">
								RIF.AMM. 
								<xsl:value-of select="RiferimentoAmministrazione" />
							</div>
						</xsl:if>
					</td>
					<td class="import2" >
						<xsl:if test="Quantita">
							<xsl:if test="number(Quantita)">
								<xsl:value-of select="format-number(Quantita,  '###.###.##0,00######', 'euro')" />
							</xsl:if>
						</xsl:if>
					</td>
					<td class="import" >
						<xsl:if test="PrezzoUnitario">
							<xsl:if test="number(PrezzoTotale)">
								<xsl:value-of select="format-number(PrezzoUnitario,  '###.###.##0,00######', 'euro')" />
							</xsl:if>
						</xsl:if>
					</td>
					<td class="textCenter" >
						<xsl:if test="UnitaMisura">
							<xsl:value-of select="UnitaMisura" />
						</xsl:if>
					</td>
					<td class="import" >
						<xsl:for-each select="ScontoMaggiorazione" >
							<div>
								<xsl:call-template name="FormatColSconto" >
									<xsl:with-param name="tipo" select="Tipo" />
									<xsl:with-param name="percentuale" select="Percentuale" />
									<xsl:with-param name="importo" select="Importo" />
								</xsl:call-template>
							</div>
						</xsl:for-each>
					</td>
					<td class="import" >
						<xsl:if test="number(PrezzoTotale)">
							<xsl:call-template name="FormatIVA">
								<xsl:with-param name="Natura" select="Natura" />
								<xsl:with-param name="IVA" select="AliquotaIVA" />
							</xsl:call-template>
						</xsl:if>
					</td>
					<td>
						<xsl:if test="PrezzoTotale">
							<xsl:if test="number(PrezzoTotale)">
								<div class="import">
									<xsl:value-of select="format-number(PrezzoTotale,  '###.###.##0,00######', 'euro')" />
								</div>
							</xsl:if>
							<xsl:if test="OpzPrezzoTotale">
								<div class="tx-xsmall">
									<xsl:value-of select="OpzPrezzoTotale" />
								</div>
							</xsl:if>
						</xsl:if>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
		<!--POST LINEA -->
		<xsl:for-each select="OpzPostLinea"  >
			<xsl:call-template name="AltraDescrizioneLinea">
				<xsl:with-param name="textDescrizione" select = "." />
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="DettaglioLineeASW">
		<tr >
			<td class="textCenter" >
				<xsl:if test="NumeroLinea">
					<span class="tx-xsmall">
						<xsl:value-of select="NumeroLinea" />
					</span>
				</xsl:if>
			</td>
			<td>
			</td>
			<td >
				<xsl:text>------------------------</xsl:text>
				<xsl:for-each select="AltriDatiGestionali"  >
					<xsl:if test=" translate( TipoDato,
						'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
						'abcdefghijklmnopqrstuvwxyz'
						) != 'aswrelstd' 
						and 									
						translate( TipoDato,
						'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
						'abcdefghijklmnopqrstuvwxyz'
						) != 'aswswhouse'   ">
						<div class="tx-xsmall">
							<xsl:value-of select="RiferimentoTesto" />
							<xsl:text/>
							<xsl:value-of select="TipoDato" />
						</div>
					</xsl:if>
				</xsl:for-each>
			</td>
			<td >
			</td>
			<td  >
			</td>
			<td >
			</td>
			<td  >
			</td>
			<td  >
			</td>
			<td  >
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="AltraDescrizioneLinea">
		<xsl:param name = "textDescrizione" />
		<!-- testo della descrizione -->
		<tr>
			<td >
			</td>
			<td >
				<div class="tx-xsmall">
					<xsl:value-of select="$textDescrizione" />
				</div>
			</td>
			<td>
			</td>
			<td>
			</td>
			<td>
			</td>
			<td>
			</td>
			<td>
			</td>
			<td>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="DatiRitenuta">
		<table class="tbFoglio">
			<thead>
				<tr>
					<th class="title"> Dati ritenuta d'acconto</th>
					<th class="perc">Aliquota ritenuta</th>
					<th>Causale	</th>
					<th width="15%">Importo </th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td >
						<xsl:if test="TipoRitenuta">
							<span>
								<xsl:value-of select="TipoRitenuta" />
							</span>
							<xsl:variable name="TR">
								<xsl:value-of select="TipoRitenuta" />
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$TR='RT01'">
									(ritenuta persone fisiche)
								</xsl:when>
								<xsl:when test="$TR='RT02'">
									(ritenuta persone giuridiche)
								</xsl:when>
								<xsl:when test="$TR='RT03'">
									(contributo INPS)
								</xsl:when>
								<xsl:when test="$TR='RT04'">
									(contributo ENASARCO)
								</xsl:when>
								<xsl:when test="$TR='RT05'">
									(contributo ENPAM)
								</xsl:when>
								<xsl:when test="$TR='RT06'">
									(altro contributo previdenziale)
								</xsl:when>
								<xsl:when test="$TR=''">
								</xsl:when>
								<xsl:otherwise>
									<span>(!!! codice non previsto !!!)</span>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</td>
					<td class="import" >
						<xsl:if test="AliquotaRitenuta">
							<xsl:value-of select="format-number(AliquotaRitenuta,  '###.###.##0,00', 'euro')" />
						</xsl:if>
					</td>
					<td >
						<xsl:if test="CausalePagamento">
							<span>
								<xsl:value-of select="CausalePagamento" />
							</span>
							<xsl:variable name="CP">
								<xsl:value-of select="CausalePagamento" />
							</xsl:variable>
							<xsl:if test="$CP!=''">
								(decodifica come da modello 770S)
							</xsl:if>
						</xsl:if>
					</td>
					<td class="import" >
						<xsl:if test="ImportoRitenuta">
							<xsl:value-of select="format-number(ImportoRitenuta,  '###.###.##0,00', 'euro')" />
						</xsl:if>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="FatturaElettronica">
		<xsl:param name="TipoFattura" />
		<xsl:param name="IsFPRS" />
		<xsl:if test="$TipoFattura">
			<!--Variabile che contiene il codice destinatario dall'HEADER perchè viene visualizzato nella sezione BODY -->
			<!--<xsl:variable name="CodiceDestinatario" select="$TipoFattura/FatturaElettronicaHeader/DatiTrasmissione/CodiceDestinatario"/>-->
			<xsl:variable name="PecDestinatario" select="$TipoFattura/FatturaElettronicaHeader/DatiTrasmissione/PECDestinatario"/>
			<!--Variabile che contiene il codice destinatario dall'HEADER perchè viene visualizzato nella sezione BODY -->
			<xsl:variable name="CodiceDestinatario" >
				<xsl:choose>
					<xsl:when test="$TipoFattura/FatturaElettronicaHeader/DatiTrasmissione/CodiceDestinatario='0000000'">
						<xsl:value-of select="$TipoFattura/FatturaElettronicaHeader/DatiTrasmissione/PECDestinatario" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$TipoFattura/FatturaElettronicaHeader/DatiTrasmissione/CodiceDestinatario" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<div id="fattura-elettronica" class="page">
				<!-- FatturaElettronicaHeader -->
				<xsl:if test="$TipoFattura/FatturaElettronicaHeader">
					<table id="tbHeader" style="width:800px">
						<tr >
							<td class="_tdHead">
								<table class="tableHead">
									<tr>
										<td >
											<!--INIZIO CEDENTE PRESTATORE-->
											<div class="headNoBorder" >
												<!--<label class= "headerLabel">Cedente/prestatore (fornitore) </label> -->
												<xsl:for-each select="$TipoFattura/FatturaElettronicaHeader/CedentePrestatore">
													<xsl:choose>
														<xsl:when test="DatiAnagrafici">
															<!--DatiAnagrafici FPA\FPR-->
															<xsl:for-each select="$TipoFattura/FatturaElettronicaHeader/CedentePrestatore/DatiAnagrafici">
																<div class="headContent" >
																	<xsl:if test="Anagrafica/Denominazione">
																		<!--Denominazione:-->
																		<span class="fontbold">
																			<xsl:value-of select="Anagrafica/Denominazione" />
																		</span>
																	</xsl:if>
																</div>
																<div class="headContent" >
																	<xsl:if test="Anagrafica/Nome | Anagrafica/Cognome">
																		<!--Cognome nome:-->
																		<xsl:if test="Anagrafica/Cognome">
																			<span class="fontbold">
																				<xsl:value-of select="Anagrafica/Cognome" />
																				<xsl:text/>
																			</span>
																		</xsl:if>
																		<xsl:if test="Anagrafica/Nome">
																			<span class="fontbold" style="margin-left:5px">
																				<xsl:value-of select="Anagrafica/Nome" />
																			</span>
																		</xsl:if>
																	</xsl:if>
																</div>
															</xsl:for-each>
															<xsl:for-each select="$TipoFattura/FatturaElettronicaHeader/CedentePrestatore/Sede">
																<div class="headContent" >
																	<xsl:if test="Indirizzo">
																		<!--Indirizzo:-->
																		<span>
																			<xsl:value-of select="Indirizzo" />
																			<xsl:text/>
																			<xsl:value-of select="NumeroCivico" />
																		</span>
																	</xsl:if>
																</div>
																<div class="headContent" >
																	<span>

																		<xsl:if test="CAP">
																			<!--Cap:-->
																			<span>
																				<xsl:value-of select="CAP" />
																				<xsl:text> </xsl:text>
																			</span>
																		</xsl:if>
																		<xsl:if test="Comune">
																			<!--Comune:-->
																			<span>
																				<xsl:value-of select="Comune" />
																			</span>
																		</xsl:if>
																		<xsl:if test="Provincia">
																			<!--Provincia:--> (
																			<span>
																				<xsl:value-of select="Provincia" />
																			</span>
																			)
																		</xsl:if>
																		<xsl:if test="Nazione">
																			<!--Nazione:-->-
																			<span>
																				<xsl:value-of select="Nazione" />
																			</span>
																		</xsl:if>
																	</span>
																</div>
															</xsl:for-each>
															<div class="headContent" >
																<xsl:if test="$TipoFattura/FatturaElettronicaHeader/CedentePrestatore/Contatti/Telefono">
																	Telefono:
																	<span>
																		<xsl:value-of select="$TipoFattura/FatturaElettronicaHeader/CedentePrestatore/Contatti/Telefono" />
																	</span>
																</xsl:if>
															</div>
															<div class="headContent mt5" >
																<xsl:if test="$TipoFattura/FatturaElettronicaHeader/CedentePrestatore/Contatti/Email">
																	Email:
																	<span>
																		<xsl:value-of select="$TipoFattura/FatturaElettronicaHeader/CedentePrestatore/Contatti/Email" />
																	</span>
																</xsl:if>
															</div>
															<xsl:for-each select="$TipoFattura/FatturaElettronicaHeader/CedentePrestatore/DatiAnagrafici">
																<div class="headContent">
																	<xsl:if test="IdFiscaleIVA">
																		Identificativo fiscale ai fini IVA:
																		<span>
																			<xsl:value-of select="IdFiscaleIVA/IdPaese" />
																			<xsl:value-of select="IdFiscaleIVA/IdCodice" />
																		</span>
																	</xsl:if>
																</div>
																<div class="headContent" >
																	<xsl:if test="CodiceFiscale">
																		Codice fiscale:
																		<span>
																			<xsl:value-of select="CodiceFiscale" />
																		</span>
																	</xsl:if>
																</div>
																<div class="headContent" >
																	<xsl:if test="RegimeFiscale">
																		Regime fiscale:
																		<span>
																			<xsl:value-of select="RegimeFiscale" />
																		</span>
																		<xsl:variable name="RF">
																			<xsl:value-of select="RegimeFiscale" />
																		</xsl:variable>
																		<xsl:choose>
																			<xsl:when test="$RF='RF01'">
																				(ordinario)
																			</xsl:when>
																			<xsl:when test="$RF='RF02'">
																				(contribuenti minimi)
																			</xsl:when>
																			<xsl:when test="$RF='RF03'">
																				(nuove iniziative produttive)
																			</xsl:when>
																			<xsl:when test="$RF='RF04'">
																				(agricoltura e attività connesse e pesca)
																			</xsl:when>
																			<xsl:when test="$RF='RF05'">
																				(vendita sali e tabacchi)
																			</xsl:when>
																			<xsl:when test="$RF='RF06'">
																				(commercio fiammiferi)
																			</xsl:when>
																			<xsl:when test="$RF='RF07'">
																				(editoria)
																			</xsl:when>
																			<xsl:when test="$RF='RF08'">
																				(gestione servizi telefonia pubblica)
																			</xsl:when>
																			<xsl:when test="$RF='RF09'">
																				(rivendita documenti di trasporto pubblico e di sosta)
																			</xsl:when>
																			<xsl:when test="$RF='RF10'">
																				(intrattenimenti, giochi e altre attività di cui alla tariffa allegata al DPR 640/72)
																			</xsl:when>
																			<xsl:when test="$RF='RF11'">
																				(agenzie viaggi e turismo)
																			</xsl:when>
																			<xsl:when test="$RF='RF12'">
																				(agriturismo)
																			</xsl:when>
																			<xsl:when test="$RF='RF13'">
																				(vendite a domicilio)
																			</xsl:when>
																			<xsl:when test="$RF='RF14'">
																				(rivendita beni usati, oggetti d’arte,
																				d’antiquariato o da collezione)
																			</xsl:when>
																			<xsl:when test="$RF='RF15'">
																				(agenzie di vendite all’asta di oggetti d’arte,
																				antiquariato o da collezione)
																			</xsl:when>
																			<xsl:when test="$RF='RF16'">
																				(IVA per cassa P.A.)
																			</xsl:when>
																			<xsl:when test="$RF='RF17'">
																				(IVA per cassa - art. 32-bis, D.L. 83/2012)
																			</xsl:when>
																			<xsl:when test="$RF='RF19'">
																				(Regime forfettario)
																			</xsl:when>
																			<xsl:when test="$RF='RF18'">
																				(altro)
																			</xsl:when>
																			<xsl:when test="$RF=''">
																			</xsl:when>
																			<xsl:otherwise>
																				<span>(!!! codice non previsto !!!)</span>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:if>
																</div>
															</xsl:for-each>
															<div class="headContent" >
																<xsl:if test="$TipoFattura/FatturaElettronicaHeader/CedentePrestatore/RiferimentoAmministrazione">
																	Riferimento Amministrazione:
																	<span>
																		<xsl:value-of select="$TipoFattura/FatturaElettronicaHeader/CedentePrestatore/RiferimentoAmministrazione" />
																	</span>
																</xsl:if>
															</div>
														</xsl:when>
														<xsl:otherwise>
															<!--Anagrafica FPRS-->

															<xsl:for-each select="$TipoFattura/FatturaElettronicaHeader/CedentePrestatore">
																<div class="headContent" >
																	<xsl:if test="Denominazione">
																		<!--Denominazione:-->
																		<span class="fontbold">
																			<xsl:value-of select="Denominazione" />
																		</span>
																	</xsl:if>
																</div>
																<div class="headContent" >
																	<xsl:if test="Nome | Cognome">
																		<!--Cognome nome:-->
																		<xsl:if test="Cognome">
																			<span class="fontbold">
																				<xsl:value-of select="Cognome" />
																				<xsl:text/>
																			</span>
																		</xsl:if>
																		<xsl:if test="Nome">
																			<span class="fontbold" style="margin-left:5px">
																				<xsl:value-of select="Nome" />
																			</span>
																		</xsl:if>
																	</xsl:if>
																</div>
															</xsl:for-each>

															<xsl:for-each select="$TipoFattura/FatturaElettronicaHeader/CedentePrestatore/Sede">
																<div class="headContent" >
																	<xsl:if test="Indirizzo">
																		<!--Indirizzo:-->
																		<span>
																			<xsl:value-of select="Indirizzo" />
																			<xsl:text/>
																			<xsl:value-of select="NumeroCivico" />
																		</span>
																	</xsl:if>
																</div>
																<div class="headContent" >
																	<span>

																		<xsl:if test="CAP">
																			<!--Cap:-->
																			<span>
																				<xsl:value-of select="CAP" />
																				<xsl:text> </xsl:text>
																			</span>
																		</xsl:if>
																		<xsl:if test="Comune">
																			<!--Comune:-->
																			<span>
																				<xsl:value-of select="Comune" />
																			</span>
																		</xsl:if>
																		<xsl:if test="Provincia">
																			<!--Provincia:--> (
																			<span>
																				<xsl:value-of select="Provincia" />
																			</span>
																			)
																		</xsl:if>
																		<xsl:if test="Nazione">
																			<!--Nazione:-->-
																			<span>
																				<xsl:value-of select="Nazione" />
																			</span>

																		</xsl:if>

																	</span>
																</div>

															</xsl:for-each>


															<div class="headContent mt5">
																<xsl:if test="IdFiscaleIVA">

																	Identificativo fiscale ai fini IVA:
																	<span>
																		<xsl:value-of select="IdFiscaleIVA/IdPaese" />
																		<xsl:value-of select="IdFiscaleIVA/IdCodice" />
																	</span>
																</xsl:if>
															</div>
															<div class="headContent" >
																<xsl:if test="CodiceFiscale">
																	Codice fiscale:
																	<span>
																		<xsl:value-of select="CodiceFiscale" />
																	</span>
																</xsl:if>
															</div>
















															<div class="headContent" >
																<xsl:if test="RegimeFiscale">
																	Regime fiscale:
																	<span>
																		<xsl:value-of select="RegimeFiscale" />
																	</span>
																	<xsl:variable name="RF">
																		<xsl:value-of select="RegimeFiscale" />
																	</xsl:variable>
																	<xsl:choose>
																		<xsl:when test="$RF='RF01'">
																			(ordinario)
																		</xsl:when>
																		<xsl:when test="$RF='RF02'">
																			(contribuenti minimi)
																		</xsl:when>
																		<xsl:when test="$RF='RF03'">
																			(nuove iniziative produttive)
																		</xsl:when>
																		<xsl:when test="$RF='RF04'">
																			(agricoltura e attività connesse e pesca)
																		</xsl:when>
																		<xsl:when test="$RF='RF05'">
																			(vendita sali e tabacchi)
																		</xsl:when>
																		<xsl:when test="$RF='RF06'">
																			(commercio fiammiferi)
																		</xsl:when>
																		<xsl:when test="$RF='RF07'">
																			(editoria)
																		</xsl:when>
																		<xsl:when test="$RF='RF08'">
																			(gestione servizi telefonia pubblica)
																		</xsl:when>
																		<xsl:when test="$RF='RF09'">
																			(rivendita documenti di trasporto pubblico e di sosta)
																		</xsl:when>
																		<xsl:when test="$RF='RF10'">
																			(intrattenimenti, giochi e altre attività di cui alla tariffa allegata al DPR 640/72)
																		</xsl:when>
																		<xsl:when test="$RF='RF11'">
																			(agenzie viaggi e turismo)
																		</xsl:when>
																		<xsl:when test="$RF='RF12'">
																			(agriturismo)
																		</xsl:when>
																		<xsl:when test="$RF='RF13'">
																			(vendite a domicilio)
																		</xsl:when>
																		<xsl:when test="$RF='RF14'">
																			(rivendita beni usati, oggetti d’arte,
																			d’antiquariato o da collezione)
																		</xsl:when>
																		<xsl:when test="$RF='RF15'">
																			(agenzie di vendite all’asta di oggetti d’arte,
																			antiquariato o da collezione)
																		</xsl:when>
																		<xsl:when test="$RF='RF16'">
																			(IVA per cassa P.A.)
																		</xsl:when>
																		<xsl:when test="$RF='RF17'">
																			(IVA per cassa - art. 32-bis, D.L. 83/2012)
																		</xsl:when>
																		<xsl:when test="$RF='RF19'">
																			(Regime forfettario)
																		</xsl:when>
																		<xsl:when test="$RF='RF18'">
																			(altro)
																		</xsl:when>
																		<xsl:when test="$RF=''">
																		</xsl:when>
																		<xsl:otherwise>
																			<span>(!!! codice non previsto !!!)</span>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:if>
															</div>

														</xsl:otherwise>
													</xsl:choose>
												</xsl:for-each>
											</div>
											<!--FINE CEDENTE PRESTATORE-->
										</td>
									</tr>

								</table>

								<!--INIZIO TERZO INTERMEDIARIO-->
								<xsl:if test="$TipoFattura/FatturaElettronicaHeader/TerzoIntermediarioOSoggettoEmittente">

									<table class="tableHead">
										<tr>
											<td >
												<div class="headNoBorder" >
													<span class="fontbold">
														<label  style="margin-left:10px">Dati del terzo intermediario soggetto emittente</label>
													</span>

													<xsl:for-each select="$TipoFattura/FatturaElettronicaHeader/TerzoIntermediarioOSoggettoEmittente">
														<xsl:choose>
															<xsl:when test="DatiAnagrafici">
																<!--DatiAnagrafici FPA\FPR-->
																<xsl:for-each select="DatiAnagrafici">
																	<div class="headContent" >


																		<xsl:if test="Anagrafica/Denominazione">
																			<!--Denominazione:-->
																			<span >
																				<xsl:value-of select="Anagrafica/Denominazione" />
																			</span>
																		</xsl:if>
																	</div>
																	<div class="headContent" >
																		<xsl:if test="Anagrafica/Titolo">
																			<!--Titolo:-->
																			<xsl:value-of select="Anagrafica/Titolo" /> 
																			<xsl:text> </xsl:text>
																		</xsl:if>
																		<xsl:if test="Anagrafica/Nome | Anagrafica/Cognome">
																			<!--Cognome nome:-->
																			<xsl:if test="Anagrafica/Cognome">
																				<xsl:value-of select="Anagrafica/Cognome" />
																			</xsl:if>
																			<xsl:if test="Anagrafica/Nome">
																				<span style="margin-left:5px">
																					<xsl:value-of select="Anagrafica/Nome" />
																				</span>
																			</xsl:if>
																		</xsl:if>
																	</div>

																	<div class="headContent" >
																		<xsl:if test="Anagrafica/CodEORI">
																			<!--CodEORI:-->
																			<span >
																				<xsl:value-of select="Anagrafica/CodEORI" />
																			</span>
																		</xsl:if>
																	</div>
																</xsl:for-each>
																<xsl:for-each select="DatiAnagrafici">
																	<div class="headContent " >

																		<xsl:if test="IdFiscaleIVA">
																			Identificativo fiscale ai fini IVA:
																			<span>
																				<xsl:value-of select="IdFiscaleIVA/IdPaese" />
																				<xsl:value-of select="IdFiscaleIVA/IdCodice" />
																			</span>
																		</xsl:if>
																	</div>
																	<div class="headContent" >
																		<xsl:if test="CodiceFiscale">
																			Codice fiscale:
																			<span>
																				<xsl:value-of select="CodiceFiscale" />
																			</span>
																		</xsl:if>
																	</div>
																</xsl:for-each>
															</xsl:when>

														</xsl:choose>
													</xsl:for-each>

												</div>
											</td>
										</tr>
									</table>

								</xsl:if>
								<!--FINE TERZO INTERMEDIARIO-->

								<!--INIZIO SOGGETTO EMITTENTE-->
								<xsl:if test="$TipoFattura/FatturaElettronicaHeader/SoggettoEmittente">
									<table class="tableHead">
										<tr>
											<td >
												<div class="headNoBorder" >
													<span class="fontbold">
														<label  style="margin-left:10px">Soggetto emittente la fattura</label>
													</span>
													<xsl:variable name="SC">
														<xsl:value-of select="$TipoFattura/FatturaElettronicaHeader/SoggettoEmittente" />
													</xsl:variable>
													<xsl:choose>
														<xsl:when test="$SC='CC'">
															(cessionario/committente)
														</xsl:when>
														<xsl:when test="$SC='TZ'">
															(terzo)
														</xsl:when>
														<xsl:when test="$SC=''">
														</xsl:when>
														<xsl:otherwise>
															<span>(!!! codice non previsto !!!)</span>
														</xsl:otherwise>
													</xsl:choose>
												</div>
											</td>
										</tr>
									</table>

								</xsl:if>
								<!--FINE SOGGETTO EMITTENTE-->
							</td>
							<td class="tdHead">
								<table class="tableHead">
									<tr>
										<td >
											<!--INIZIO CESSIONARIO COMMITTENTE-->
											<div class="headBorder" >
												<label  style="margin-left:10px"  >Spett.le</label>
												<xsl:for-each select="$TipoFattura/FatturaElettronicaHeader/CessionarioCommittente">
													<xsl:choose>
														<xsl:when test="DatiAnagrafici">
															<!--DatiAnagrafici FPA\FPR-->
															<xsl:for-each select="DatiAnagrafici">
																<div class="headContent" >
																	<xsl:if test="Anagrafica/Denominazione">
																		<!--Denominazione:-->
																		<span class="fontbold">
																			<xsl:value-of select="Anagrafica/Denominazione" />
																		</span>
																	</xsl:if>
																</div>
																<div class="headContent" >
																	<xsl:if test="Anagrafica/Nome | Anagrafica/Cognome">
																		<!--Cognome nome:-->
																		<xsl:if test="Anagrafica/Cognome">
																			<span class="fontbold">
																				<xsl:value-of select="Anagrafica/Cognome" />
																				<xsl:text/>
																			</span>
																		</xsl:if>
																		<xsl:if test="Anagrafica/Nome">
																			<span class="fontbold" style="margin-left:5px">
																				<xsl:value-of select="Anagrafica/Nome" />
																			</span>
																		</xsl:if>
																	</xsl:if>
																</div>
															</xsl:for-each>
															<xsl:for-each select="Sede">
																<div class="headContent" >
																	<xsl:if test="Indirizzo">
																		<!--Indirizzo:-->
																		<span>
																			<xsl:value-of select="Indirizzo" />
																			<xsl:text/>
																			<xsl:value-of select="NumeroCivico" />
																		</span>
																	</xsl:if>
																</div>
																<div class="headContent" >
																	<span>
																		<xsl:if test="CAP">
																			<!--Cap:-->
																			<span>
																				<xsl:value-of select="CAP" />
																				<xsl:text> </xsl:text>
																			</span>

																		</xsl:if>
																		<xsl:if test="Comune">
																			<!--Comune:-->
																			<span>
																				<xsl:value-of select="Comune" />
																			</span>
																		</xsl:if>
																		<xsl:if test="Provincia">
																			<!--Provincia:-->  (
																			<span>
																				<xsl:value-of select="Provincia" />
																			</span>
																			)
																		</xsl:if>










																		<xsl:if test="Nazione">
																			<!--Nazione:--> - 
																			<span>
																				<xsl:value-of select="Nazione" />
																			</span>
																		</xsl:if>
																	</span>
																</div>

																<div class="headContent mt5" >
																	<xsl:if test="$PecDestinatario">
																		Pec: 
																		<span>
																			<xsl:value-of select="$PecDestinatario" />
																		</span>
																	</xsl:if>
																</div>
															</xsl:for-each>
															<xsl:for-each select="DatiAnagrafici">
																<div class="headContent " >
																	<xsl:if test="IdFiscaleIVA">
																		Identificativo fiscale ai fini IVA:
																		<span>
																			<xsl:value-of select="IdFiscaleIVA/IdPaese" />
																			<xsl:value-of select="IdFiscaleIVA/IdCodice" />
																		</span>
																	</xsl:if>
																</div>
																<div class="headContent" >
																	<xsl:if test="CodiceFiscale">
																		Codice fiscale:
																		<span>
																			<xsl:value-of select="CodiceFiscale" />
																		</span>
																	</xsl:if>
																</div>
															</xsl:for-each>
														</xsl:when>
														<xsl:otherwise>
															<!-- FATTURA SEMPLIFICATA  -->
															<!--Anagrafica FPRS-->



















															<xsl:for-each select="$TipoFattura/FatturaElettronicaHeader/CessionarioCommittente/AltriDatiIdentificativi">
																<div class="headContent" >
																	<xsl:if test="Denominazione">
																		<span class="fontbold">

																			<xsl:value-of select="Denominazione" />
																		</span>
																	</xsl:if>
																</div>
																<div class="headContent" >
																	<xsl:if test="Nome | Cognome">
																		<!--Cognome nome:-->
																		<xsl:if test="Cognome">
																			<span class="fontbold">
																				<xsl:value-of select="Cognome" />
																				<xsl:text/>
																			</span>
																		</xsl:if>
																		<xsl:if test="Nome">
																			<span class="fontbold" style="margin-left:5px">
																				<xsl:value-of select="Nome" />
																			</span>
																		</xsl:if>
																	</xsl:if>
																</div>
																<xsl:for-each select="$TipoFattura/FatturaElettronicaHeader/CessionarioCommittente/AltriDatiIdentificativi/Sede">
																	<div class="headContent" >
																		<xsl:if test="Indirizzo">
																			<!--Indirizzo:-->
																			<span>
																				<xsl:value-of select="Indirizzo" />
																				<xsl:text/>
																				<xsl:value-of select="NumeroCivico" />
																			</span>
																		</xsl:if>
																	</div>
																	<div class="headContent" >
																		<span>
																			<xsl:if test="CAP">
																				<!--Cap:-->
																				<span>
																					<xsl:value-of select="CAP" />
																					<xsl:text> </xsl:text>
																				</span>

																			</xsl:if>
																			<xsl:if test="Comune">
																				<!--Comune:-->
																				<span>
																					<xsl:value-of select="Comune" />
																				</span>
																			</xsl:if>
																			<xsl:if test="Provincia">
																				<!--Provincia:-->  (
																				<span>
																					<xsl:value-of select="Provincia" />
																				</span>
																				)










																			</xsl:if>
																			<xsl:if test="Nazione">
																				<!--Nazione:--> - 
																				<span>
																					<xsl:value-of select="Nazione" />
																				</span>
																			</xsl:if>
																		</span>
																	</div>

																	<div class="headContent" >
																		<xsl:if test="$PecDestinatario">
																			Pec: 
																			<span>
																				<xsl:value-of select="$PecDestinatario" />
																			</span>
																		</xsl:if>
																	</div>
																</xsl:for-each>
															</xsl:for-each>
															<xsl:for-each select="$TipoFattura/FatturaElettronicaHeader/CessionarioCommittente/IdentificativiFiscali">
																<div class="headContent mt5" >
																	<xsl:if test="IdFiscaleIVA">
																		Identificativo fiscale ai fini IVA:
																		<span class="fontbold">
																			<xsl:value-of select="IdFiscaleIVA/IdPaese" />
																			<xsl:value-of select="IdFiscaleIVA/IdCodice" />
																		</span>
																	</xsl:if>
																</div>
																<div class="headContent" >
																	<xsl:if test="CodiceFiscale">
																		Codice fiscale:
																		<span class="fontbold">
																			<xsl:value-of select="CodiceFiscale" />
																		</span>
																	</xsl:if>
																</div>
															</xsl:for-each>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:for-each>

											</div>
											<!--FINE CESSIONARIO COMMITTENTE-->
										</td>
									</tr>

									<!--INIZIO INDIRZZO RESA-->
									<xsl:if test="$TipoFattura/FatturaElettronicaBody/DatiGenerali/DatiTrasporto/IndirizzoResa">

										<table class="tableHead">
											<tr>
												<td >
													<div class="headBorder" >
														<span class="fontbold">
															<label  style="margin-left:10px">Dati relativi al trasporto</label>
														</span>
														<xsl:for-each select="$TipoFattura/FatturaElettronicaBody/DatiGenerali/DatiTrasporto/IndirizzoResa">

															<div class="headContent" >
																<xsl:if test="Indirizzo">
																	<!-- Indirizzo: -->
																	<span>
																		<xsl:value-of select="Indirizzo" />
																		<xsl:text/>
																		<xsl:value-of select="NumeroCivico" />
																	</span>
																</xsl:if>
															</div>
															<div class="headContent" >
																<xsl:if test="CAP">
																	<!--  Cap: -->
																	<span>
																		<xsl:value-of select="CAP" />
																		<xsl:text> </xsl:text>
																	</span>
																</xsl:if>
																<xsl:if test="Comune">
																	<!--Comune:-->
																	<span>
																		<xsl:value-of select="Comune" />
																	</span>
																</xsl:if>
																<xsl:if test="Provincia">
																	<!--Provincia:-->  (
																	<span>
																		<xsl:value-of select="Provincia" />
																	</span>
																	)
																</xsl:if>
																<xsl:if test="Nazione">
																	-
																	<span>
																		<xsl:value-of select="Nazione" />
																	</span>
																</xsl:if>
															</div>
														</xsl:for-each>
													</div>

												</td>
											</tr>
										</table>

									</xsl:if>
									<!--FINE INDIRZZO RESA-->


								</table>
							</td>

						</tr>
					</table>
				</xsl:if>
				<div style="height:10px" />
				<!-- FINE FatturaElettronicaHeader -->
				<!--INIZIO BODY-->

				<xsl:variable name="TOTALBODY">
					<xsl:value-of select="count(a:FatturaElettronica/FatturaElettronicaBody)" />
				</xsl:variable>

				<xsl:if test="$TOTALBODY>1">
					<h3 style="text-align: center; width: 800px;">LOTTO FATTURE</h3>
				</xsl:if>

				<xsl:for-each select="$TipoFattura/FatturaElettronicaBody" >

					<xsl:if test="$TOTALBODY>1">

						<xsl:variable name="NUMEROLOTTO">
							<xsl:value-of select="position()" /> 
						</xsl:variable>
						<xsl:if test="$NUMEROLOTTO>1">
							<br/>
						</xsl:if>

						<h3>
							<xsl:if test="DatiGenerali/DatiGeneraliDocumento/Numero">
								Numero documento : <xsl:value-of select="DatiGenerali/DatiGeneraliDocumento/Numero" />
							</xsl:if>
							(lotto: <xsl:value-of select="position()" />)

						</h3>
					</xsl:if>


					<!-- Conforme Standard AssoSoftware se altridatigestionali presenta ASWRELSTD   -->
					<xsl:variable name="posASWRELSTD" >
						<xsl:for-each select="DatiBeniServizi/DettaglioLinee">
							<xsl:variable name="DettaglioLinee" select="."/>
							<xsl:variable name="posDettaglioLinee" select="position()"/>
							<xsl:for-each select="AltriDatiGestionali">
								<xsl:if test=" translate( TipoDato,
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
									'abcdefghijklmnopqrstuvwxyz'
									) = 'aswrelstd'">
									<xsl:value-of select="number($posDettaglioLinee)"/>
								</xsl:if>
							</xsl:for-each>
						</xsl:for-each>
					</xsl:variable>
					<!-- FINE conforme AssoSoftware -->
					<table class="tbFoglio">
						<!-- TIPOLOGIA DOCUMENTO TESTATA-->
						<thead>
							<tr>
								<th>Tipologia documento</th>
								<th class="perc">Art. 73</th>
								<th >Numero documento</th>
								<th class="data">Data documento</th>
								<th >Codice destinatario</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
									<xsl:if test="DatiGenerali/DatiGeneraliDocumento/TipoDocumento">
										<xsl:value-of select="DatiGenerali/DatiGeneraliDocumento/TipoDocumento" />
										<xsl:variable name="TD">
											<xsl:value-of select="DatiGenerali/DatiGeneraliDocumento/TipoDocumento" />
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="$TD='TD01'">
												<b>(fattura)</b>
											</xsl:when>
											<xsl:when test="$TD='TD02'">
												<b>(acconto/anticipo su fattura)</b>
											</xsl:when>
											<xsl:when test="$TD='TD03'">
												<b>(acconto/anticipo su parcella)</b>
											</xsl:when>
											<xsl:when test="$TD='TD04'">
												<span style="color:red">
													<b> (nota di credito)</b>
												</span>
											</xsl:when>
											<xsl:when test="$TD='TD05'">
												<b>(nota di debito)</b>
											</xsl:when>
											<xsl:when test="$TD='TD06'">
												<b>(parcella)</b>
											</xsl:when>
											<xsl:when test="$TD='TD16'">
												<b>(integrazione fattura reverse charge interno)</b>
											</xsl:when>
											<xsl:when test="$TD='TD17'">
												<b>(integrazione/autofattura per acquisto servizi dall'estero)</b>
											</xsl:when>
											<xsl:when test="$TD='TD18'">
												<b>(integrazione per acquisto di beni intracomunitari)</b>
											</xsl:when>
											<xsl:when test="$TD='TD19'">
												<b>(integrazione/autofattura per acquisto di beni ex art.17 c.2 DPR 633/72)</b>
											</xsl:when>
											<xsl:when test="$TD='TD20'">
												<b>(autofattura per regolarizzazione e integrazione delle fatture (ex art.6 c.8 d.lgs. 471/97  o  art.46 c.5 D.L. 331/93))</b>
											</xsl:when>
											<xsl:when test="$TD='TD21'">
												<b>(autofattura per splafonamento)</b>
											</xsl:when>
											<xsl:when test="$TD='TD22'">
												<b>(estrazione beni da Deposito IVA)</b>
											</xsl:when>
											<xsl:when test="$TD='TD23'">
												<b>(estrazione beni da Deposito IVA con versamento dell'IVA)</b>
											</xsl:when>
											<xsl:when test="$TD='TD24'">
												<b>(fattura differita di cui all'art. 21, comma 4, lett. a)</b>
											</xsl:when>
											<xsl:when test="$TD='TD25'">
												<b>(fattura differita di cui all'art. 21, comma 4, terzo periodo lett. b)</b>
											</xsl:when>
											<xsl:when test="$TD='TD26'">
												<b>(cessione di beni ammortizzabili e per passaggi interni (ex art.36 DPR 633/72))</b>
											</xsl:when>
											<xsl:when test="$TD='TD27'">
												<b>(fattura per autoconsumo o per cessioni gratuite senza rivalsa)</b>
											</xsl:when>
											<!--FPRS-->
											<xsl:when test="$TD='TD07'">
												<b>(fattura semplificata)</b>
											</xsl:when>
											<xsl:when test="$TD='TD08'">
												<b>(nota di credito semplificata)</b>
											</xsl:when>
											<xsl:when test="$TD='TD09'">
												<b>(nota di debito semplificata)</b>
											</xsl:when>
											<xsl:when test="$TD=''">
											</xsl:when>
											<xsl:otherwise>
												<span>(!!! codice non previsto !!!)</span>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</td>
								<td class="ritenuta"  >
									<xsl:if test="DatiGenerali/DatiGeneraliDocumento/Art73">
										<xsl:value-of select="DatiGenerali/DatiGeneraliDocumento/Art73" />
									</xsl:if>
								</td>
								<td class="textCenter" >
									<xsl:if test="DatiGenerali/DatiGeneraliDocumento/Numero">
										<xsl:value-of select="DatiGenerali/DatiGeneraliDocumento/Numero" />
									</xsl:if>
								</td>
								<td class="data" >
									<xsl:if test="DatiGenerali/DatiGeneraliDocumento/Data">
										<xsl:call-template name="FormatDateIta">
											<xsl:with-param name="DateTime" select="DatiGenerali/DatiGeneraliDocumento/Data" />
										</xsl:call-template>
									</xsl:if>
								</td>
								<td class="textCenter" >
									<xsl:choose>
										<xsl:when test="$PecDestinatario">
											Indicata PEC
										</xsl:when>
										<xsl:otherwise>
											<xsl:if test="$CodiceDestinatario">
												<xsl:value-of select="$CodiceDestinatario" />
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<!--FINE TIPOLOGIA Documento TESTATA-->
						</tbody>
					</table>


					<xsl:if test="DatiGenerali/DatiOrdineAcquisto/IdDocumento">
						<table class="tbTitolo nomargintop">
							<thead>
								<tr>
									<th>RIFERIMENTI ORDINI DI ACQUISTO</th>
								</tr>
							</thead>
						</table>
						<!-- <div class="separa"/> -->
						<table class="tbFoglio nomargintop">
							<!-- ELENCO ORDINI DI ACQUISTO-->
							<thead>
								<tr>
									<th width="100px">N° Ordine</th>
									<th class="data">Data ordine</th>
									<th>Numero linea di fattura a cui si riferisce</th>
									<th width="40px">N° Linea ordine</th>
									<th>Codice Identificativo Gara (CIG)</th>
									<th>Codice Unitario Progetto (CUP)</th>
									<th>Codice commessa/convenzione</th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each select="DatiGenerali/DatiOrdineAcquisto">
									<tr class="trclass">
										<td >
											<div class="tx-small middle">
												<xsl:value-of select="IdDocumento" />
											</div>
										</td>
										<td class="data" >
											<div class="tx-small">
												<xsl:call-template name="FormatDateIta">
													<xsl:with-param name="DateTime" select="Data" />
												</xsl:call-template>
											</div>
										</td>
										<td >
											<div class="tx-xsmall">
												<xsl:for-each select="RiferimentoNumeroLinea">
													<span>
														<xsl:if test="(position( )) > 1">
															,
														</xsl:if>
														<xsl:value-of select="." />
													</span>
												</xsl:for-each>
											</div>
										</td>
										<td >
											<div class="tx-xsmall middle">
												<xsl:value-of select="NumItem" />
											</div>
										</td>
										<td >
											<div class="tx-xsmall middle">
												<xsl:value-of select="CodiceCIG" />
											</div>
										</td>
										<td >
											<div class="tx-xsmall middle">
												<xsl:value-of select="CodiceCUP" />
											</div>
										</td>
										<td >
											<div class="tx-xsmall middle">
												<xsl:value-of select="CodiceCommessaConvenzione" />
											</div>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</xsl:if>

					<xsl:if test="DatiGenerali/DatiContratto/IdDocumento">
						<table class="tbTitolo nomargintop">
							<thead>
								<tr>
									<th>RIFERIMENTI CONTRATTI</th>
								</tr>
							</thead>
						</table>
						<!-- <div class="separa"/> -->
						<table class="tbFoglio nomargintop">
							<!-- ELENCO CONTRATTI-->
							<thead>
								<tr>
									<th width="100px">N° Contratto</th>
									<th class="data">Data contratto</th>
									<th>Numero linea di fattura a cui si riferisce</th>
									<th width="40px">N° Linea contratto</th>
									<th>Codice Identificativo Gara (CIG)</th>
									<th>Codice Unitario Progetto (CUP)</th>
									<th>Codice commessa/convenzione</th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each select="DatiGenerali/DatiContratto">
									<tr class="trclass">
										<td >
											<div class="tx-small middle">
												<xsl:value-of select="IdDocumento" />
											</div>
										</td>
										<td class="data" >
											<div class="tx-small">
												<xsl:call-template name="FormatDateIta">
													<xsl:with-param name="DateTime" select="Data" />
												</xsl:call-template>
											</div>
										</td>
										<td >
											<div class="tx-xsmall">
												<xsl:for-each select="RiferimentoNumeroLinea">
													<span>
														<xsl:if test="(position( )) > 1">
															,
														</xsl:if>
														<xsl:value-of select="." />
													</span>
												</xsl:for-each>
											</div>
										</td>
										<td >
											<div class="tx-xsmall middle">
												<xsl:value-of select="NumItem" />
											</div>
										</td>
										<td >
											<div class="tx-xsmall middle">
												<xsl:value-of select="CodiceCIG" />
											</div>
										</td>
										<td >
											<div class="tx-xsmall middle">
												<xsl:value-of select="CodiceCUP" />
											</div>
										</td>
										<td >
											<div class="tx-xsmall middle">
												<xsl:value-of select="CodiceCommessaConvenzione" />
											</div>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</xsl:if>

					<xsl:if test="DatiGenerali/DatiDDT">
						<div class="separa"/>
						<table class="tbFoglio ">
							<!-- ELENCO DDT-->
							<thead>
								<tr>
									<th width="80px">Numero DDT</th>
									<th class="data">Data documento</th>
									<th>Numero linea di fattura a cui si riferisce</th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each select="DatiGenerali/DatiDDT">
									<tr class="trclass">
										<td >
											<div class="tx-small middle">
												<xsl:value-of select="NumeroDDT" />
											</div>
										</td>
										<td class="data" >
											<div class="tx-small">
												<xsl:call-template name="FormatDateIta">
													<xsl:with-param name="DateTime" select="DataDDT" />
												</xsl:call-template>
											</div>
										</td>
										<td >
											<div class="tx-xsmall">
												<xsl:for-each select="RiferimentoNumeroLinea">
													<span>
														<xsl:if test="(position( )) > 1">
															,
														</xsl:if>
														<xsl:value-of select="." />
													</span>
												</xsl:for-each>
											</div>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</xsl:if>
					<xsl:if test="DatiGenerali/DatiGeneraliDocumento/Causale">
						<div class="separa"/>
						<table class="tbFoglio">
							<!-- TIPOLOGIA DOCUMENTO TESTATA - parte causale-->
							<thead>
								<tr>
									<th>Causale</th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each select="DatiGenerali/DatiGeneraliDocumento/Causale">
									<tr>
										<td >
											<!-- <xsl:if test="DatiGenerali/DatiGeneraliDocumento/Causale"> -->
											<!-- <xsl:for-each select="DatiGenerali/DatiGeneraliDocumento/Causale"  > -->
											<xsl:value-of select="." />
											<!-- </xsl:for-each> --> 
											<!-- </xsl:if> -->
										</td>
									</tr>
								</xsl:for-each>
								<!--FINE TIPOLOGIA Documento TESTATA - parte causale -->
							</tbody>
						</table>
					</xsl:if>


					<xsl:if test="DatiGenerali/DatiFatturaRettificata"  >
						<table class="tbTitolo nomargintop">
							<thead>
								<tr>
									<th>Dati Fattura Rettificata</th>
								</tr>
							</thead>
						</table>
						<table class="tbFoglio nomargintop" >

							<thead>
								<tr>
									<th width="204px">Numero fattura rettificata</th>
									<th class="data">Data fattura rettificata</th>
									<th>Elementi oggetto di rettifica</th>

								</tr>
							</thead>
							<tbody>
								<xsl:for-each select="DatiGenerali/DatiFatturaRettificata">
									<tr>
										<td >
											<div class="tx-small small">
												<xsl:value-of select="NumeroFR" />
											</div>
										</td>
										<td class="data" >
											<div class="tx-small">
												<xsl:call-template name="FormatDateIta">
													<xsl:with-param name="DateTime" select="DataFR" />
												</xsl:call-template>
											</div>
										</td>

										<td >
											<div class="tx-small middle">
												<xsl:value-of select="ElementiRettificati" />
											</div>
										</td>

									</tr>

								</xsl:for-each>
							</tbody>
						</table>
					</xsl:if>






					<div class="separa"/>
					<xsl:choose>
						<xsl:when test="$IsFPRS='1'">
							<!--  Dettaglio Linee   -->
							<table class="tbFoglio"  >
								<thead>
									<tr>
										<th>Descrizione</th>
										<th class="perc">Imposta</th>
										<th class="perc2">%IVA</th>
										<th class="ximport">Prezzo totale</th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="DatiBeniServizi" >
										<tr>
											<td>
												<xsl:if test="Descrizione">
													<xsl:value-of select="Descrizione" />
												</xsl:if>
												<xsl:if test="RiferimentoNormativo">
													<div class="tx-xsmall">
														RIF.NORM. 
														<xsl:value-of select="RiferimentoNormativo" />
													</div>
												</xsl:if>
											</td>
											<td class="import" >
												<xsl:if test="DatiIVA/Imposta">
													<xsl:value-of select="format-number(DatiIVA/Imposta,  '###.###.##0,00', 'euro')" />
												</xsl:if>
											</td>
											<td class="import" >
												<xsl:call-template name="FormatIVA">
													<xsl:with-param name="Natura" select="Natura" />
													<xsl:with-param name="IVA" select="DatiIVA/Aliquota" />
												</xsl:call-template>
											</td>
											<td class="import" >
												<xsl:if test="Importo">
													<xsl:value-of select="format-number(Importo,  '###.###.##0,00', 'euro')" />
												</xsl:if>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</xsl:when>
						<xsl:otherwise>
							<!--  Dettaglio Linee   -->
							<table class="tbFoglio"  >
								<thead>
									<tr>
										<th width="20px">N°</th>
										<th width="80px">Cod. articolo</th>
										<th>Descrizione</th>
										<th class="import2" >Quantità</th>
										<th class="import2">Prezzo unitario</th>
										<th class="perc2">UM</th>
										<th class="perc">Sconto o magg.</th>
										<th class="perc2">%IVA</th>
										<th class="ximport">Prezzo totale</th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="DatiBeniServizi/DettaglioLinee" >
										<xsl:apply-templates select=".">
											<xsl:with-param name="r" select="position()"/>
											<xsl:with-param name="posASWRELSTD" select="$posASWRELSTD"/>
										</xsl:apply-templates>
									</xsl:for-each>
								</tbody>
							</table>
							<!--   Dati Cassa Prevvidenziale    -->
							<xsl:if test="DatiGenerali/DatiGeneraliDocumento/DatiCassaPrevidenziale">
								<div class="separa"/>
								<table class="tbFoglio">
									<thead>
										<tr>
											<th class="title">Dati Cassa Previdenziale</th>
											<th>Imponibile</th>
											<th class="perc">%Contr.</th>
											<th class="perc">Ritenuta</th>
											<th class="perc">%IVA</th>
											<th >Importo</th>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each select="DatiGenerali/DatiGeneraliDocumento/DatiCassaPrevidenziale"  >
											<tr>
												<td>
													<xsl:if test="TipoCassa">
														<span>
															<xsl:value-of select="TipoCassa" />
														</span>
														<xsl:variable name="TC">
															<xsl:value-of select="TipoCassa" />
														</xsl:variable>
														<xsl:choose>
															<xsl:when test="$TC='TC01'">
																(Cassa Nazionale Previdenza e Assistenza Avvocati
																e Procuratori legali)
															</xsl:when>
															<xsl:when test="$TC='TC02'">
																(Cassa Previdenza Dottori Commercialisti)
															</xsl:when>
															<xsl:when test="$TC='TC03'">
																(Cassa Previdenza e Assistenza Geometri)
															</xsl:when>
															<xsl:when test="$TC='TC04'">
																(Cassa Nazionale Previdenza e Assistenza
																Ingegneri e Architetti liberi profess.)
															</xsl:when>
															<xsl:when test="$TC='TC05'">
																(Cassa Nazionale del Notariato)
															</xsl:when>
															<xsl:when test="$TC='TC06'">
																(Cassa Nazionale Previdenza e Assistenza
																Ragionieri e Periti commerciali)
															</xsl:when>
															<xsl:when test="$TC='TC07'">
																(Ente Nazionale Assistenza Agenti e Rappresentanti
																di Commercio-ENASARCO)
															</xsl:when>
															<xsl:when test="$TC='TC08'">
																(Ente Nazionale Previdenza e Assistenza Consulenti
																del Lavoro-ENPACL)
															</xsl:when>
															<xsl:when test="$TC='TC09'">
																(Ente Nazionale Previdenza e Assistenza
																Medici-ENPAM)
															</xsl:when>
															<xsl:when test="$TC='TC10'">
																(Ente Nazionale Previdenza e Assistenza
																Farmacisti-ENPAF)
															</xsl:when>
															<xsl:when test="$TC='TC11'">
																(Ente Nazionale Previdenza e Assistenza
																Veterinari-ENPAV)
															</xsl:when>
															<xsl:when test="$TC='TC12'">
																(Ente Nazionale Previdenza e Assistenza Impiegati
																dell'Agricoltura-ENPAIA)
															</xsl:when>
															<xsl:when test="$TC='TC13'">
																(Fondo Previdenza Impiegati Imprese di Spedizione
																e Agenzie Marittime)
															</xsl:when>
															<xsl:when test="$TC='TC14'">
																(Istituto Nazionale Previdenza Giornalisti
																Italiani-INPGI)
															</xsl:when>
															<xsl:when test="$TC='TC15'">
																(Opera Nazionale Assistenza Orfani Sanitari
																Italiani-ONAOSI)
															</xsl:when>
															<xsl:when test="$TC='TC16'">
																(Cassa Autonoma Assistenza Integrativa
																Giornalisti Italiani-CASAGIT)
															</xsl:when>
															<xsl:when test="$TC='TC17'">
																(Ente Previdenza Periti Industriali e Periti
																Industriali Laureati-EPPI)
															</xsl:when>
															<xsl:when test="$TC='TC18'">
																(Ente Previdenza e Assistenza
																Pluricategoriale-EPAP)
															</xsl:when>
															<xsl:when test="$TC='TC19'">
																(Ente Nazionale Previdenza e Assistenza
																Biologi-ENPAB)
															</xsl:when>
															<xsl:when test="$TC='TC20'">
																(Ente Nazionale Previdenza e Assistenza
																Professione Infermieristica-ENPAPI)
															</xsl:when>
															<xsl:when test="$TC='TC21'">
																(Ente Nazionale Previdenza e Assistenza
																Psicologi-ENPAP)
															</xsl:when>
															<xsl:when test="$TC='TC22'">
																(INPS)
															</xsl:when>
															<xsl:when test="$TC=''">
															</xsl:when>
															<xsl:otherwise>
																<span>(!!! codice non previsto !!!)</span>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:if>
												</td>
												<td class="import">
													<xsl:if test="ImponibileCassa">
														<xsl:value-of select="format-number(ImponibileCassa,  '###.###.##0,00', 'euro')" />
													</xsl:if>
												</td>
												<td class="import">
													<xsl:if test="AlCassa">
														<xsl:value-of select="format-number(AlCassa,  '###.###.##0,00', 'euro')" />
													</xsl:if>
												</td>
												<td  class="Ritenuta" >
													<xsl:if test="Ritenuta">
														<xsl:value-of select="Ritenuta" />
													</xsl:if>
												</td>
												<td class="import" >
													<xsl:choose>
														<xsl:when test="Natura">
															<xsl:value-of select="Natura" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:if test="AliquotaIVA">
																<xsl:value-of select="format-number(AliquotaIVA,  '###.###.##0,00', 'euro')" />
															</xsl:if>
														</xsl:otherwise>
													</xsl:choose>
												</td>
												<td class="import">
													<xsl:if test="ImportoContributoCassa">
														<xsl:value-of select="format-number(ImportoContributoCassa,  '###.###.##0,00', 'euro')" />
													</xsl:if>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</xsl:if>
							<!--  Fine Cassa Prevvidenziale    -->
							<div class="separa" />
							<!-- Dati RIEPILOGO-->
							<table class="tbTitolo">
								<thead>
									<tr>
										<th>RIEPILOGHI IVA E TOTALI</th>
									</tr>
								</thead>
							</table>


							<table class="tbFoglio">
								<thead>
									<tr >
										<th colspan="3" >esigibilità iva / riferimenti normativi</th>
										<th class="perc">%IVA</th>
										<th>Spese accessorie</th>
										<th colspan="3" >Totale imponibile</th>
										<th colspan="2" >Totale imposta</th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="DatiBeniServizi/DatiRiepilogo" >
										<xsl:if test="number(ImponibileImporto)">
											<tr>
												<td colspan="3" >
													<xsl:choose>
														<xsl:when test="EsigibilitaIVA">
															<span>
																<xsl:value-of select="EsigibilitaIVA" />
															</span>
															<xsl:variable name="EI">
																<xsl:value-of select="EsigibilitaIVA" />
															</xsl:variable>
															<xsl:choose>
																<xsl:when test="$EI='I'">
																	(esigibilità immediata)
																</xsl:when>
																<xsl:when test="$EI='D'">
																	(esigibilità differita)
																</xsl:when>
																<xsl:when test="$EI='S'">
																	(scissione dei pagamenti)
																</xsl:when>
																<xsl:otherwise>
																	<span>(!!! codice non previsto !!!)</span>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<xsl:otherwise>
															<span>Esigib. non dich. (si presume immediata)</span>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:if test="RiferimentoNormativo">
														<div class="tx-xsmall">
															<xsl:value-of select="RiferimentoNormativo" />
														</div>
													</xsl:if>
													<xsl:if test="Natura">
														<div class="tx-xsmall">
															<xsl:variable name="NIVA">
																<xsl:value-of select="Natura" />
															</xsl:variable>
															<xsl:choose>
																<xsl:when test="$NIVA='N1'">
															(escluse ex art. 15)
																</xsl:when>
																<xsl:when test="$NIVA='N2'">
															(non soggette)
																</xsl:when>
																<xsl:when test="$NIVA='N2.1'">
															(non soggette ad IVA ai sensi degli artt. da 7 a 7-septies del DPR 633/72)
																</xsl:when>
																<xsl:when test="$NIVA='N2.2'">
															(non soggette - altri casi)
																</xsl:when>
																<xsl:when test="$NIVA='N3'">
															(non imponibili)
																</xsl:when>
																<xsl:when test="$NIVA='N3.1'">
															(non imponibili - esportazioni)
																</xsl:when>
																<xsl:when test="$NIVA='N3.2'">
															(non imponibili - cessioni intracomunitarie)
																</xsl:when>
																<xsl:when test="$NIVA='N3.3'">
															(non imponibili - cessioni verso San Marino)
																</xsl:when>
																<xsl:when test="$NIVA='N3.4'">
															(non imponibili - operazioni assimilate alle cessioni all'esportazione)
																</xsl:when>
																<xsl:when test="$NIVA='N3.5'">
															(non imponibili - a seguito di dichiarazioni d'intento)
																</xsl:when>
																<xsl:when test="$NIVA='N3.6'">
															(non imponibili - altre operazioni che non concorrono alla formazione del plafond)
																</xsl:when>
																<xsl:when test="$NIVA='N4'">
															(esenti)
																</xsl:when>
																<xsl:when test="$NIVA='N5'">
															(regime del margine / IVA non esposta in fattura)
																</xsl:when>
																<xsl:when test="$NIVA='N6'">
															(inversione contabile (per le operazioni in reverse charge ovvero nei casi di autofatturazione per acquisti extra UE di servizi ovvero per importazioni di beni nei soli casi previsti))
																</xsl:when>
																<xsl:when test="$NIVA='N6.1'">
															(inversione contabile - cessione di rottami e altri materiali di recupero)
																</xsl:when>
																<xsl:when test="$NIVA='N6.2'">
															(inversione contabile - cessione di oro e argento puro)
																</xsl:when>
																<xsl:when test="$NIVA='N6.3'">
															(inversione contabile - subappalto nel settore edile)
																</xsl:when>
																<xsl:when test="$NIVA='N6.4'">
															(inversione contabile - cessione di fabbricati)
																</xsl:when>
																<xsl:when test="$NIVA='N6.5'">
															(inversione contabile - cessione di telefoni cellulari)
																</xsl:when>
																<xsl:when test="$NIVA='N6.6'">
															(inversione contabile - cessione di prodotti elettronici)
																</xsl:when>
																<xsl:when test="$NIVA='N6.7'">
															(inversione contabile - prestazioni comparto edile e settori connessi)
																</xsl:when>
																<xsl:when test="$NIVA='N6.8'">
															(inversione contabile - operazioni settore energetico)
																</xsl:when>
																<xsl:when test="$NIVA='N6.9'">
															(inversione contabile - altri casi)
																</xsl:when>
																<xsl:when test="$NIVA='N7'">
															(IVA assolta in altro stato UE (vendite a distanza ex art. 40 c. 3 e 4 e art. 41 c. 1 lett. b,  DL 331/93; prestazione di servizi di telecomunicazioni, tele-radiodiffusione ed elettronici ex art. 7-sexies lett. f, )
																</xsl:when>
																<xsl:otherwise>
																	<span>(!!! codice non previsto !!!)</span>
																</xsl:otherwise>
															</xsl:choose> 
														</div>
													</xsl:if>
												</td>
												<td class="import" >
													<xsl:call-template name="FormatIVA">
														<xsl:with-param name="Natura" select="Natura" />
														<xsl:with-param name="IVA" select="AliquotaIVA" />
													</xsl:call-template>
												</td>
												<td class="import">
													<xsl:if test="SpeseAccessorie">
														<xsl:value-of select="format-number(SpeseAccessorie,  '###.###.##0,00', 'euro')" />
													</xsl:if>
												</td>
												<td  colspan="3" class="import" >
													<xsl:if test="ImponibileImporto">
														<xsl:value-of select="format-number(ImponibileImporto,  '###.###.##0,00', 'euro')" />
													</xsl:if>
												</td>
												<td colspan="2"  class="import" >
													<xsl:if test="Imposta">
														<xsl:choose>
															<xsl:when test="Imposta = 0">
																<xsl:text>0</xsl:text>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="format-number(Imposta,  '###.###.##0,00', 'euro')" />
															</xsl:otherwise>
														</xsl:choose>

													</xsl:if>
												</td>
											</tr>
										</xsl:if>
									</xsl:for-each>

									<!--  Totale imponibili e imposte  -->
									<xsl:variable name="TOTALEALIQUOTE">
										<xsl:value-of select="count(DatiBeniServizi/DatiRiepilogo)" />
									</xsl:variable>

									<xsl:if test="$TOTALEALIQUOTE>1">

										<!-- <tr >
								<tr >
									<th colspan = "5"></th>
									<th colspan = "3" >Totale imponibili</th>
									<th colspan = "2" >Totale imposte</th>
								</tr>
							</tr> -->

										<tr >
											<th colspan = "5" >Totali Imponibili e Imposte</th>
											<th colspan = "3" class="import" style="font-size:12px; padding-right:1px">
												<xsl:value-of  select="format-number(sum(DatiBeniServizi/DatiRiepilogo/ImponibileImporto),  '###.###.##0,00', 'euro')"/>	
											</th>
											<th colspan = "2" class="import" style="font-size:12px; padding-right:1px" >
												<xsl:value-of  select="format-number(sum(DatiBeniServizi/DatiRiepilogo/Imposta),  '###.###.##0,00', 'euro')"/>						
											</th>

										</tr>
										<tr>
											<td colspan="10">
												<div class="separa" />
											</td>
										</tr>   
									</xsl:if>
									<!-- FINE Totale Imponibili e imposte -->

									<!-- Importo Totale  -->
									<tr >
										<th  colspan="2">
											Importo bollo
										</th>
										<th  colspan="3">
											Sconto/Maggiorazione
										</th>
										<th   >
											Valuta
										</th>
										<th  colspan="2" >
											Arrotondamento
										</th>
										<th colspan="2" >
											Totale documento
										</th>
									</tr>
									<tr >
										<td colspan="2" class="import" >
											<xsl:if test="DatiGenerali/DatiGeneraliDocumento/DatiBollo/ImportoBollo">
												<xsl:value-of select="format-number(DatiGenerali/DatiGeneraliDocumento/DatiBollo/ImportoBollo,  '###.###.##0,00', 'euro')" />
											</xsl:if>
										</td>
										<td colspan="3" class="import">
											<xsl:for-each select="DatiGenerali/DatiGeneraliDocumento/ScontoMaggiorazione"  >
												<xsl:call-template name="FormatSconto" >
													<xsl:with-param name="tipo" select="Tipo" />
													<xsl:with-param name="percentuale" select="Percentuale" />
													<xsl:with-param name="importo" select="Importo" />
												</xsl:call-template>
											</xsl:for-each>
										</td>
										<td  class="textCenter"  >
											<xsl:if test="DatiGenerali/DatiGeneraliDocumento/Divisa">
												<xsl:value-of select="DatiGenerali/DatiGeneraliDocumento/Divisa" />
											</xsl:if>
										</td>
										<td  colspan="2" class="textCenter"  >
											<xsl:if test="DatiBeniServizi/DatiRiepilogo/Arrotondamento">
												<xsl:value-of select="format-number(DatiBeniServizi/DatiRiepilogo/Arrotondamento,  '###.###.##0,00', 'euro')" />
											</xsl:if>
										</td>
										<td colspan="2" class="import">
											<xsl:if test="DatiGenerali/DatiGeneraliDocumento/ImportoTotaleDocumento">
												<xsl:value-of select="format-number(DatiGenerali/DatiGeneraliDocumento/ImportoTotaleDocumento,  '###.###.##0,00', 'euro')" />
											</xsl:if>
										</td>
									</tr>
									<!-- FINE Importo Totale  -->
								</tbody>
							</table>
							<!--  FINE Dettaglio Linee   -->
							<!--   Dati Ritenuta Acconto   -->
							<xsl:if test="DatiGenerali/DatiGeneraliDocumento/DatiRitenuta">
								<div class="separa"/>
								<xsl:apply-templates select="DatiGenerali/DatiGeneraliDocumento/DatiRitenuta"/>
							</xsl:if>
							<!--  Fine Dati Ritenuta   -->
							<div class="separa"/>
							<!--   Dati Pagamento   -->
							<table class="tbFoglio" >
								<thead>
									<tr>
										<th>Modalità pagamento</th>
										<th width="188px">IBAN</th>
										<th>Istituto</th>
										<th class="data">Data scadenza</th>
										<th class="ximport">Importo</th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="DatiPagamento" >
										<xsl:for-each select="DettaglioPagamento">
											<tr>
												<td>
													<xsl:if test="ModalitaPagamento">
														<span>
															<xsl:value-of select="ModalitaPagamento" />
														</span>
														<xsl:variable name="MP">
															<xsl:value-of select="ModalitaPagamento" />
														</xsl:variable>
														<xsl:choose>
															<xsl:when test="$MP='MP01'">
																Contanti
															</xsl:when>
															<xsl:when test="$MP='MP02'">
																Assegno
															</xsl:when>
															<xsl:when test="$MP='MP03'">
																Assegno circolare
															</xsl:when>
															<xsl:when test="$MP='MP04'">
																Contanti presso Tesoreria
															</xsl:when>
															<xsl:when test="$MP='MP05'">
																Bonifico
															</xsl:when>
															<xsl:when test="$MP='MP06'">
																Vaglia cambiario
															</xsl:when>
															<xsl:when test="$MP='MP07'">
																Bollettino bancario
															</xsl:when>
															<xsl:when test="$MP='MP08'">
																Carta di pagamento
															</xsl:when>
															<xsl:when test="$MP='MP09'">
																RID
															</xsl:when>
															<xsl:when test="$MP='MP10'">
																RID utenze
															</xsl:when>
															<xsl:when test="$MP='MP11'">
																RID veloce
															</xsl:when>
															<xsl:when test="$MP='MP12'">
																RIBA
															</xsl:when>
															<xsl:when test="$MP='MP13'">
																MAV
															</xsl:when>
															<xsl:when test="$MP='MP14'">
																Quietanza erario
															</xsl:when>
															<xsl:when test="$MP='MP15'">
																Giroconto su conti di contabilità speciale
															</xsl:when>
															<xsl:when test="$MP='MP16'">
																Domiciliazione bancaria
															</xsl:when>
															<xsl:when test="$MP='MP17'">
																Domiciliazione postale
															</xsl:when>
															<xsl:when test="$MP='MP18'">
																Bollettino di c/c postale
															</xsl:when>
															<xsl:when test="$MP='MP19'">
																SEPA Direct Debit
															</xsl:when>
															<xsl:when test="$MP='MP20'">
																SEPA Direct Debit CORE
															</xsl:when>
															<xsl:when test="$MP='MP21'">
																SEPA Direct Debit B2B
															</xsl:when>
															<xsl:when test="$MP='MP22'">
																Trattenuta su somme già riscosse
															</xsl:when>
															<xsl:when test="$MP=''">
															</xsl:when>
															<xsl:otherwise>
																<span/>
															</xsl:otherwise>
														</xsl:choose>
														<span>
															<xsl:value-of select="OpzDescrizionePagamento" />
														</span>
													</xsl:if>
												</td>
												<td>
													<xsl:if test="IBAN">
														<xsl:value-of select="IBAN" />
													</xsl:if>
												</td>
												<td>
													<xsl:if test="IstitutoFinanziario">
														<xsl:value-of select="IstitutoFinanziario" />
													</xsl:if>
												</td>
												<td class="data">
													<xsl:if test="DataScadenzaPagamento">
														<xsl:call-template name="FormatDateIta">
															<xsl:with-param name="DateTime" select="DataScadenzaPagamento" />
														</xsl:call-template>
													</xsl:if>
												</td>
												<td class="import">
													<xsl:if test="ImportoPagamento">
														<xsl:value-of select="format-number(ImportoPagamento,  '###.###.##0,00', 'euro')" />
													</xsl:if>
												</td>
											</tr>
										</xsl:for-each>
									</xsl:for-each>
								</tbody>
							</table>
							<!-- FINE   Dati Pagamento   -->
							<!-- <div style="height:10px" /> -->
							<xsl:for-each select="OpzRiepilogoIVA"  >
								<div class="tx-xsmall">
									* 
									<xsl:value-of select="." />
								</div>
							</xsl:for-each>
							<xsl:if test="OpzRiepilogoIVA">
								<div style="height:10px" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					<!-- Definizione degli allegati -->
					<xsl:if test="Allegati">
						<div class="tx-small" >Allegati:</div>
						<ul class="ulAllegati">
							<xsl:for-each select="Allegati">
								<li>
									<div class="tx-small">
										<span>
											<xsl:value-of select="NomeAttachment" />
										</span>
										<xsl:text/>
										<span style ="margin-left:5px">
											(
											<xsl:value-of select="DescrizioneAttachment" />
											)
										</span>
									</div>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:if>
					<!--Definizione se fattura è AssoSofware-->
					<xsl:if test="$posASWRELSTD &gt; 0 ">
						<div class="dtASWRELSTD">
							<label class="headerLabel">Conforme Standard AssoSoftware</label>
						</div>
					</xsl:if>
					<!-- FINE    ASWRELSTD  -->

				</xsl:for-each>
				<div class="nomeFile" >
					<xsl:apply-templates select="processing-instruction('xml-stylesheet')" />
				</div>


				<!--FINE BODY-->
			</div>
		</xsl:if>
	</xsl:template>


	<xsl:template match="/">
		<html>
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=edge" />
				<!-- <script>
				function outputUrl() {
				var currentScripts = document.getElementsByTagName('script');
				var lastScript = currentScripts[currentScripts.length - 1];
				var fileUrl = window.location.href;
				var steps = fileUrl.split('/');
				var fileName = steps[steps.length - 1];
				lastScript.parentNode.replaceChild(document.createTextNode(fileName), lastScript);
			  }
			</script> -->
				<style type="text/css">
					#fattura-elettronica {
					font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
					margin-left: auto;
					margin-right: auto;
					max-width: 800px;
					min-width: 800px;
					padding: 0;
					}
					#fattura-elettronica div.page {
					}
					.tbHeader {
					width: 800px;
					border: 2px solid black;
					}
					tr td {
					vertical-align: middle;
					}
					.tdHead {
					width: 50%;
					height: 91px;
					border: 1px solid black;
					}
					.tableHead {
					font-size:smaller;
					width: 100%;
					}
					.headBorder {
					<!--border: 2px solid black;
                  width:100%; 
                  height: 210px;
                  border-bottom-left-radius:30px;
                  border-bottom-right-radius:30px; -->
					}
					.headerLabel {
					color:#282828;
					font-weight:bold;
					margin-left:10px;
					}
					.headContent {
					margin-left:10px;
					margin-bottom:0px
					}
					.mt5 {
					margin-top:5px
					}
					tr.break {
					page-break-after: always; 
					}
					.ulAllegati {
					margin-top:0px;
					}
					.separa {
					height:20px;
					}
					.nomargintop {
					margin-top:-1px;
					}
					table.tbTitolo {
					width: 800px;
					table-layout: fixed;
					border-collapse: collapse;
					word-wrap:normal; <!--break-word;-->
					}
					table.tbTitolo th {
					padding-left: 5px;
					padding-right: 5px;
					border: solid 1px #000000;
					border-bottom: none;
					color: white;
					background-color: Gray;
					font-size:x-small;
					}
					table.tbFoglio {
					width: 800px;
					table-layout: fixed;
					border-collapse: collapse;
					word-wrap:normal; <!--break-word;-->
					border-radius:8px;
					}
					table.tbFoglio th {
					padding-left: 5px;
					padding-right: 5px;
					border: solid 1px #000000;
					background-color: LightGrey;
					<!-- text-transform: uppercase; -->
					font-size:x-small;
					}
					.trclass {
					border-bottom:1px solid black;
					}
					.trclass td {
					vertical-align:middle !important;
					}
					table.tbFoglio tbody {
					border: solid 1px #000000;
					}
					table.tbFoglio th .perc {
					width:50px;
					}
					table.tbFoglio td {
					font-size:small;
					border-right: solid 1px #000000;
					border-bottom: none;
					border-left: solid 1px #000000;
					}
					table.tbFoglio tr {
					}

					.textRight {
					text-align:right;
					}
					.textCenter {
					text-align:center;
					}
					.textPerc
					{
					width:50px;
					}
					td.Ritenuta
					{
					width:50px;
					text-align:center;
					}
					th.title, .title td {
					width:48%
					}
					th.perc {
					width:50px;
					}
					th.perc2 {
					width:40px;
					}
					th.data {
					width:80px;
					}
					th.import
					{
					width:100px;
					}
					td.import
					{
					text-align:right;
					}
					th.import2
					{
					width:75px;
					}
					td.import2
					{
					text-align:right;
					}
					th.ximport
					{
					width:90px;
					}
					td.ximport
					{
					text-align:center;
					}
					th.ximport2 {
					width:80px;
					}
					td.ximport2 {
					text-align:center;
					}
					td.data {
					text-align:center;
					}
					.tx-xsmall {
					font-size:x-small;
					}
					.tx-small {
					font-size:small;
					}
					.import {
					text-align:right;
					}
					.fontbold {
					font-weight:bold;
					}
					.middle {
					vertical-align:middle;
					display:table-cell;
					}
					tbody tr:not(:last-child) {
					border-bottom:1px solid lightgray
					}		 
					.nomeFile {
					font-size: 10px;
					color: black;
					text-align: right;
					}
				</style>
			</head>
			<body>
				<div id="fattura-container">
					<xsl:choose>
						<xsl:when test="d:FatturaElettronicaSemplificata">
							<!--versione 1.0 SEMPLIFICATA-->
							<xsl:call-template name="FatturaElettronica">
								<xsl:with-param name="TipoFattura" select="d:FatturaElettronicaSemplificata" />
								<xsl:with-param name="IsFPRS" select="1" />
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="c:FatturaElettronica">
							<!--versione 1.0-->
							<xsl:call-template name="FatturaElettronica">
								<xsl:with-param name="TipoFattura" select="c:FatturaElettronica" />
								<xsl:with-param name="IsFPRS" select="0" />
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="b:FatturaElettronica">
							<!--versione 1.1-->
							<xsl:call-template name="FatturaElettronica">
								<xsl:with-param name="TipoFattura" select="b:FatturaElettronica" />
								<xsl:with-param name="IsFPRS" select="0" />
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="FatturaElettronica">
								<!--versione 1.2-->
								<xsl:with-param name="TipoFattura" select="a:FatturaElettronica" />
								<xsl:with-param name="IsFPRS" select="0" />
							</xsl:call-template>

						</xsl:otherwise>
					</xsl:choose>



				</div>

			</body>
		</html>
	</xsl:template>

	<xsl:template match="processing-instruction('xml-stylesheet')">
		<xsl:variable name="nomeFile" select='substring-before(substring-after(.,"nomeFile=&apos;"),"&apos;")' />
		<xsl:variable name="dataFile" select='substring-before(substring-after(.,"dataFile=&apos;"),"&apos;")' />
		<xsl:variable name="oraFile" select='substring-before(substring-after(.,"oraFile=&apos;"),"&apos;")' />


		<xsl:choose>
			<xsl:when test="not($nomeFile = '')">
				File di origine <xsl:value-of select="$nomeFile" />
			</xsl:when>
		</xsl:choose>

		<xsl:choose>
			<xsl:when test="not($dataFile = '')">
				ricevuto il <xsl:value-of select="$dataFile" />
			</xsl:when>
		</xsl:choose>

		<xsl:choose>
			<xsl:when test="not($oraFile = '')">
				alle <xsl:value-of select="$oraFile" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>