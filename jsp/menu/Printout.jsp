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
<BODY BGCOLOR="#222222" TEXT="#FFFFFF" LINK="#009900" VLINK="#999999">
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
    int rowCount=0;
    while( rs.next() )
      rowCount++;

    rs = statement.executeQuery("SELECT * FROM " + table + ";");
%>
<TABLE WIDTH=100%>
  <TR>
<%
    out.println( "    <TD WIDTH=100 BGCOLOR=\"#111111\">" );
    out.println( "      <FONT FACE=\"Courier\" SIZE=1>" );
    out.println( "    </TD>" );
    for( int i = 2; i <= columnCount; i++ )
    {
      out.println( "    <TD WIDTH=100 BGCOLOR=\"#111111\">" );
      out.println( "      <FONT FACE=\"Courier\" SIZE=1>" + rm.getColumnName(i) );
      out.println( "    </TD>" );
    }
%>
  </TR>
<%
    int j=1;
    while( rs.next() )
    {
      out.println( "  <TR>" );
      out.println( "    <TD WIDTH=100 BGCOLOR=\"#111111\">" );
      out.println( "      <FONT FACE=\"Courier\" SIZE=1>" + j );
      out.println( "    </TD>" );
      for( int i = 2; i <= columnCount; i++ )
      {
        out.println( "    <TD WIDTH=100 BGCOLOR=\"#111111\">" );
        out.println( "      <FONT FACE=\"Courier\" SIZE=1>" + rs.getString(i) );
        out.println( "    </TD>" );
      }
      out.println( "  </TR>" );
      j++;
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
</TABLE>
</BODY>
</HTML>
