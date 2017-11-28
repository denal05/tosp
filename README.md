# tosp
The Online Spreadsheet Project

02/15/06 - 20:26 

v2.0

DONE:
- Accomplished outputing PNG file from gnuplot through the servlet binOutput.java in the package gnuplot.

TODO:
- Fix bug in gnuplot script generation when getting data horizontally from the spreadsheet.
- Fix Javascript incompatibilities with Netscape / Mozilla.

NOTE:
- To compile servlets you have to use the option -classpath and include the servlet.jar from WEB-INF/lib:
javac -classpath ../../lib/servlet.jar binOutput.java 

- To run servlets successfully you need to reload (stop and start) the web container for TOSP by using the manager:
http://example.com:8080/manager/html/

- To change you administrator/manager password use the admin page:
http://example.com:8080/admin/

- Security bug fixed.

----

The Online Spreadsheet Project is an open-source project, where anyone can register for free and use a spreadsheet-like application, with functionality like the OpenOffice.org Calc or the Microsoft Excel. It is powered by Tomcat, Java, and MySQL. TOSP v2.0 employs gnuplot to draw the function graphs. A preview of the use of gnuplot is on the home page. Here is a demo of the power of gnuplot. This began as a final project in my Web Server Programming class, taught by Dr. Hong Sung. Since it is concentrated on server-side programming, there is no fancy stuff, although the idea of this project has a great potential. By using client-side programming like AJAX, Java applets or scripting languages, this could look just like any other application. A sample applet that comes as a demo with J2SDK is a proof of the power of client-side programming using a Java applet. There are plenty of client-side (javascript/applet) online spreadsheets that other people have written. The best example of the power of Java and the JavaServerPages technology is "webMathematica".

All of the data in The Online SpreadSheet Project is stored in a MySQL database on the server. The good side is that users don't need to save it on their own computer; the bad side is that if they wanted to save it, it was not designed as such (for example, in XML format). However, users can save a snapshot of their spreadsheet as a webpage or print it out.


The class "Web Server Programming" was a senior-level seminar, offered at the Computer Science Department at our University of Central Oklahoma. In this class we used servlets, Java Server Pages, and MySQL to design dynamic web pages. Full text and code from the textbook can be found at www.CoreServlets.com


Google Labs came out with Google Docs and it has a perfect combination of server-side and client-side programming, thanks to the AJAX technology. It has the best example of a full-throttle spreadsheet, served online, and for free. You just have to check it out. It's the next coolest thing to come out after Google SMS.


Dan Bricklin, the co-author of the original spreadsheet VisiCalc, is developing wikiCalc. This is a very cool web-authoring tool that has a spreadsheet user interface and is used to create web pages. It can be used either client-side or server-side, making it perfect for everyone. Check it out. Right now he only has a Windows port, but more is coming up.
