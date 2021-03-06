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

package de.sub.goobi.export.download;

import de.sub.goobi.config.ConfigCore;
import de.sub.goobi.helper.Helper;
import de.sub.goobi.helper.tasks.CreatePdfFromServletThread;
import de.sub.goobi.metadaten.MetadatenHelper;
import de.sub.goobi.metadaten.MetadatenVerifizierung;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.util.TreeSet;

import javax.faces.context.FacesContext;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.httpclient.methods.GetMethod;
import org.goobi.io.FileListFilter;
import org.kitodo.data.database.beans.Process;
import org.kitodo.data.database.exceptions.DAOException;
import org.kitodo.data.database.exceptions.SwapException;
import org.kitodo.services.ServiceManager;
import org.kitodo.services.file.FileService;

import ugh.dl.Fileformat;
import ugh.exceptions.PreferencesException;
import ugh.exceptions.ReadException;
import ugh.exceptions.TypeNotAllowedForParentException;
import ugh.exceptions.WriteException;

public class ExportPdf extends ExportMets {
    private final ServiceManager serviceManager = new ServiceManager();
    private static final String AND_TARGET_FILE_NAME_IS = "&targetFileName=";
    private static final String PDF_EXTENSION = ".pdf";
    private final FileService fileService = serviceManager.getFileService();

    @Override
    public boolean startExport(Process myProcess, String inZielVerzeichnis)
            throws InterruptedException, ReadException, IOException, SwapException, DAOException, PreferencesException,
            TypeNotAllowedForParentException, WriteException {

        /*
         * Read Document
         */
        Fileformat gdzfile = serviceManager.getProcessService().readMetadataFile(myProcess);
        String zielVerzeichnis = prepareUserDirectory(inZielVerzeichnis);
        this.myPrefs = serviceManager.getRulesetService().getPreferences(myProcess.getRuleset());

        /*
         * first of all write mets-file in images-Folder of process
         */
        File metsTempFile = File.createTempFile(myProcess.getTitle(), ".xml");
        writeMetsFile(myProcess, metsTempFile.toString(), gdzfile, true);
        Helper.setMeldung(null, myProcess.getTitle() + ": ", "mets file created");
        Helper.setMeldung(null, myProcess.getTitle() + ": ", "start pdf generation now");

        if (logger.isDebugEnabled()) {
            logger.debug("METS file created: " + metsTempFile);
        }

        FacesContext context = FacesContext.getCurrentInstance();
        HttpServletRequest req = (HttpServletRequest) context.getExternalContext().getRequest();
        String fullpath = req.getRequestURL().toString();
        String servletpath = context.getExternalContext().getRequestServletPath();
        String myBasisUrl = fullpath.substring(0, fullpath.indexOf(servletpath));

        if (!ConfigCore.getBooleanParameter("pdfAsDownload")) {
            /*
             * use contentserver api for creation of pdf-file
             */
            CreatePdfFromServletThread pdf = new CreatePdfFromServletThread();
            pdf.setMetsURL(metsTempFile.toURI().toURL());
            pdf.setTargetFolder(new File(zielVerzeichnis));
            pdf.setInternalServletPath(myBasisUrl);
            if (logger.isDebugEnabled()) {
                logger.debug("Taget directory: " + zielVerzeichnis);
                logger.debug("Using ContentServer2 base URL: " + myBasisUrl);
            }
            pdf.initialize(myProcess);
            pdf.start();
        } else {

            GetMethod method = null;
            try {
                /*
                 * define path for mets and pdfs
                 */
                URL kitodoContentServerUrl = null;
                String contentServerUrl = ConfigCore.getParameter("kitodoContentServerUrl");
                Integer contentServerTimeOut = ConfigCore.getIntParameter("kitodoContentServerTimeOut", 60000);

                /*
                 * using mets file
                 */

                if (new MetadatenVerifizierung().validate(myProcess) && metsTempFile.toURI().toURL() != null) {
                    /*
                     * if no contentserverurl defined use internal
                     * goobiContentServerServlet
                     */
                    if (contentServerUrl == null || contentServerUrl.length() == 0) {
                        contentServerUrl = myBasisUrl + "/gcs/gcs?action=pdf&metsFile=";
                    }
                    kitodoContentServerUrl = new URL(contentServerUrl + metsTempFile.toURI().toURL()
                            + AND_TARGET_FILE_NAME_IS + myProcess.getTitle() + PDF_EXTENSION);
                    /*
                     * mets data does not exist or is invalid
                     */

                } else {
                    if (contentServerUrl == null || contentServerUrl.length() == 0) {
                        contentServerUrl = myBasisUrl + "/cs/cs?action=pdf&images=";
                    }
                    FilenameFilter filter = new FileListFilter("\\d*\\.tif");
                    File imagesDir = new File(
                            serviceManager.getProcessService().getImagesTifDirectory(true, myProcess));
                    File[] meta = fileService.listFiles(filter, imagesDir);
                    int capacity = contentServerUrl.length() + (meta.length - 1) + AND_TARGET_FILE_NAME_IS.length()
                            + myProcess.getTitle().length() + PDF_EXTENSION.length();
                    TreeSet<String> filenames = new TreeSet<String>(new MetadatenHelper(null, null));
                    for (File data : meta) {
                        String file = data.toURI().toURL().toString();
                        filenames.add(file);
                        capacity += file.length();
                    }
                    StringBuilder url = new StringBuilder(capacity);
                    url.append(contentServerUrl);
                    boolean subsequent = false;
                    for (String f : filenames) {
                        if (subsequent) {
                            url.append('$');
                        } else {
                            subsequent = true;
                        }
                        url.append(f);
                    }
                    url.append(AND_TARGET_FILE_NAME_IS);
                    url.append(myProcess.getTitle());
                    url.append(PDF_EXTENSION);
                    kitodoContentServerUrl = new URL(url.toString());
                }

                /*
                 * get pdf from servlet and forward response to file
                 */
                method = new GetMethod(kitodoContentServerUrl.toString());
                method.getParams().setParameter("http.socket.timeout", contentServerTimeOut);

                if (!context.getResponseComplete()) {
                    HttpServletResponse response = (HttpServletResponse) context.getExternalContext().getResponse();
                    String fileName = myProcess.getTitle() + PDF_EXTENSION;
                    ServletContext servletContext = (ServletContext) context.getExternalContext().getContext();
                    String contentType = servletContext.getMimeType(fileName);
                    response.setContentType(contentType);
                    response.setHeader("Content-Disposition", "attachment;filename=\"" + fileName + "\"");
                    response.sendRedirect(kitodoContentServerUrl.toString());
                    context.responseComplete();
                }
                if (metsTempFile.toURI().toURL() != null) {
                    File tempMets = new File(metsTempFile.toURI().toURL().toString());
                    tempMets.delete();
                }
            } catch (Exception e) {

                /*
                 * report Error to User as Error-Log
                 */
                String text = "error while pdf creation: " + e.getMessage();
                File file = new File(zielVerzeichnis, myProcess.getTitle() + ".PDF-ERROR.log");
                try (BufferedWriter output = new BufferedWriter(
                        new OutputStreamWriter(fileService.write(file.toURI())))) {
                    output.write(text);
                } catch (IOException e1) {
                }
                return false;
            } finally {
                if (method != null) {
                    method.releaseConnection();
                }
            }
        }
        return true;
    }
}
