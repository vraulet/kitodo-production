<%@ page session="false" contentType="text/html;charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f"%>
<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h"%>
<%@ taglib uri="http://jsftutorials.net/htmLib" prefix="htm"%>
<%@ taglib uri="http://myfaces.apache.org/tomahawk" prefix="x"%>

<%--
  ~ This file is part of the Goobi Application - a Workflow tool for the support of
  ~ mass digitization.
  ~
  ~ Visit the websites for more information.
  ~     - http://gdz.sub.uni-goettingen.de
  ~     - http://www.goobi.org
  ~     - http://launchpad.net/goobi-production
  ~
  ~ This program is free software; you can redistribute it and/or modify it under
  ~ the terms of the GNU General Public License as published by the Free Software
  ~ Foundation; either version 2 of the License, or (at your option) any later
  ~ version.
  ~
  ~ This program is distributed in the hope that it will be useful, but WITHOUT ANY
  ~ WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
  ~ PARTICULAR PURPOSE. See the GNU General Public License for more details. You
  ~ should have received a copy of the GNU General Public License along with this
  ~ program; if not, write to the Free Software Foundation, Inc., 59 Temple Place,
  ~ Suite 330, Boston, MA 02111-1307 USA
  --%>

<%-- ===================== GROSSE Werkstuecke- BOX IM GELADENEN PROZESS ====================== --%>

<htm:h4 style="margin-top:15">
	<h:outputText value="#{msgs.werkstuecke}" />
</htm:h4>

<x:dataTable id="werkstuecke" styleClass="standardTable" width="100%"
	cellspacing="1px" cellpadding="1px" headerClass="standardTable_Header"
	rowClasses="standardTable_Row1,standardTable_Row2"
	columnClasses="standardTable_ColumnCentered,standardTable_Column,standardTable_ColumnCentered,standardTable_ColumnCentered"
	var="item" value="#{ProzessverwaltungForm.myProzess.werkstueckeList}"
	rowIndexVar="index">

	<%-- ===================== Nr ====================== --%>
	<h:column>
		<f:facet name="header">
			<h:outputText value="#{msgs.nr}" />
		</f:facet>
		<h:outputText value="#{index+1}" />
	</h:column>
	<%-- ===================== // Nr ====================== --%>

	<%-- ===================== Eigenschaften ====================== --%>
	<h:column>
		<f:facet name="header">
			<h:outputText value="#{msgs.eigenschaften}" />
		</f:facet>
		<x:dataTable value="#{item.eigenschaften}" var="prop">
			<h:column>
				<h:outputText value="#{prop.titel}:" style="color:grey" />
			</h:column>
			<h:column>
				<h:outputText value="#{prop.wert}" />
			</h:column>
		</x:dataTable>
	</h:column>
	<%-- ===================== // Eigenschaften ====================== --%>

	<h:column
		rendered="#{(LoginForm.maximaleBerechtigung == 1) || (LoginForm.maximaleBerechtigung == 2)}">
		<f:facet name="header">
			<h:outputText value="#{msgs.auswahl}" />
		</f:facet>
		<%-- Bearbeiten-Schaltknopf --%>
		<h:commandLink action="ProzessverwaltungBearbeitenWerkstueck"
			title="#{msgs.werkstueckBearbeiten}">
			<h:graphicImage value="/newpages/images/buttons/goInto.gif" />
			<x:updateActionListener
				property="#{ProzessverwaltungForm.myWerkstueckReload}"
				value="#{item}" />
		</h:commandLink>
	</h:column>

</x:dataTable>

<%-- Neu-Schaltknopf --%>
<h:commandLink action="#{ProzessverwaltungForm.WerkstueckNeu}"
	rendered="#{(LoginForm.maximaleBerechtigung == 1) || (LoginForm.maximaleBerechtigung == 2)}"
	value="#{msgs.werkstueckHinzufuegen}"
	title="#{msgs.werkstueckHinzufuegen}">
</h:commandLink>