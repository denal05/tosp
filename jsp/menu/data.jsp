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

  String submenu = request.getParameter( "submenu" );

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

    if( submenu.equals( "sort" ) )
    {
      String sort = request.getParameter( "sort" );
      String col = request.getParameter( "col" );
      String query = "";

      if( sort.equals( "ASCENDING" ) )
      {
        query = "SELECT " + col + " FROM " + table + " WHERE " + col + "!=\"\" ORDER BY " + col + ";";
      }
      if( sort.equals( "DESCENDING" ) )
      {
        query = "SELECT " + col + " FROM " + table + " WHERE " + col + "!=\"\" ORDER BY " + col + " DESC;";
      }
//////out.println( query + "<BR>");
      ResultSet o = statement.executeQuery( query );

      String[] update = new String[ rowCount + 1 ];
      for( int j=0; j < update.length; j++ )
        update[j] = "SELECT COUNT(*) FROM " + table + ";";
      int i=1;
      while( o.next() )
      {
        update[ i ] = "UPDATE " + table + " SET " + col + "=\"" + o.getString(1) + "\" WHERE row=\"" + i + "\";";
////////out.println( update[i] + "<BR>");
        i++;
      }

      for( int j=1; j <= rowCount; j++ )
      {
        ResultSet u = statement.executeQuery( update[j] );
      }
    }
    if( submenu.equals( "filter" ) )
    {
      String col = request.getParameter( "col" );
      String op = request.getParameter( "op" );
      String value = request.getParameter( "value" );
      String query = "";

      query = "SELECT " + col + " FROM " + table + " WHERE " + col + op + "\"" + value + "\";";
//////out.println( query + "<BR>");
      ResultSet o = statement.executeQuery( query );

      String[] update = new String[ rowCount + 1 ];
      for( int j=0; j < update.length; j++ )
        update[j] = "UPDATE " + table + " SET " + col + "=\"\" WHERE row=\"" + j + "\";";
      int i=1;
      while( o.next() )
      {
        update[ i ] = "UPDATE " + table + " SET " + col + "=\"" + o.getString(1) + "\" WHERE row=\"" + i + "\";";
////////out.println( update[i] + "<BR>");
        i++;
      }

      for( int j=1; j <= rowCount; j++ )
      {
        ResultSet u = statement.executeQuery( update[j] );
      }

    }

    out.println( "<META HTTP-EQUIV=\"Refresh\" CONTENT=\"0; url=/tosp/jsp/spreadsheet.jsp\">" );

    if (rs != null) rs.close();
    if (statement != null) statement.close();
    if (connection != null) connection.close();
  } catch (ClassNotFoundException e) {
      out.println("ClassNotFoundException --> Error loading driver: "+e);
  } catch (SQLException e) {
      out.println("SQLException --> Error connection: "+e);
  } catch (Exception e) {
      out.println("Exception occurred: "+e);
  }
%>
</BODY>
</HTML>
