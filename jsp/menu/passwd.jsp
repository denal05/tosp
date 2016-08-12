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
  String username;
  String password;
  session = request.getSession( true );
  synchronized( session )
  {
    username = (String) session.getValue( "username" );
    password = (String) session.getValue( "password" );
  }
  String oldPassword = request.getParameter( "o" );
  String new1Password = request.getParameter( "n1" );
  String new2Password = request.getParameter( "n2" );

  try
  {
    Class.forName("org.gjt.mm.mysql.Driver").newInstance();
    Connection connection = DriverManager.getConnection("jdbc:mysql:///mysql", "root", "alex2665" );
    DatabaseMetaData dbMetaData = connection.getMetaData();
    Statement statement = connection.createStatement();
    ResultSet rs = statement.executeQuery( "USE mysql;" );

    if( oldPassword.equals( password ) )
    {
      if( new1Password.equals( new2Password ) )
      {
        String query1 = "SET PASSWORD FOR " + username + "@localhost = PASSWORD('" + new1Password + "');";
        String query2 = "SET PASSWORD FOR " + username + "@\"%\" = PASSWORD('" + new1Password + "');";
        rs = statement.executeQuery( query1 );
        rs = statement.executeQuery( query2 );
        synchronized( session )
        {
          session.putValue( "password", new1Password );
        }
      }
    }

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
