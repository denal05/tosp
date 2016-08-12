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
    table    = (String) session.getValue( "table"    );
  }
  try
  {
    Class.forName("org.gjt.mm.mysql.Driver").newInstance();
    Connection connection = DriverManager.getConnection("jdbc:mysql:///" + username, username, password );
    DatabaseMetaData dbMetaData = connection.getMetaData();
    Statement statement = connection.createStatement();
    ResultSet rs = statement.executeQuery("SHOW TABLES;");
    ResultSetMetaData rm = rs.getMetaData();

    String tableName = new String();
    while( rs.next() )
    {
      java.util.Enumeration parameterNames = request.getParameterNames();
      while(parameterNames.hasMoreElements())
      {
        String element = (String) parameterNames.nextElement();
        if( request.getParameter( element ).equals( rs.getString(1) ) )
          tableName = rs.getString(1);
      }
    }

    String submenu = request.getParameter( "submenu" );
    if( submenu.equals( "new" ) )
    {
      tableName = request.getParameter( "tableName" );
      String create_table = "CREATE TABLE " + tableName + "( row INTEGER, A TEXT, B TEXT, C TEXT, D TEXT, E TEXT, F TEXT, G TEXT, H TEXT, I TEXT, J TEXT, K TEXT, L TEXT, M TEXT, N TEXT, O TEXT, P TEXT, Q TEXT, R TEXT, S TEXT, T TEXT, U TEXT, V TEXT, W TEXT, X TEXT, Y TEXT, Z TEXT );";
      rs = statement.executeQuery( create_table );

      for( int i = 1; i <= 26; i++ )
      {
        String insert_into = "INSERT INTO " + tableName + " VALUES( " + i + ", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\" );";
        rs = statement.executeQuery( insert_into );
      }
    }
    if( submenu.equals( "rename" ) )
    {
      String query = "RENAME TABLE " + tableName + " TO " + request.getParameter( "newTableName" ) + ";";
//****/out.println( query + "<BR>" );
      ResultSet r = statement.executeQuery( query );
    }
    if( submenu.equals( "delete" ) )
    {
      if( password.equals( request.getParameter( "p" ) ) )
      {
        tableName = request.getParameter( "tableName" );
        String query = "DROP TABLE " + tableName + ";";
        ResultSet d = statement.executeQuery( query );
      }
    }
    if( submenu.equals( "insrow" ) )
    {
      rs = statement.executeQuery( "SELECT * FROM " + table + ";" );
      int rowCount=0;
      while( rs.next() )
        rowCount++;
      String insert_into = "INSERT INTO " + table + " VALUES( " + (rowCount+1) + ", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\" );";
      rs = statement.executeQuery( insert_into );
    }
    if( submenu.equals( "delrow" ) )
    {
      rs = statement.executeQuery( "SELECT * FROM " + table + ";" );
      int rowCount=0;
      while( rs.next() )
        rowCount++;
      String delete_from = "DELETE FROM " + table + " WHERE row=" + rowCount + ";";
      rs = statement.executeQuery( delete_from );
    }
    if( submenu.equals( "inscol" ) )
    {
      rs = statement.executeQuery( "SELECT * FROM " + table + ";" );
      rm = rs.getMetaData();
      int columnCount = rm.getColumnCount();
      String lastCol = rm.getColumnName( columnCount );
      char lc = lastCol.charAt( lastCol.length() - 1 );
      String newCol = "";
      if( lc == 'Z' )
        for( int i=0; i <= lastCol.length(); i++ )
          newCol += 'A';
      else
      {
        for( int i=0; i < ( lastCol.length() - 1 ); i++ )
          newCol += lastCol.charAt( i );
        newCol += ++lc;
      }
      String alter_table = "ALTER TABLE " + table + " ADD COLUMN " + newCol + " TEXT;";
      rs = statement.executeQuery( alter_table );
    }
    if( submenu.equals( "delcol" ) )
    {
      rs = statement.executeQuery( "SELECT * FROM " + table + ";" );
      rm = rs.getMetaData();
      int columnCount = rm.getColumnCount();
      String lastCol = rm.getColumnName( columnCount );
      String alter_table = "ALTER TABLE " + table + " DROP COLUMN " + lastCol + ";";
      rs = statement.executeQuery( alter_table );
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
