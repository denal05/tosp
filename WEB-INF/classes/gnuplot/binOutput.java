/**
 * <!--
 * The Online Spreadsheet Project
 * Copyleft (C) 2003-2006 Denis Aleksandrov denal05@gmail.com
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 * -->
 */

/**
 * @compile	javac -classpath ../../lib/servlet.jar binOutput.java
 * @date	030805-2331
 * @author	denal05@gmail.com
 */

package gnuplot;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

/** A servlet that reads a GIF file off the local system
 *  and sends it to the client with the appropriate MIME type.
 *  Includes the Content-Length header to support the
 *  use of persistent HTTP connections unless explicitly
 *  instructed not to through "usePersistence=no".
 *  Used by the PersistentConnection servlet.
 *  <P>
 *  Do <I>not</I> install this servlet permanently on
 *  a public server, as it provides access to image
 *  files that are not necessarily in the Web
 *  server path.
 *  <P>
 *  Taken from Core Servlets and JavaServer Pages
 *  from Prentice Hall and Sun Microsystems Press,
 *  http://www.coreservlets.com/.
 *  &copy; 2000 Marty Hall; may be freely used or adapted.
 */

public class binOutput extends HttpServlet {

    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
  public void doGet(HttpServletRequest request, HttpServletResponse response)
  throws ServletException, IOException, InterruptedException {

    try {
      response.setContentType("image/png");
      
      // run a shell command:
      Runtime run= Runtime.getRuntime();
      Process proc= run.exec("/usr/bin/gnuplot /usr/jakarta-tomcat-5.0.14/webapps/tosp/WEB-INF/classes/gnuplot/gnuplot.cmd");

      // get the output of the shell command process as input in the servlet:
      BufferedInputStream in = new BufferedInputStream( proc.getInputStream() );

      // prepare the output of the servlet:
      ByteArrayOutputStream byteStream = new ByteArrayOutputStream(512);

      /*
      //EVIL! Do not use! ContentLentgh is not equal to byteStream.size() so this wipes out the image!
      response.setContentLength(byteStream.size());
      */

      // read chunks of data from input into an integer and from this integer into the output:
      int imageByte;
      while((imageByte = in.read()) != -1) {
        byteStream.write(imageByte);
      }

      in.close();

      // write the complete byteStream to the output, i.e. the web page:
      byteStream.writeTo(response.getOutputStream());

    } catch(IOException ioe) {
      reportError(response, "Error: " + ioe);
    }
  }

  public void reportError(HttpServletResponse response, String message)
  throws IOException {
    response.sendError(response.SC_NOT_FOUND, message);
  }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
  throws ServletException, java.io.IOException, InterruptedException {
    doGet(request, response);
  }
    
    /** Returns a short description of the servlet.
     */
  public String getServletInfo() {
    String msg = new String();
    msg = "Adapted from Core Servlets and JavaServer Pages\n";
    msg += "from Prentice Hall and Sun Microsystems Press,\n";
    msg += "http://www.coreservlets.com/\n";
    msg += "&copy; 2000 Marty Hall\n";
    msg += "This servlet calls gnuplot from the shell (using java.lang.Runtime.exec() ) and\n";
    msg += "passes it a file argument, which is a gnuplot script that is modified by the\n";
    msg += "client. The resulting image that gnuplot creates is returned via a binary stream\n";
    msg += "( using javax.servlet.http.HttpServletResponse.getOutputStream() )to the client's browser";
    return msg;
  }

}
