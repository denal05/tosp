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
