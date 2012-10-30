/*
 * This file is part of the Goobi Application - a Workflow tool for the support of
 * mass digitization.
 *
 * Visit the websites for more information.
 *	   - http://gdz.sub.uni-goettingen.de
 *	   - http://www.goobi.org
 *	   - http://launchpad.net/goobi-production
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU General Public License for more details. You
 * should have received a copy of the GNU General Public License along with this
 * program; if not, write to the Free Software Foundation, Inc., 59 Temple Place,
 * Suite 330, Boston, MA 02111-1307 USA
 */

package org.goobi.production.flow.statistics.enums;

import de.sub.goobi.helper.Messages;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class CalculationUnitTest{

	@Test
	public final void testGetId() {
		assertEquals("1",CalculationUnit.volumes.getId());
		assertEquals("2",CalculationUnit.pages.getId());
		assertEquals("3",CalculationUnit.volumesAndPages.getId());
		
	}

	@Test
	public final void shouldReturnTranslatedTitle() {
		assertEquals(Messages.getString("volumes"), CalculationUnit.volumes.getTitle());
		assertEquals(Messages.getString("pages"), CalculationUnit.pages.getTitle());
		assertEquals(Messages.getString("volumesAndPages"), CalculationUnit.volumesAndPages.getTitle());
	}

	@Test
	public final void testGetById() {
		assertEquals(CalculationUnit.volumes,CalculationUnit.getById("1"));
		assertEquals(CalculationUnit.pages,CalculationUnit.getById("2"));
		assertEquals(CalculationUnit.volumesAndPages,CalculationUnit.getById("3"));
		
	
	}

}