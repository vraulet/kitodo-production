/*
 * (c) Kitodo. Key to digital objects e. V. <contact@kitodo.org>
 *
 * This file is part of the Kitodo project.
 *
 * It is licensed under GNU General Public License version 3 or later.
 *
 * For the full copyright and license information, please read the
 * GPL3-License.txt file that was distributed with this source code.
 */

package org.kitodo.services.data;

import com.sun.research.ws.wadl.HTTPMethods;

import de.sub.goobi.config.ConfigCore;
import de.sub.goobi.helper.Helper;
import de.sub.goobi.helper.ldap.Ldap;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.Operator;
import org.elasticsearch.index.query.QueryBuilder;
import org.hibernate.Session;
import org.json.simple.parser.ParseException;
import org.kitodo.data.database.beans.Project;
import org.kitodo.data.database.beans.Property;
import org.kitodo.data.database.beans.Task;
import org.kitodo.data.database.beans.User;
import org.kitodo.data.database.beans.UserGroup;
import org.kitodo.data.database.exceptions.DAOException;
import org.kitodo.data.database.persistence.HibernateUtilOld;
import org.kitodo.data.database.persistence.UserDAO;
import org.kitodo.data.database.persistence.apache.MySQLHelper;
import org.kitodo.data.elasticsearch.exceptions.CustomResponseException;
import org.kitodo.data.elasticsearch.index.Indexer;
import org.kitodo.data.elasticsearch.index.type.UserType;
import org.kitodo.data.elasticsearch.search.SearchResult;
import org.kitodo.data.elasticsearch.search.Searcher;
import org.kitodo.data.encryption.DesEncrypter;
import org.kitodo.services.ServiceManager;
import org.kitodo.services.data.base.SearchService;

public class UserService extends SearchService<User> {

    private UserDAO userDAO = new UserDAO();
    private UserType userType = new UserType();
    private Indexer<User, UserType> indexer = new Indexer<>(User.class);
    private final ServiceManager serviceManager = new ServiceManager();
    private static final Logger logger = LogManager.getLogger(UserService.class);

    /**
     * Constructor with searcher's assigning.
     */
    public UserService() {
        super(new Searcher(User.class));
    }

    /**
     * Method saves object to database and insert document to the index of
     * Elastic Search.
     *
     * @param user
     *            object
     */
    public void save(User user) throws CustomResponseException, DAOException, IOException {
        userDAO.save(user);
        indexer.setMethod(HTTPMethods.PUT);
        indexer.performSingleRequest(user, userType);
    }

    /**
     * Method saves user object to database.
     *
     * @param user
     *            object
     */
    public void saveToDatabase(User user) throws DAOException {
        userDAO.save(user);
    }

    /**
     * Method saves user document to the index of Elastic Search.
     *
     * @param user
     *            object
     */
    public void saveToIndex(User user) throws CustomResponseException, IOException {
        indexer.setMethod(HTTPMethods.PUT);
        indexer.performSingleRequest(user, userType);
    }

    /**
     * Method saves user groups, properties and tasks related to modified user.
     *
     * @param user
     *            object
     */
    protected void saveDependenciesToIndex(User user) throws CustomResponseException, IOException {
        for (UserGroup userGroup : user.getUserGroups()) {
            serviceManager.getUserGroupService().saveToIndex(userGroup);
        }

        for (Project project : user.getProjects()) {
            serviceManager.getProjectService().saveToIndex(project);
        }

        for (Property property : user.getProperties()) {
            serviceManager.getPropertyService().saveToIndex(property);
        }

        for (Task task : user.getTasks()) {
            serviceManager.getTaskService().saveToIndex(task);
        }
    }

    public User find(Integer id) throws DAOException {
        return userDAO.find(id);
    }

    public List<User> findAll() throws DAOException {
        return userDAO.findAll();
    }

    /**
     * Method removes user object from database.
     *
     * @param user
     *            object
     */
    public void removeFromDatabase(User user) throws DAOException {
        userDAO.remove(user);
    }

