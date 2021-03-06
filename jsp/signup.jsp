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
  String username = request.getParameter("u");
  String new1Password = request.getParameter( "n1" );
  String new2Password = request.getParameter( "n2" );
  session = request.getSession( true );
  try
  {
    Class.forName("org.gjt.mm.mysql.Driver").newInstance();
    Connection connection = DriverManager.getConnection("jdbc:mysql:///mysql", "root", "alex2665");
    DatabaseMetaData dbMetaData = connection.getMetaData();
    Statement statement = connection.createStatement();
    ResultSet rs = statement.executeQuery("SELECT User FROM user;");
    ResultSetMetaData rm = rs.getMetaData();
    int columnCount = rm.getColumnCount();

    boolean unique_username = false;
    while( rs.next() )
      if( !username.equals( rs.getString(1) ) )
        unique_username = true;

    if( (unique_username) && (new1Password.equals( new2Password )) )
    {
      out.println( "<H1>Welcome, " + username + "</H1><BR>" );
      synchronized( session )
      {
        session.putValue( "username", username );
        session.putValue( "password", new1Password );
        out.print( "<META HTTP-EQUIV=\"Refresh\" CONTENT=\"0; url=/tosp/jsp/init.jsp\">" );
      }
    }
    else
      out.print( "<META HTTP-EQUIV=\"Refresh\" CONTENT=\"0; url=/tosp/html/about.htm\">" );

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
