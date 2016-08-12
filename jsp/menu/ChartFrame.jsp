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

  String xFromRow = request.getParameter( "xFromRow" );
  String xFromCol = request.getParameter( "xFromCol" );
  String xToRow = request.getParameter( "xToRow" );
  String xToCol = request.getParameter( "xToCol" );
  String yFromRow = request.getParameter( "yFromRow" );
  String yFromCol = request.getParameter( "yFromCol" );
  String yToRow = request.getParameter( "yToRow" );
  String yToCol = request.getParameter( "yToCol" );

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
%>
<TABLE ALIGN="Center" CELLPADDING=10 STYLE="border: 1px solid white">
  <TR>
    <TD ALIGN="Center">
<%
  String ti = request.getParameter("ti");
  String ca = request.getParameter("ca");
  out.println("    <H1>" + ti + "</H1>" );
%>
    </TD>
  </TR>
  <TR>
    <TD ALIGN="Center">
      <IMG SRC="/servlet/ImageSender?
<%
  rs = statement.executeQuery("SELECT * FROM " + table + ";");
  rm = rs.getMetaData();
  String chart = request.getParameter( "chart" );
  if( chart.equals( "V.BAR" ) )
  {
    if( xFromCol.equals( xToCol ) )
    {
      int i = Integer.parseInt( xFromRow );
      int j = 1;
      int currRow = 1;
      while( rs.next() && ( i <= Integer.parseInt( xToRow ) ) )
      {
        if( currRow != Integer.parseInt( xFromRow ) )
          currRow ++;
        else
        {
          out.print
          (
            "s" + j + "=" + rs.getString( xFromCol.charAt(0) - 65 + 2 ) + "&" +
            "c" + j + "=" + "blue" + "&"
          );
          j++;
          i++;
        }
      }
      int tn = Integer.parseInt( xToRow ) - Integer.parseInt( xFromRow ) + 1;
      out.println( "tn=" + tn + "\">" );
    }
    if( xFromRow.equals( xToRow ) )
    {
      char from = xFromCol.charAt( 0 );
      char to = xToCol.charAt( 0 );
      int j=1;
      int currRow = 1;
      while( rs.next() )
      {
        if( currRow != Integer.parseInt( xFromRow ) )
          currRow ++;
        else
        {
          for( int i = from - 65 + 2; i <= to - 65 + 2; i++ )
          {
            out.print
            (
              "s" + j + "=" + rs.getString(i) + "&" +
              "c" + j + "=" + "blue" + "&"
            );
            j++;
          }
        }
      }
      int tn = to - from + 1;
      out.println( "tn=" + tn + "\">" );
    }
  }
  if( chart.equals( "H.BAR" ) )
  {
  }
  if( chart.equals( "XY_SCATTER" ) )
  {
  }
  if( chart.equals( "PIE" ) )
  {
  }
%>
    </TD>
  </TR>
  <TR>
    <TD ALIGN=\"Center\">
<% out.println( "      <H1>" + ca + "</H1>" ); %>
    </TD>
  </TR>
</TABLE>
<%
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
