<%@ page session="false" contentType="text/html;charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f"%>
<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h"%>
<%@ taglib uri="http://jsftutorials.net/htmLib" prefix="htm"%>
<%@ taglib uri="http://myfaces.apache.org/tomahawk" prefix="x"%>
<%@ taglib uri="http://sourceforge.net/projects/jsf-comp/easysi" prefix="si"%>
<%@ taglib uri="http://richfaces.org/rich" prefix="rich"%>
<%@ taglib uri="https://ajax4jsf.dev.java.net/ajax" prefix="a4j"%>

<%-- 
 * This file is part of the Goobi Application - a Workflow tool for the support of mass digitization.
 * 
 * Visit the websites for more information. 
 *     		- http://www.goobi.org
 *     		- http://launchpad.net/goobi-production
 * 		    - http://gdz.sub.uni-goettingen.de
 * 			- http://www.intranda.com
 * 			- http://digiverso.com 
 * 
 * This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2 of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59
 * Temple Place, Suite 330, Boston, MA 02111-1307 USA
 * 
 * Linking this library statically or dynamically with other modules is making a combined work based on this library. Thus, the terms and conditions
 * of the GNU General Public License cover the whole combination. As a special exception, the copyright holders of this library give you permission to
 * link this library with independent modules to produce an executable, regardless of the license terms of these independent modules, and to copy and
 * distribute the resulting executable under terms of your choice, provided that you also meet, for each linked independent module, the terms and
 * conditions of the license of that module. An independent module is a module which is not derived from or based on this library. If you modify this
 * library, you may extend this exception to your version of the library, but you are not obliged to do so. If you do not wish to do so, delete this
 * exception statement from your version.
--%>
<%-- ++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>
<%-- ++++++++++++++++     Eigenschaftentabelle      ++++++++++++++++ --%>
<%-- ++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

<htm:h4 style="margin-top:15" rendered="#{ProzessverwaltungForm.modusBearbeiten!='eigenschaft'}">
	<h:outputText value="#{msgs.eigenschaften}" />
</htm:h4>
<htm:table cellspacing="1px" cellpadding="1px"  width="100%" styleClass="standardTable"  rendered="#{ProzessverwaltungForm.modusBearbeiten!='eigenschaft'}">

	<htm:thead styleClass="standardTable_Header">
		<htm:th>
			<h:outputText value="#{msgs.titel}" />
		</htm:th>
		<htm:th>
			<h:outputText value="#{msgs.wert}" />
		</htm:th>
		<htm:th>
			<h:outputText value="#{msgs.auswahl}" />
		</htm:th>
	</htm:thead>
	<x:dataList var="container" value="#{ProzessverwaltungForm.myProzess.displayProperties.containers}" rowCountVar="rowCount" rowIndexVar="rowIndex">
		<x:dataList var="process_item" value="#{ProzessverwaltungForm.myProzess.displayProperties.sortedProperties}" >
			<htm:tr rendered="#{process_item.container==container}" styleClass="standardTable_Row1">
				<htm:td styleClass="standardTable_Column">
					<h:outputText value="#{process_item.titel}" />
				</htm:td>
				<htm:td styleClass="standardTable_Column">
					<h:outputText value="#{process_item.date}" rendered="#{process_item.type.name == 'date'}">
						<f:convertDateTime dateStyle="medium" />
					</h:outputText>
					<h:outputText value="#{process_item.selectedValueBeautified}" rendered="#{process_item.type.name != 'date'}" />
				</htm:td>
				<htm:td styleClass="standardTable_ColumnCentered">
					<%-- Bearbeiten-Schaltknopf --%>
					<h:commandLink action="ProzessverwaltungBearbeiten" title="#{msgs.bearbeiten}">
						<h:graphicImage value="/newpages/images/buttons/edit.gif" />
						<x:updateActionListener property="#{ProzessverwaltungForm.myProzess.displayProperties.currentProperty}" value="#{process_item}" />
						<x:updateActionListener property="#{ProzessverwaltungForm.modusBearbeiten}" value="eigenschaft" />
					</h:commandLink>
					<%-- duplicate --%>
					<h:commandLink action="#{ProzessverwaltungForm.myProzess.displayProperties.duplicateProperty}">
						<h:graphicImage value="/newpages/images/buttons/copy.gif" />
						<x:updateActionListener value="#{process_item}" property="#{ProzessverwaltungForm.myProzess.displayProperties.currentProperty}" />
					</h:commandLink>
				</htm:td>
			</htm:tr>
		</x:dataList>
		<htm:tr rendered="#{rowIndex + 1 < rowCount}">
			<htm:td colspan="3" styleClass="standardTable_Row1">
				<h:outputText value="&nbsp;" escape="false" />
			</htm:td>
		</htm:tr>
	</x:dataList>
</htm:table>


<%-- Neu-Schaltknopf --%>
<h:commandLink action="#{ProzessverwaltungForm.myProzess.displayProperties.createNewProperty}" value="#{msgs.eigenschaftHinzufuegen}"
	title="#{msgs.eigenschaftHinzufuegen}" rendered="#{ProzessverwaltungForm.modusBearbeiten!='eigenschaft'}">
	<x:updateActionListener property="#{ProzessverwaltungForm.modusBearbeiten}" value="eigenschaft" />
</h:commandLink>


<%-- ++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>
<%-- +++++++++++++++     Eigenschaft bearbeiten      ++++++++++++++++ --%>
<%-- ++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

<htm:h4 style="margin-top:15" rendered="#{ProzessverwaltungForm.modusBearbeiten=='eigenschaft'}">
	<h:outputText value="#{msgs.eigenschaftBearbeiten}" />
