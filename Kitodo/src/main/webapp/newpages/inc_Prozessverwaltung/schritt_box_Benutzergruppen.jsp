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
<%@ taglib uri="http://www.jenia.org/jsf/popup" prefix="jp" %>

<%-- ++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>
<%-- ++++++++++     Benutzergruppenberechtigungentabelle      +++++++++++++++ --%>
<%-- ++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

<htm:h4 style="margin-top:15">
    <h:outputText value="#{msgs.benutzergruppen}"/>
</htm:h4>


<x:dataTable id="benutzergruppen" styleClass="standardTable"
             width="100%" cellspacing="1px" cellpadding="1px"
             headerClass="standardTable_Header" rowClasses="standardTable_Row1"
             columnClasses="standardTable_Column,standardTable_ColumnCentered"
             var="item"
             value="#{ProzessverwaltungForm.mySchritt.userGroups}">

    <h:column>
        <f:facet name="header">
            <h:outputText value="#{msgs.titel}"/>
        </f:facet>
        <h:outputText value="#{item.title}"/>
    </h:column>
    <h:column>
        <f:facet name="header">
            <h:outputText value="#{msgs.loeschen}"/>
        </f:facet>
        <%-- Löschen-Schaltknopf --%>
        <h:commandLink
                action="#{ProzessverwaltungForm.BenutzergruppeLoeschen}"
                title="#{msgs.berechtigungLoeschen}">
            <h:graphicImage value="/newpages/images/buttons/waste1a_20px.gif"/>
            <x:updateActionListener
                    property="#{ProzessverwaltungForm.myBenutzergruppe}" value="#{item}"/>
        </h:commandLink>
    </h:column>
</x:dataTable>

<%-- newUser-Schaltknopf --%>
<h:panelGroup>
    <%-- Benutzergruppen mittels IFrame zuweisen --%>
    <jp:popupFrame scrolling="auto" height="380px" width="430px"
                   topStyle="background: #1874CD;" bottomStyleClass="popup_unten"
                   styleFrame="border-style: solid;border-color: #1874CD; border-width: 2px;"
                   styleClass="standardlink"
                   style="margin-top:2px;display:block; text-decoration:none"
                   actionOpen="#{BenutzergruppenForm.FilterKeinMitZurueck}"
                   actionClose="#{NavigationForm.Reload}" center="true"
                   title="#{msgs.benutzergruppen}" immediate="true">
        <x:updateActionListener property="#{BenutzergruppenForm.zurueck}"
                                value="BerechtigungBenutzergruppenPopup"/>
        <h:outputText style="border-bottom: #a24033 dashed 1px;"
                      value="#{msgs.benutzergruppenHinzufuegen}"/>
    </jp:popupFrame>
</h:panelGroup>