    /**
     * Method removes user object from database.
     *
     * @param id
     *            of template object
     */
    public void removeFromDatabase(Integer id) throws DAOException {
        userDAO.remove(id);
    }

    /**
     * Method removes user object from index of Elastic Search.
     *
     * @param user
     *            object
     */
    public void removeFromIndex(User user) throws CustomResponseException, IOException {
        indexer.setMethod(HTTPMethods.DELETE);
        indexer.performSingleRequest(user, userType);
    }

    public List<User> search(String query) throws DAOException {
        return userDAO.search(query);
    }

    public List<User> search(String query, String parameter) throws DAOException {
        return userDAO.search(query, parameter);
    }

    public List<User> search(String query, String namedParameter, String parameter) throws DAOException {
        return userDAO.search(query, namedParameter, parameter);
    }

    public Long count(String query) throws DAOException {
        return userDAO.count(query);
    }

    /**
     * Find users with exact name.
     *
     * @param name
     *            of the searched user
     * @return list of search results
     */
    public List<SearchResult> findByName(String name) throws CustomResponseException, IOException, ParseException {
        QueryBuilder query = createSimpleQuery("name", name, true, Operator.AND);
        return searcher.findDocuments(query.toString());
    }

    /**
     * Find users with exact surname.
     *
     * @param surname
     *            of the searched user
     * @return list of search results
     */
    public List<SearchResult> findBySurname(String surname)
            throws CustomResponseException, IOException, ParseException {
        QueryBuilder query = createSimpleQuery("surname", surname, true, Operator.AND);
        return searcher.findDocuments(query.toString());
    }

    /**
     * Find users with exact full name.
     *
     * @param name
     *            of the searched user
     * @param surname
     *            of the searched user
     * @return list of search results
     */
    public List<SearchResult> findByFullName(String name, String surname)
            throws CustomResponseException, IOException, ParseException {
        BoolQueryBuilder query = new BoolQueryBuilder();
        query.must(createSimpleQuery("name", name, true, Operator.AND));
        query.must(createSimpleQuery("surname", surname, true, Operator.AND));
        return searcher.findDocuments(query.toString());
    }

    /**
     * Find user with exact login.
     *
     * @param login
     *            of the searched user
     * @return search results
     */
    public SearchResult findByLogin(String login) throws CustomResponseException, IOException, ParseException {
        QueryBuilder query = createSimpleQuery("login", login, true, Operator.AND);
        return searcher.findDocument(query.toString());
    }

    /**
     * Find user with exact LDAP login.
     *
     * @param ldapLogin
     *            of the searched user
     * @return search result
     */
    public SearchResult findByLdapLogin(String ldapLogin) throws CustomResponseException, IOException, ParseException {
        QueryBuilder query = createSimpleQuery("ldapLogin", ldapLogin, true, Operator.AND);
        return searcher.findDocument(query.toString());
    }

    /**
     * Find active or inactive users.
     *
     * @param active
     *            true -active user or false - inactive user
     * @return list of search results
     */
    public List<SearchResult> findByActive(boolean active) throws CustomResponseException, IOException, ParseException {
        QueryBuilder query = createSimpleQuery("active", String.valueOf(active), true, Operator.AND);
        return searcher.findDocuments(query.toString());
    }

    /**
     * Find users with exact location.
     *
     * @param location
     *            of the searched user
     * @return list of search results
     */
    public List<SearchResult> findByLocation(String location)
            throws CustomResponseException, IOException, ParseException {
        QueryBuilder query = createSimpleQuery("location", location, true, Operator.AND);
        return searcher.findDocuments(query.toString());
    }

    /**
     * Find users with exact metadata language.
     *
     * @param metadataLanguage
     *            of the searched user
     * @return list of search results
     */
    public List<SearchResult> findByMetadataLanguage(String metadataLanguage)
            throws CustomResponseException, IOException, ParseException {
        QueryBuilder query = createSimpleQuery("metadataLanguage", metadataLanguage, true, Operator.AND);
        return searcher.findDocuments(query.toString());
    }