</htm:h4>
<%-- Box für die Bearbeitung der Details --%>
<htm:table cellpadding="3" cellspacing="0" width="100%" styleClass="eingabeBoxen" rendered="#{ProzessverwaltungForm.modusBearbeiten=='eigenschaft'}">

	<htm:tr>
		<htm:td styleClass="eingabeBoxen_row1" colspan="2">
			<h:outputText value="#{msgs.eigenschaft}" />
		</htm:td>
	</htm:tr>

	<%-- Formular für die Bearbeitung der Eigenschaft --%>
	<htm:tr>
		<htm:td styleClass="eingabeBoxen_row2" colspan="2">
			<x:aliasBean alias="#{myprocess_item}" value="#{ProzessverwaltungForm.myProzess.displayProperties.currentProperty}">
				<h:panelGrid columns="2">


					<%-- Felder --%>
					<h:outputLabel for="eigenschafttitel" value="#{msgs.titel}" />
					<h:panelGroup>
						<h:inputText id="eigenschafttitel" style="width: 500px;margin-right:15px"
							value="#{ProzessverwaltungForm.myProzess.displayProperties.currentProperty.titel}" required="true" />
						<x:message for="eigenschafttitel" style="color: red" detailFormat="#{msgs.keinTitelAngegeben}" />
					</h:panelGroup>



					<h:outputText value="#{msgs.wert}" />
					<%-- textarea --%>
					<h:panelGroup id="prpvw15_1" rendered="#{((myprocess_item.type.name == 'string') || (myprocess_item.type.name == 'null'))}">
						<h:inputText id="file" style="width: 500px;margin-right:15px" value="#{myprocess_item.selectedValue}" required="#{myprocess_item.required}" />
					</h:panelGroup>

					<%-- numbers only --%>
					<h:panelGroup id="prpvw15_1mnk" rendered="#{myprocess_item.type.name == 'integer' || myprocess_item.type.name == 'number'}">

						<h:inputText id="numberstuff122334mnktodo" style="width: 500px;margin-right:15px" value="#{myprocess_item.selectedValue}"
							required="#{myprocess_item.required}">
							<f:validateLongRange minimum="0" />
						</h:inputText>
					</h:panelGroup>

					<%--  SelectOneMenu --%>
					<h:panelGroup id="prpvw15_2" rendered="#{(myprocess_item.type.name == 'list')}">
						<h:selectOneMenu value="#{myprocess_item.selectedValue}" style="width: 500px;margin-right:15px" id="prpvw15_2_1">
							<si:selectItems id="prpvw15_2_2" value="#{myprocess_item.valuesList}" var="myprocess_items" itemLabel="#{myprocess_items}"
								itemValue="#{myprocess_items}" />
						</h:selectOneMenu>
					</h:panelGroup>

					<%--  SelectManyMenu --%>
					<h:panelGroup id="prpvw15_3" rendered="#{(myprocess_item.type.name == 'listmultiselect')}">
						<h:selectManyListbox id="prpvw15_3_1" style="width: 500px;margin-right:15px" value="#{myprocess_item.selectedValuesList}"
							required="#{myprocess_item.required}" size="10">
							<si:selectItems id="prpvw15_3_2" value="#{myprocess_item.valuesList}" var="myprocess_items" itemLabel="#{myprocess_items}"
								itemValue="#{myprocess_items}" />
						</h:selectManyListbox>
					</h:panelGroup>

					<%--  Boolean --%>
					<h:panelGroup id="prpvw15_4" rendered="#{(myprocess_item.type.name == 'boolean')}">
						<h:selectOneMenu value="#{myprocess_item.selectedValue}" style="width: 500px;margin-right:15px" id="prpvw15_4_1"
							required="#{myprocess_item.required}">
							<f:selectItem id="prpvw15_4_2" itemValue="true" itemLabel="#{msgs.yes}" />
							<f:selectItem id="prpvw15_4_3" itemValue="false" itemLabel="#{msgs.no}" />
						</h:selectOneMenu>
					</h:panelGroup>

					<%--  Date  --%>
					<h:panelGroup id="prpvw15_5" rendered="#{(myprocess_item.type.name == 'date')}">
						<rich:calendar id="prpvw15_5_1" style="width: 500px;margin-right:15px" datePattern="dd.MM.yyyy" value="#{myprocess_item.date}"
							enableManualInput="true">
						</rich:calendar>
					</h:panelGroup>

				</h:panelGrid>
			</x:aliasBean>
		</htm:td>
	</htm:tr>

	<htm:tr>
		<htm:td styleClass="eingabeBoxen_row3" align="left">
			<h:commandButton value="#{msgs.abbrechen}" action="#{NavigationForm.Reload}" immediate="true">
				<x:updateActionListener property="#{ProzessverwaltungForm.modusBearbeiten}" value="" />
			</h:commandButton>
		</htm:td>
		<htm:td styleClass="eingabeBoxen_row3" align="right">
			<h:commandButton value="#{msgs.loeschen}" action="#{ProzessverwaltungForm.myProzess.displayProperties.deleteProperty}"
				onclick="return confirm('#{msgs.sollDieserEintragWirklichGeloeschtWerden}?')"
				rendered="#{ProzessverwaltungForm.myProzess.displayProperties.currentProperty.id != null}">
				<x:updateActionListener property="#{ProzessverwaltungForm.modusBearbeiten}" value="" />
			</h:commandButton>
			<h:commandButton value="#{msgs.uebernehmen}" action="#{ProzessverwaltungForm.ProzessEigenschaftUebernehmen}">
				<x:updateActionListener property="#{ProzessverwaltungForm.modusBearbeiten}" value="" />
			</h:commandButton>
		</htm:td>
	</htm:tr>
</htm:table>