<%--
 *
 * (c) Kitodo. Key to digital objects e. V. <contact@kitodo.org>
 *
 * This file is part of the Kitodo project.
 *
 * It is licensed under GNU General Public License version 3 or later.
 *
 * For the full copyright and license information, please read the
 * GPL3-License.txt file that was distributed with this source code.
 *
--%>

<%@ page session="false" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://jsftutorials.net/htmLib" prefix="htm" %>
<%@ taglib uri="http://myfaces.apache.org/tomahawk" prefix="x" %>
<%@ taglib uri="http://www.jenia.org/jsf/dynamic" prefix="jd" %>
<%@ taglib uri="http://sourceforge.net/projects/jsf-comp/easysi" prefix="si" %>

<h:panelGroup
        rendered="#{AktuelleSchritteForm.mySchritt.processingUser.id == LoginForm.myBenutzer.id}">

    <%-- ++++++++++++++++     Import      ++++++++++++++++ --%>
    <htm:table cellpadding="3" cellspacing="0" width="100%"
               styleClass="eingabeBoxen" style="margin-top:20px"
               rendered="#{AktuelleSchritteForm.modusBearbeiten=='' && AktuelleSchritteForm.mySchritt.process.blockedUsers == null && AktuelleSchritteForm.mySchritt.typeImportFileUpload}">
        <htm:tr>
            <htm:td styleClass="eingabeBoxen_row1">
                <h:outputText value="#{msgs.metadatenImportieren}"/>
            </htm:td>
        </htm:tr>
        <htm:tr>
            <htm:td styleClass="eingabeBoxen_row2">
                <h:panelGrid columns="1">

                    <%-- Import-Upload --%>
                    <h:panelGroup>
                        <h:panelGroup rendered="#{Import.importMeldung !=''}">
                            <h:outputText value="#{Import.importMeldung}"
                                          style="color: blue;"/>
                            <htm:br/>
                            <htm:br/>
                        </h:panelGroup>

                        <h:panelGroup rendered="#{Import.importFehler !=''}">
                            <h:outputText value="#{Import.importFehler}" style="color: red;"
                                          escape="false"/>
                            <htm:br/>
                            <htm:br/>
                        </h:panelGroup>

                        <h:form enctype="multipart/form-data" id="formupload">
                            <x:inputFileUpload id="fileupload" accept="image/*"
                                               value="#{Import.upDatei}" storage="file"
                                               styleClass="fileUploadInput" required="false"/>
                            <h:commandButton value="#{msgs.metadatenImportieren}" id="button1"
                                             action="#{Import.start}">
                                <x:updateActionListener property="#{Import.mySchritt}"
                                                        value="#{AktuelleSchritteForm.mySchritt}"/>
                            </h:commandButton>
                        </h:form>
                    </h:panelGroup>

                </h:panelGrid>
            </htm:td>
        </htm:tr>

    </htm:table>
    <%-- ++++++++++++++++     // Import      ++++++++++++++++ --%>
    <h:form id="actionform">
        <%-- ++++++++++++++++     Action      ++++++++++++++++ --%>
        <htm:table cellpadding="3" cellspacing="0" width="100%"
                   styleClass="eingabeBoxen" style="margin-top:20px"
                   rendered="#{AktuelleSchritteForm.modusBearbeiten==''}">
            <htm:tr>
                <htm:td styleClass="eingabeBoxen_row1">
                    <h:outputText value="#{msgs.moeglicheAktionen}"/>
                </htm:td>
            </htm:tr>
            <htm:tr>
                <htm:td styleClass="eingabeBoxen_row2">
                    <h:panelGrid columns="1">

                        <%-- Sperrung der Metadaten anzeigen --%>
                        <h:panelGroup
                                style="color: red;margin-top:5px;margin-bottom:15px;display:block"
                                rendered="#{AktuelleSchritteForm.mySchritt.process.blockedUsers != null}">
                            <h:outputText value="#{msgs.gesperrt}"/>
                            <htm:br/>
                            <h:panelGrid columns="2" style="color: red;margin-left:30px"
                                         cellpadding="3">
                                <h:outputText value="#{msgs.benutzer}: "/>
                                <h:outputText
                                        value="#{AktuelleSchritteForm.mySchritt.process.blockedUsers.fullName}"/>
                                <h:outputText value="#{msgs.standort}: "/>
                                <h:outputText
                                        value="#{AktuelleSchritteForm.mySchritt.process.blockedUsers.location}"/>
                                <h:outputText value="#{msgs.lebenszeichen} "/>
                                <h:outputText
                                        value="#{AktuelleSchritteForm.mySchritt.process.minutenGesperrt} min #{AktuelleSchritteForm.mySchritt.process.sekundenGesperrt} sec"/>
                            </h:panelGrid>
                            <h:outputText value="#{msgs.spaeter}"/>

                            <%-- Bei Sperrung durch eigenen Benutzer: Sperrung aufheben können --%>
                            <h:commandLink id="action1"
                                           rendered="#{(AktuelleSchritteForm.mySchritt.process.blockedUsers != null) && (AktuelleSchritteForm.mySchritt.process.blockedUsers.id == LoginForm.myBenutzer.id)}"
                                           action="#{AktuelleSchritteForm.sperrungAufheben}"
                                           title="#{msgs.oderSperrungAufheben}">
                                <h:graphicImage value="/newpages/images/buttons/key2a.gif"
                                                style="margin-left:10px;margin-right:3px;vertical-align:middle"/>
                                <h:outputText value="#{msgs.oderSperrungAufheben}"
                                              style="font-weight:bold;font-style:underline"/>
                            </h:commandLink>

                        </h:panelGroup>

                        <%-- Russland-Export-Schaltknopf --%>
                        <%--
                        <h:commandLink
                            rendered="#{AktuelleSchritteForm.mySchritt.typExportRus && AktuelleSchritteForm.mySchritt.prozess.benutzerGesperrt == null}"
                            action="#{AktuelleSchritteForm.DownloadRusExport}"
                            title="#{msgs.russischeMetadatenExportieren}">
                            <h:graphicImage value="/newpages/images/buttons/rus.gif"
                                style="margin-right:3px;vertical-align:middle" />
                            <h:outputText value="#{msgs.russischeMetadatenExportieren}" />
                        </h:commandLink>
                        -->
                        <%-- Plugin-Schaltknopf --%>

                        <h:commandLink
                                rendered="#{AktuelleSchritteForm.mySchritt.stepPlugin != null && AktuelleSchritteForm.mySchritt.stepPlugin != ''}"
                                action="#{AktuelleSchritteForm.callStepPlugin}"
                                title="#{msgs.stepPlugin} (#{AktuelleSchritteForm.mySchritt.stepPlugin})">
                            <h:graphicImage value="/newpages/images/buttons/admin4b.gif"
                                            style="margin-right:3px;vertical-align:middle"/>
                            <h:outputText
                                    value="#{msgs.stepPlugin} (#{AktuelleSchritteForm.mySchritt.stepPlugin})"/>
                        </h:commandLink>

                        <%-- Modul-Schaltknopf --%>
                        <h:commandLink id="action2"
                                       rendered="#{AktuelleSchritteForm.mySchritt.typeModuleName != null && AktuelleSchritteForm.mySchritt.typeModuleName != ''}"
                                       action="#{AktuelleSchritteForm.executeModule}"
                                       title="#{msgs.modulStarten} (#{AktuelleSchritteForm.mySchritt.typeModuleName})">
                            <h:graphicImage value="/newpages/images/buttons/admin4b.gif"
                                            style="margin-right:3px;vertical-align:middle"/>
                            <h:outputText
                                    value="#{msgs.modulStarten} (#{AktuelleSchritteForm.mySchritt.typeModuleName})"/>
                        </h:commandLink>

                        <%-- Script-Schaltknopf --%>
                        <h:commandLink id="action3"
                                       rendered="#{AktuelleSchritteForm.mySchritt.typeAutomaticScriptPath != null && AktuelleSchritteForm.mySchritt.typeAutomaticScriptPath != '' && AktuelleSchritteForm.mySchritt.process.blockedUsers == null}"
                                       action="#{AktuelleSchritteForm.executeScript}"
                                       title="#{AktuelleSchritteForm.mySchritt.scriptName1}">
                            <x:updateActionListener
                                    property="#{AktuelleSchritteForm.scriptPath}"
                                    value="#{AktuelleSchritteForm.mySchritt.typeAutomaticScriptPath}"/>
                            <h:graphicImage value="/newpages/images/buttons/admin4b.gif"
                                            style="margin-right:3px;vertical-align:middle"/>
                            <h:outputText
                                    value="#{msgs.scriptAusfuehren}: #{AktuelleSchritteForm.mySchritt.scriptName1}"/>
                        </h:commandLink>

                        <h:commandLink id="action4"
                                       rendered="#{AktuelleSchritteForm.mySchritt.typeAutomaticScriptPath2 != null && AktuelleSchritteForm.mySchritt.typeAutomaticScriptPath2 != '' && AktuelleSchritteForm.mySchritt.process.blockedUsers == null}"
                                       action="#{AktuelleSchritteForm.executeScript}"
                                       title="#{AktuelleSchritteForm.mySchritt.scriptName2}">
                            <x:updateActionListener
                                    property="#{AktuelleSchritteForm.scriptPath}"
                                    value="#{AktuelleSchritteForm.mySchritt.typeAutomaticScriptPath2}"/>
                            <h:graphicImage value="/newpages/images/buttons/admin4b.gif"
                                            style="margin-right:3px;vertical-align:middle"/>
                            <h:outputText
                                    value="#{msgs.scriptAusfuehren}: #{AktuelleSchritteForm.mySchritt.scriptName2}"/>
                        </h:commandLink>

                        <h:commandLink id="action5"
                                       rendered="#{AktuelleSchritteForm.mySchritt.typeAutomaticScriptPath3 != null && AktuelleSchritteForm.mySchritt.typeAutomaticScriptPath3 != '' && AktuelleSchritteForm.mySchritt.process.blockedUsers == null}"
                                       action="#{AktuelleSchritteForm.executeScript}"
                                       title="#{AktuelleSchritteForm.mySchritt.scriptName3}">
                            <x:updateActionListener
                                    property="#{AktuelleSchritteForm.scriptPath}"
                                    value="#{AktuelleSchritteForm.mySchritt.typeAutomaticScriptPath3}"/>
                            <h:graphicImage value="/newpages/images/buttons/admin4b.gif"
                                            style="margin-right:3px;vertical-align:middle"/>
                            <h:outputText
                                    value="#{msgs.scriptAusfuehren}: #{AktuelleSchritteForm.mySchritt.scriptName3}"/>
                        </h:commandLink>

                        <h:commandLink id="action6"
                                       rendered="#{AktuelleSchritteForm.mySchritt.typeAutomaticScriptPath4 != null && AktuelleSchritteForm.mySchritt.typeAutomaticScriptPath4 != '' && AktuelleSchritteForm.mySchritt.process.blockedUsers == null}"
                                       action="#{AktuelleSchritteForm.executeScript}"
                                       title="#{AktuelleSchritteForm.mySchritt.scriptName4}">
                            <x:updateActionListener
                                    property="#{AktuelleSchritteForm.scriptPath}"
                                    value="#{AktuelleSchritteForm.mySchritt.typeAutomaticScriptPath4}"/>
                            <h:graphicImage value="/newpages/images/buttons/admin4b.gif"
                                            style="margin-right:3px;vertical-align:middle"/>
                            <h:outputText
                                    value="#{msgs.scriptAusfuehren}: #{AktuelleSchritteForm.mySchritt.scriptName4}"/>
                        </h:commandLink>

                        <h:commandLink id="action7"
                                       rendered="#{AktuelleSchritteForm.mySchritt.typeAutomaticScriptPath5 != null && AktuelleSchritteForm.mySchritt.typeAutomaticScriptPath5 != '' && AktuelleSchritteForm.mySchritt.process.blockedUsers == null}"
                                       action="#{AktuelleSchritteForm.executeScript}"
                                       title="#{AktuelleSchritteForm.mySchritt.scriptName5}">
                            <x:updateActionListener
                                    property="#{AktuelleSchritteForm.scriptPath}"
                                    value="#{AktuelleSchritteForm.mySchritt.typeAutomaticScriptPath5}"/>

                            <h:graphicImage value="/newpages/images/buttons/admin4b.gif"
                                            style="margin-right:3px;vertical-align:middle"/>
                            <h:outputText
                                    value="#{msgs.scriptAusfuehren}: #{AktuelleSchritteForm.mySchritt.scriptName5}"/>
                        </h:commandLink>
                        <%-- tiffHeaderDownload-Schaltknopf --%>
                        <h:commandLink id="action8"
                                       rendered="#{0==1 && AktuelleSchritteForm.mySchritt.process.blockedUsers == null}"
                                       action="#{AktuelleSchritteForm.downloadTiffHeader}"
                                       title="#{msgs.dateiMitTiffHeaderSpeichern}">
                            <h:graphicImage value="/newpages/images/buttons/tif.gif"
                                            style="margin-right:3px;vertical-align:middle"/>
                            <h:outputText value="#{msgs.dateiMitTiffHeaderSpeichern}"/>
                        </h:commandLink>

                        <%-- Import in das DMS-Schaltknopf --%>

                        <%-- TODO: delete this warning once the root cause of the timeout problem is solved  --%>
                        <h:outputText style="back-color:blue; color: red; font-weight: bold;"
                                      rendered="#{AktuelleSchritteForm.mySchritt.typeExportDMS && AktuelleSchritteForm.mySchritt.process.blockedUsers == null}"
                                      value="#{msgs.timeoutWarningDMS}"/>

                        <%-- Upload-Schaltknopf --%>
                        <h:commandLink id="action9"
                                       rendered="#{AktuelleSchritteForm.mySchritt.typeExportDMS && AktuelleSchritteForm.mySchritt.process.blockedUsers == null}"
                                       action="#{AktuelleSchritteForm.exportDMS}"
                                       title="#{msgs.importDms}">
                            <h:graphicImage value="/newpages/images/buttons/dms.png"
                                            style="margin-right:3px;vertical-align:middle"/>
                            <h:outputText value="#{msgs.importDms}"/>
                        </h:commandLink>

                        <%-- Metadaten-Schaltknopf --%>
                        <h:commandLink id="action10"
                                       rendered="#{AktuelleSchritteForm.mySchritt.typeMetadata && AktuelleSchritteForm.mySchritt.process.blockedUsers == null}"
                                       action="#{Metadaten.readXml}"
                                       title="#{msgs.metadatenBearbeiten}">
                            <h:graphicImage value="/newpages/images/buttons/view1.gif"
                                            style="margin-left:7px;margin-right:10px;vertical-align:middle"/>
                            <h:outputText value="#{msgs.metadatenBearbeiten}"/>
                            <x:updateActionListener
                                    value="#{AktuelleSchritteForm.mySchritt.processingTimeNow}"
                                    property="#{AktuelleSchritteForm.mySchritt.processingTimeNow}"></x:updateActionListener>
                            <f:param name="ProzesseID"
                                     value="#{AktuelleSchritteForm.mySchritt.process.id}"/>
                            <f:param name="BenutzerID" value="#{LoginForm.myBenutzer.id}"/>
                            <f:param name="zurueck" value="AktuelleSchritteBearbeiten"/>
                        </h:commandLink>

                        <%-- Bearbeitung abbrechen-Schaltknopf --%>
                        <h:commandLink id="action11"
                                       action="#{AktuelleSchritteForm.schrittDurchBenutzerZurueckgeben}"
                                       title="#{msgs.bearbeitungDiesesSchrittesAbgeben}"
                                       onclick="if (!confirm('#{msgs.bearbeitungDiesesSchrittesWirklichAbgeben}')) return">
                            <h:graphicImage value="/newpages/images/buttons/cancel3.gif"
                                            style="margin-right:3px;vertical-align:middle"/>
                            <h:outputText value="#{msgs.bearbeitungDiesesSchrittesAbgeben}"/>
                        </h:commandLink>

                        <%-- Schritt zurückgeben an vorherige Station für Korrekturzwecke --%>
                        <h:panelGroup rendered="#{AktuelleSchritteForm.sizeOfPreviousStepsForProblemReporting > 0}">
                            <jd:hideableController for="korrektur" id="korrekturswitcher"
                                                   title="#{msgs.korrekturmeldungAnVorherigeStationSenden}">
                                <h:graphicImage
                                        value="/newpages/images/buttons/step_back_20px.gif"
                                        style="margin-right:3px;vertical-align:middle"/>
                                <h:outputText
                                        value="#{msgs.korrekturmeldungAnVorherigeStationSenden}"/>
                            </jd:hideableController>

                            <jd:hideableArea id="korrektur" saveState="view">
                                <h:panelGrid columns="2" style="margin-left:40px;" id="grid3"
                                             rowClasses="top"
                                             columnClasses="standardTable_Column,standardTable_ColumnRight">
                                    <h:outputText value="#{msgs.zurueckZuArbeitsschritt}"/>
                                    <h:selectOneMenu style="width:350px"
                                                     value="#{AktuelleSchritteForm.myProblemID}">
                                        <si:selectItems
                                                value="#{AktuelleSchritteForm.previousStepsForProblemReporting}"
                                                var="step1" itemLabel="#{step1.titleWithUserName}"
                                                itemValue="#{step1.id}"/>
                                    </h:selectOneMenu>
                                    <h:outputText value="#{msgs.bemerkung}"/>
                                    <h:inputTextarea style="width:350px;height:80px"
                                                     value="#{AktuelleSchritteForm.problemMessage}"/>
                                    <%-- Statistische Auswertung-Schaltknopf für gesamtes Trefferset --%>
                                    <h:outputText value=""/>
                                    <h:commandLink id="action13"
                                                   action="#{AktuelleSchritteForm.reportProblem}"
                                                   title="#{msgs.korrekturmeldungSenden}"
                                                   onclick="if (!confirm('#{msgs.wirklichAusfuehren}?')) return">
                                        <h:outputText value="#{msgs.korrekturmeldungSenden}"/>
                                    </h:commandLink>
                                </h:panelGrid>
                            </jd:hideableArea>
                        </h:panelGroup>

                        <%-- Schritt weitergeben an nachfolgende Station für KorrekturBehobenZwecke --%>
                        <h:panelGroup
                                rendered="#{AktuelleSchritteForm.mySchritt.priority>9 && AktuelleSchritteForm.sizeOfNextStepsForProblemSolution > 0}">
                            <jd:hideableController for="solution" id="solutionswitcher"
                                                   title="#{msgs.meldungUeberProblemloesungAnNachchfolgendeStationSenden}">
                                <h:graphicImage
                                        value="/newpages/images/buttons/step_for_20px.gif"
                                        style="margin-right:3px;vertical-align:middle"/>
                                <h:outputText
                                        value="#{msgs.meldungUeberProblemloesungAnNachchfolgendeStationSenden}"/>
                            </jd:hideableController>

                            <jd:hideableArea id="solution" saveState="view">
                                <h:panelGrid columns="2" style="margin-left:40px;"
                                             rowClasses="top" id="grid1"
                                             columnClasses="standardTable_Column,standardTable_ColumnRight">
                                    <h:outputText value="#{msgs.weiterZuArbeitsschritt}"/>
                                    <h:selectOneMenu style="width:350px" id="select1"
                                                     value="#{AktuelleSchritteForm.mySolutionID}">
                                        <si:selectItems
                                                value="#{AktuelleSchritteForm.nextStepsForProblemSolution}"
                                                var="step2" itemLabel="#{step2.titelMitBenutzername}"
                                                itemValue="#{step2.id}"/>
                                    </h:selectOneMenu>
                                    <h:outputText value="#{msgs.bemerkung}"/>
                                    <h:inputTextarea style="width:350px;height:80px" id="input1"
                                                     value="#{AktuelleSchritteForm.solutionMessage}"/>
                                    <%-- Statistische Auswertung-Schaltknopf für gesamtes Trefferset --%>
                                    <h:outputText value=""/>
                                    <h:commandLink id="action14"
                                                   action="#{AktuelleSchritteForm.solveProblem}"
                                                   title="#{msgs.meldungUeberProblemloesungSenden}"
                                                   onclick="if (!confirm('#{msgs.wirklichAusfuehren}?')) return">
                                        <h:outputText value="#{msgs.meldungUeberProblemloesungSenden}"/>
                                    </h:commandLink>
                                </h:panelGrid>
                            </jd:hideableArea>
                        </h:panelGroup>

                        <%-- Abschliessen-Schaltknopf --%>
                        <h:commandLink id="action15"
                                       action="#{AktuelleSchritteForm.schrittDurchBenutzerAbschliessen}"
                                       title="#{msgs.diesenSchrittAbschliessen}"
                                       onclick="if (!confirm('#{msgs.diesenSchrittAbschliessen}?')) return">
                            <h:graphicImage value="/newpages/images/buttons/ok.gif"
                                            style="margin-right:3px;vertical-align:middle"/>
                            <h:outputText value="#{msgs.diesenSchrittAbschliessen}"/>
                        </h:commandLink>

                    </h:panelGrid>
                </htm:td>
            </htm:tr>

        </htm:table>
        <%-- ++++++++++++++++     // Action      ++++++++++++++++ --%>
    </h:form>
</h:panelGroup>
