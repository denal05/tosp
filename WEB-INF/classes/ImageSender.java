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
 * @compile     javac -classpath ../lib/servlet.jar:../lib/Acme.jar ImageSender.java
 * @date        Spring 2003
 * @author      denal05@gmail.com
 */

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.awt.*;
import java.awt.geom.*;
import Acme.JPM.Encoders.*;
import java.util.*;

/**
 * Demonstrates how to send Java graphics as gif image to the client
 * Refer to pages 168~169 of textbook for more explanation
 * @author  Dr. Hong Sung, University of Central Oklahoma
 * @date Spring 2003, WSP
 */
public class ImageSender extends HttpServlet {
    
    /** Initializes the servlet.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        
    }
    
    /** Destroys the servlet.
     */
    public void destroy() {
        
    }
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        int sum=0, i=0;

        response.setContentType("image/gif");
        
        Frame f = new Frame();
        f.addNotify(); // use native window object
        Image img = f.createImage( (10 * Integer.parseInt( request.getParameter("tn") ) + 20), 100);
        Graphics g = img.getGraphics();
        Graphics2D g2 = (Graphics2D) g;

	  for( i=0; i < Integer.parseInt( request.getParameter("tn") ); i++ )
	  {     
            sum += Integer.parseInt( request.getParameter("s" + (i+1)) );

            Rectangle2D.Double r1 = new Rectangle2D.Double(i*10, (100 - Integer.parseInt( request.getParameter("s" + (i+1)) )), 10, Integer.parseInt( request.getParameter("s" + (i+1)) ) );

            String cv = new String( request.getParameter( "c" + (i+1) ) );
            if( cv.equals("blue") )
                g2.setColor(Color.blue);
            else
                g2.setColor(Color.yellow);

            g2.fill(r1);
	  }
        Rectangle2D.Double r2 = new Rectangle2D.Double( (i * 10 + 10), (100 - ( sum / Integer.parseInt( request.getParameter("tn") ) ) ), 10, ( sum / Integer.parseInt( request.getParameter("tn") ) ) );
        g2.setColor(Color.red);
        g2.fill(r2);

        OutputStream out = response.getOutputStream();

        try {
             new GifEncoder(img, out).encode(); // from Acme package
        } catch (IOException e) {
            System.out.println("GifEncode error");
        }
    }
    
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        processRequest(request, response);
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        processRequest(request, response);
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
    
}
