/**
 * This file is part of the Goobi Application - a Workflow tool for the support of mass digitization.
 * 
 * Visit the websites for more information. 
 *     		- http://www.kitodo.org
 *     		- https://github.com/goobi/goobi-production
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
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Linking this library statically or dynamically with other modules is making a combined work based on this library. Thus, the terms and conditions
 * of the GNU General Public License cover the whole combination. As a special exception, the copyright holders of this library give you permission to
 * link this library with independent modules to produce an executable, regardless of the license terms of these independent modules, and to copy and
 * distribute the resulting executable under terms of your choice, provided that you also meet, for each linked independent module, the terms and
 * conditions of the license of that module. An independent module is a module which is not derived from or based on this library. If you modify this
 * library, you may extend this exception to your version of the library, but you are not obliged to do so. If you do not wish to do so, delete this
 * exception statement from your version.
 */
package org.goobi.production.flow.statistics.hibernate;

import static org.junit.Assert.assertTrue;

import java.util.ArrayList;
import java.util.Date;

import org.goobi.production.flow.statistics.enums.TimeUnit;
import org.junit.BeforeClass;
import org.junit.Test;

public class SQLProductionTest {

	static SQLProduction sqlProd;

	@BeforeClass
	public static void setUp() throws Exception {
		ArrayList<Integer> testList = new ArrayList<Integer>();
		testList.add(15);
		testList.add(45);
		testList.add(25);
		sqlProd = new SQLProduction(new Date(64871232), new Date(66871232), TimeUnit.days, testList);
	}

	@Test
	public void testGetSQL() {
		String testStr = "SELECT count(table_1.singleProcess) AS volumes, sum(table_1.pages) AS pages, table_1.intervall FROM (SELECT prozesse.prozesseid AS singleProcess, prozesse.sortHelperImages AS pages, ";
		assertTrue(sqlProd.getSQL().contains(testStr));

	}

	@Test
	public void testGetSQLInteger() {
		String testStr = "SELECT count(table_1.singleProcess) AS volumes, sum(table_1.pages) AS pages, table_1.intervall FROM (SELECT prozesse.prozesseid AS singleProcess, prozesse.sortHelperImages AS pages, ";
		assertTrue(sqlProd.getSQL(4).contains(testStr));
	}

}