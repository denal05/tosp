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
    <TITLE>Edit Find:</TITLE>
    <LINK REL=STYLESHEET TYPE="text/css" HREF="/tosp/tosp.css" TITLE="general">
  </HEAD>
<BODY BGCOLOR="#222222" TEXT="#FFFFFF" LINK="#009900" VLINK="#999999">
<FONT FACE="Courier" SIZE=1>
<%@ page import="java.sql.*" %>
<%
  session = request.getSession( true );
  String username;
  String password;
  String table;
  synchronized( session )
  {
    username = (String) session.getValue( "username" );
    password = (String) session.getValue( "password" );
    table = (String) session.getValue( "table" );
  }
  try
  {
    Class.forName("org.gjt.mm.mysql.Driver").newInstance();
    Connection connection = DriverManager.getConnection("jdbc:mysql:///" + username, username, password );
    DatabaseMetaData dbMetaData = connection.getMetaData();
    Statement statement = connection.createStatement();
    ResultSet rs = statement.executeQuery("SELECT * FROM " + table + ";");
    ResultSetMetaData rm = rs.getMetaData();
    int columnCount = rm.getColumnCount();

    String find = request.getParameter( "find" );
    String filter = request.getParameter( "filter" );
    String[] query = new String[ columnCount + 1];
    for( int i=2; i <= columnCount; i++ )
    {
      query[i] = "SELECT row FROM " + table + " WHERE " + rm.getColumnName(i) + " LIKE ";
      if( filter.equals( "begins" ) )
        query[i] += "\"" + find + "%\";";
      if( filter.equals( "contains" ) )
        query[i] += "\"%" + find + "%\";";
      if( filter.equals( "ends" ) )
        query[i] += "\"%" + find + "\";";
    }
////out.println( i + " " + query );
    for( int i=2; i <= columnCount; i++ )
    {
      ResultSet f = statement.executeQuery( query[i] );
      while( f.next() )
      {
        out.println( rm.getColumnName(i) + f.getString(1) + " " );
      }
    }

    if (rs != null) rs.close();
    if (statement != null) statement.close();
    if (connection != null) connection.close();
  } catch (ClassNotFoundException e) {
      out.println("ClassNotFoundException --> Error loading driver: "+e);
  } catch (SQLException e) {
      out.println("<H3>Did you open a table first by going to File Open?</H3>\n");
      out.println("SQLException --> Error connection: "+e);
  } catch (Exception e) {
      out.println("Exception occurred: "+e);
  }
%>
</BODY>
</HTML>
