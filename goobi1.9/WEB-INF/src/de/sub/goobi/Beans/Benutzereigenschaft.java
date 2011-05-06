package de.sub.goobi.Beans;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.goobi.production.api.property.xmlbasedprovider.Status;

import de.sub.goobi.Beans.Property.IGoobiEntity;
import de.sub.goobi.Beans.Property.IGoobiProperty;
import de.sub.goobi.helper.enums.PropertyType;

public class Benutzereigenschaft implements Serializable, IGoobiProperty {
	private static final long serialVersionUID = -2356566712752716107L;

	private Benutzer benutzer;
	private Integer id;
	private String titel;
	private String wert;
	private Boolean istObligatorisch;
	private Integer datentyp;
	private String auswahl;
	private Date creationDate;

	public Benutzereigenschaft() {
		istObligatorisch = false;
		datentyp = PropertyType.String.getId();
		creationDate = new Date();
	}

	private List<String> valueList;

	public String getAuswahl() {
		return auswahl;
	}

	public void setAuswahl(String auswahl) {
		this.auswahl = auswahl;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Boolean isIstObligatorisch() {
		if (istObligatorisch == null) {
			istObligatorisch = false;
		}
		return istObligatorisch;
	}

	public void setIstObligatorisch(Boolean istObligatorisch) {
		this.istObligatorisch = istObligatorisch;
	}

	public String getTitel() {
		return titel;
	}

	public void setTitel(String titel) {
		this.titel = titel;
	}

	public String getWert() {
		return wert;
	}

	public void setWert(String wert) {
		this.wert = wert;
	}

	public void setCreationDate(Date creation) {
		this.creationDate = creation;
	}

	public Date getCreationDate() {
		return creationDate;
	}

	/**
	 * getter for datentyp set to private for hibernate
	 * 
	 * for use in programm use getType instead
	 * 
	 * @return datentyp as integer
	 */
	@SuppressWarnings("unused")
	private Integer getDatentyp() {
		return datentyp;
	}

	/**
	 * set datentyp to defined integer. only for internal use through hibernate, for changing datentyp use setType instead
	 * 
	 * @param datentyp
	 *            as Integer
	 */
	@SuppressWarnings("unused")
	private void setDatentyp(Integer datentyp) {
		this.datentyp = datentyp;
	}

	/**
	 * set datentyp to specific value from {@link PropertyType}
	 * 
	 * @param inType
	 *            as {@link PropertyType}
	 */
	public void setType(PropertyType inType) {
		this.datentyp = inType.getId();
	}

	/**
	 * get datentyp as {@link PropertyType}
	 * 
	 * @return current datentyp
	 */
	public PropertyType getType() {
		if (datentyp == null) {
			datentyp = PropertyType.String.getId();
		}
		return PropertyType.getById(datentyp);
	}

	public List<String> getValueList() {
		if (valueList == null) {
			valueList = new ArrayList<String>();
		}
		return valueList;
	}

	public void setValueList(List<String> valueList) {
		this.valueList = valueList;
	}

	/**
	 * 
	 * @return user (owner) of property
	 */

	public Benutzer getBenutzer() {
		return benutzer;
	}

	/**
	 * sets the user(owner) of property
	 * @param benutzer
	 */
	
	public void setBenutzer(Benutzer benutzer) {
		this.benutzer = benutzer;
	}

	/**
	 * @exception UnsupportedOperationException
	 */
	public Status getStatus() {
		throw new UnsupportedOperationException();
	}

	/**
	 * @exception UnsupportedOperationException
	 */
	public IGoobiEntity getOwningEntity() {
		throw new UnsupportedOperationException();
	}
	
	/**
	 * @exception UnsupportedOperationException
	 */
	public void setOwningEntity(IGoobiEntity inEntity) {
		throw new UnsupportedOperationException();
	}

	public Integer getContainer() {
		return 0;
	}

	public void setContainer(Integer order) {
		
	}

	@Override
	public String getNormalizedTitle() {
		return titel.replace(" ", "_").trim();
	}

	@Override
	public String getNormalizedValue() {
		return wert.replace(" ", "_").trim();
	}
	

		
	

}