    /**
     * Find users by id of user group.
     *
     * @param id
     *            of user group
     * @return list of search results with users for specific user group id
     */
    public List<SearchResult> findByUserGroupId(Integer id)
            throws CustomResponseException, IOException, ParseException {
        QueryBuilder query = createSimpleQuery("userGroups.id", id, true);
        return searcher.findDocuments(query.toString());
    }

    /**
     * Find users by title of user group.
     *
     * @param title
     *            of user group
     * @return list of search results with users for specific user group title
     */
    public List<SearchResult> findByUserGroupTitle(String title)
            throws CustomResponseException, IOException, ParseException {
        List<SearchResult> users = new ArrayList<>();

        List<SearchResult> userGroups = serviceManager.getUserGroupService().findByTitle(title, true);
        for (SearchResult userGroup : userGroups) {
            users.addAll(findByUserGroupId(userGroup.getId()));
        }
        return users;
    }

    /**
     * Find users by property.
     *
     * @param title
     *            of property
     * @param value
     *            of property
     * @return list of search results with users for specific property
     */
    public List<SearchResult> findByProperty(String title, String value)
            throws CustomResponseException, IOException, ParseException {
        List<SearchResult> users = new ArrayList<>();

        List<SearchResult> properties = serviceManager.getPropertyService().findByTitleAndValue(title, value);
        for (SearchResult property : properties) {
            users.addAll(findByPropertyId(property.getId()));
        }
        return users;
    }

    /**
     * Simulate relationship between property and user type.
     *
     * @param id
     *            of property
     * @return list of search results with users for specific property id
     */
    private List<SearchResult> findByPropertyId(Integer id)
            throws CustomResponseException, IOException, ParseException {
        QueryBuilder query = createSimpleQuery("properties.id", id, true);
        return searcher.findDocuments(query.toString());
    }

    /**
     * Method adds all object found in database to Elastic Search index.
     */
    public void addAllObjectsToIndex() throws CustomResponseException, DAOException, InterruptedException, IOException {
        indexer.setMethod(HTTPMethods.PUT);
        indexer.performMultipleRequests(findAll(), userType);
    }

    /**
     * Get the current object for this row.
     *
     * @return the current object representing a row.
     */
    public User getCurrent(User user) {
        boolean hasOpen = HibernateUtilOld.hasOpenSession();
        Session session = Helper.getHibernateSession();

        User current = (User) session.get(User.class, user.getId());
        if (current == null) {
            current = (User) session.load(User.class, user.getId());
        }
        if (!hasOpen) {
            session.close();
        }
        return current;
    }

    /**
     * Table size.
     *
     * @return table size
     */
    public Integer getTableSize(User user) {
        if (user.getTableSize() == null) {
            return Integer.valueOf(10);
        }
        return user.getTableSize();
    }

    /**
     * Session timeout.
     *
     * @return session timeout
     */
    public Integer getSessionTimeout(User user) {
        if (user.getSessionTimeout() == null) {
            user.setSessionTimeout(7200);
        }
        return user.getSessionTimeout();
    }

    public Integer getSessionTimeoutInMinutes(User user) {
        return user.getSessionTimeout() / 60;
    }

    /**
     * Convert session timeout to minutes.
     *
     * @param user
     *            object
     * @param sessionTimeout
     *            in minutes
     */
    public void setSessionTimeoutInMinutes(User user, Integer sessionTimeout) {
        if (sessionTimeout < 5) {
            user.setSessionTimeout(5 * 60);
        } else {
            user.setSessionTimeout(sessionTimeout * 60);
        }
    }

    /**
     * CSS style.
     *
     * @return CSS style
     */
    public String getCss(User user) {
        if (user.getCss() == null || user.getCss().length() == 0) {
            user.setCss("/css/default.css");
        }
        return user.getCss();
    }

    /**
     * Get size of user group result.
     *
     * @param user
     *            object
     * @return size
     */
    public int getUserGroupSize(User user) {
        if (user.getUserGroups() == null) {
            return 0;
        } else {
            return user.getUserGroups().size();
        }
    }

