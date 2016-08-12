<!--
The Online Spreadsheet Project
Copyleft (C) 2003-2006 Denis Aleksandrov tosp05@gmail.com

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
-->

<HTML>
<HEAD>
  <TITLE>File Rename:</TITLE>
  <LINK REL=STYLESHEET TYPE="text/css" HREF="/tosp/basic.css" TITLE="general">
</HEAD>
<BODY>
<%@ page import="java.sql.*" %>
<%
  session = request.getSession( true );
  String username;
  String password;
  String table = new String();
  java.util.Enumeration parameterNames = request.getParameterNames();
  while(parameterNames.hasMoreElements())
  {
    String element = (String) parameterNames.nextElement();
//**/out.println( "element=\""+element+"\"<BR>" );
    if ( request.getParameter( element ).equals("on"))
      table = element;
  }
  synchronized( session )
  {
    username = (String) session.getValue( "username" );
    password = (String) session.getValue( "password" );
    session.putValue( "table", table );
  }

  if( !table.equals("") && !table.equals("null") )
    out.println("<META HTTP-EQUIV=\"Refresh\" CONTENT=\"0;url=/tosp/jsp/spreadsheet.jsp\">");
  else try
  {
    Class.forName("org.gjt.mm.mysql.Driver").newInstance();
    Connection connection = DriverManager.getConnection("jdbc:mysql:///" + username, username, password );
    DatabaseMetaData dbMetaData = connection.getMetaData();
    Statement statement = connection.createStatement();
    ResultSet rs = statement.executeQuery("SHOW TABLES;");
    ResultSetMetaData rm = rs.getMetaData();
%>
<FORM NAME="rename" ACTION="/tosp/jsp/menu/Open.jsp">
<TABLE ALIGN="Left">
  <TR>
<%
    out.println( "    <TD ALIGN=\"Left\" BGCOLOR=\"#111111\"><FONT FACE=\"Times\"><I>" + rm.getColumnName(1) + "</I>" );
%>
  </TR>
<%
    while( rs.next() )
    {
      out.println( "  <TR>" );
      out.print( "    <TD BGCOLOR=\"#111111\"><FONT FACE=\"Courier\" SIZE=1>" + rs.getString(1) );
      out.print( "    <TD BGCOLOR=\"#111111\"><INPUT TYPE=\"Checkbox\" NAME=\"" + rs.getString(1) + "\">" );
      out.println( "\n  </TR>" );
    }
    if (rs != null) rs.close();
    if (statement != null) statement.close();
    if (connection != null) connection.close();
%>
  <TR>
    <TD>
      <INPUT TYPE="Submit" Name="ok" VALUE="Open">
    </TD>
  </TR>
</TABLE>
</FORM>
</BODY>
</HTML>
<%
  } catch (ClassNotFoundException e) {
      out.println("ClassNotFoundException --> Error loading driver: "+e);
  } catch (SQLException e) {
      out.println("SQLException --> Error connection: "+e);
  } catch (Exception e) {
      out.println("Exception occurred: "+e);
  }
%>
