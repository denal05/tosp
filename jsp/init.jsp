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
  <LINK REL=STYLESHEET TYPE="text/css" HREF="/tosp/basic.css" TITLE="general">
</HEAD>
<BODY>
<%@ page import="java.sql.*" %>
<%
  session = request.getSession( true );
  String username;
  String password;
  String table = "untitled";
  synchronized( session )
  {
    username = (String) session.getValue( "username" );
    password = (String) session.getValue( "password" );
    session.putValue( "table", table );
  }
  try
  {
    Class.forName("org.gjt.mm.mysql.Driver").newInstance();
    Connection connection = DriverManager.getConnection("jdbc:mysql:///mysql", "root", "alex2665" );
    DatabaseMetaData dbMetaData = connection.getMetaData();
    Statement statement = connection.createStatement();
    ResultSet rs = statement.executeQuery( "DELETE FROM user WHERE User='';" );
    rs = statement.executeQuery( "CREATE DATABASE " + username + ";" );
    rs = statement.executeQuery( "GRANT ALL PRIVILEGES ON " + username + ".* TO " + username + "@localhost IDENTIFIED BY '" + password + "' WITH GRANT OPTION;" );
    rs = statement.executeQuery( "GRANT ALL PRIVILEGES ON " + username + ".* TO " + username + "@tosp IDENTIFIED BY '" + password + "' WITH GRANT OPTION;" );
    rs = statement.executeQuery( "GRANT ALL PRIVILEGES ON " + username + ".* TO " + username + "@\"%\" IDENTIFIED BY '" + password + "' WITH GRANT OPTION;" );
    rs = statement.executeQuery( "USE " + username + ";" );

    String create_table = "CREATE TABLE " + table + "( row INTEGER, A TEXT, B TEXT, C TEXT, D TEXT, E TEXT, F TEXT, G TEXT, H TEXT, I TEXT, J TEXT, K TEXT, L TEXT, M TEXT, N TEXT, O TEXT, P TEXT, Q TEXT, R TEXT, S TEXT, T TEXT, U TEXT, V TEXT, W TEXT, X TEXT, Y TEXT, Z TEXT );";
    rs = statement.executeQuery( create_table );

    for( int i = 1; i <= 26; i++ )
    {
      String insert_into = "INSERT INTO " + table + " VALUES( " + i + ", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\", \"\" );";
      rs = statement.executeQuery( insert_into );
    }

    out.print( "<META HTTP-EQUIV=\"Refresh\" CONTENT=\"0; url=/tosp/html/spreadsheet.htm\">" );

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