    /**
     * Get size of steps result list.
     *
     * @param user
     *            object
     * @return result size of steps
     */
    public int getTasksSize(User user) {
        if (user.getTasks() == null) {
            return 0;
        } else {
            return user.getTasks().size();
        }
    }

    /**
     * Get size of processing steps result list.
     *
     * @param user
     *            object
     * @return result size of processing steps
     */
    public int getProcessingTasksSize(User user) {
        if (user.getProcessingTasks() == null) {
            return 0;
        } else {
            return user.getProcessingTasks().size();
        }
    }

    /**
     * Get size of projects result list.
     *
     * @param user
     *            object
     * @return result size of projects
     *
     */
    public int getProjectsSize(User user) {
        if (user.getProjects() == null) {
            return 0;
        } else {
            return user.getProjects().size();
        }
    }

    /**
     * Get properties list size.
     *
     * @param user
     *            object
     * @return properties list size
     */
    public int getPropertiesSize(User user) {
        if (user.getProperties() == null) {
            return 0;
        } else {
            return user.getProperties().size();
        }
    }

    // TODO: check if this class should be here or in some other place
    public boolean isPasswordCorrect(User user, String inputPassword) {
        if (inputPassword == null || inputPassword.length() == 0) {
            return false;
        } else {
            if (ConfigCore.getBooleanParameter("ldap_use")) {
                Ldap ldap = new Ldap();
                return ldap.isUserPasswordCorrect(user, inputPassword);
            } else {
                DesEncrypter encrypter = new DesEncrypter();
                String encoded = encrypter.encrypt(inputPassword);
                return user.getPassword().equals(encoded);
            }
        }
    }

    public String getFullName(User user) {
        return user.getSurname() + ", " + user.getName();
    }

    /**
     * Get user home directory (either from the LDAP or directly from the
     * configuration). If LDAP is used, find home directory there, otherwise in
     * configuration.
     *
     * @return path as String
     * @throws InterruptedException
     *             add description
     * @throws IOException
     *             add description
     */
    public String getHomeDirectory(User user) throws IOException, InterruptedException {
        String result;
        if (ConfigCore.getBooleanParameter("ldap_use")) {
            Ldap ldap = new Ldap();
            result = ldap.getUserHomeDirectory(user);
        } else {
            result = ConfigCore.getParameter("dir_Users") + user.getLogin();
        }

        if (result.equals("")) {
            return "";
        }

        if (!result.endsWith(File.separator)) {
            result += File.separator;
        }
        // if the directory is not "", but does not yet exist, then create it
        // now
        serviceManager.getFileService().createDirectoryForUser(result, user.getLogin());
        return result;
    }

    /**
     * Adds a new filter to list.
     *
     * @param inputFilter
     *            the filter to add
     */
    public void addFilter(int userId, String inputFilter) {
        if (getFilters(userId).contains(inputFilter)) {
            return;
        }
        try {
            MySQLHelper.addFilterToUser(userId, inputFilter);
        } catch (SQLException e) {
            logger.error("Cannot not add filter to user with id " + userId, e);
        }

    }

    /**
     * Removes filter from list.
     *
     * @param inputFilter
     *            the filter to remove
     */
    public void removeFilter(int userId, String inputFilter) {
        if (!getFilters(userId).contains(inputFilter)) {
            return;
        }
        try {
            MySQLHelper.removeFilterFromUser(userId, inputFilter);
        } catch (SQLException e) {
            logger.error("Cannot not remove filter from user with id " + userId, e);
        }

    }

    /**
     * Get list of filters.
     *
     * @param userId
     *            object
     * @return List of filters as strings
     */
    public List<String> getFilters(int userId) {
        List<String> answer = new ArrayList<>();
        try {
            answer = MySQLHelper.getFilterForUser(userId);
        } catch (SQLException e) {
            logger.error("Cannot not load filter for user with id " + userId, e);
        }

        return answer;
    }
}
