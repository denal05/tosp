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
  <LINK REL=STYLESHEET TYPE="text/css" HREF="/tosp/tosp.css" TITLE="general">
</HEAD>
<BODY onLoad="javascript: document.spreadsheet.A1.focus()">
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

  if( table.equals( "" ) )
  {
    table = request.getParameter( "table" );
    synchronized( session )
    {
      session.putValue( "table", table );
    }
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
%>
<FORM NAME="spreadsheet" ACTION="/tosp/jsp/calculate.jsp" METHOD="Post">
  <INPUT TYPE="Hidden" NAME="submenu">
  <INPUT TYPE="Hidden" NAME="open">
  <TABLE STYLE="border: 1px solid white" WIDTH=100%>
    <TR>
      <TD WIDTH=80%>
        <SELECT NAME="function">
          <OPTION>
          <OPTION>SUM(X,Y,...)
          <OPTION>AVG(X,Y,...)
          <OPTION>STDEV(X,Y,...)
          <OPTION>PRCNTERR(X,Y)
          <OPTION>PRCNTDIFF(X,Y)
          <OPTION>ABS(X)
          <OPTION>ACOS(X)
          <OPTION>ASIN(X)
          <OPTION>ATAN(X)
          <OPTION>CEILING(X)
          <OPTION>COS(X)
          <OPTION>E()
          <OPTION>EXP(X)
          <OPTION>FLOOR(X)
          <OPTION>LOG(X)
          <OPTION>LOG10(X)
          <OPTION>MAX(X,Y,...)
          <OPTION>MIN(X,Y,...)
          <OPTION>MOD(N,M)
          <OPTION>POW(X,Y)
          <OPTION>RAND()
          <OPTION>ROUND(X)
          <OPTION>SIN(X)
          <OPTION>SQRT(X)
          <OPTION>TAN(X)
          <OPTION>TODEG(X)
          <OPTION>TORAD(X)
          <OPTION>PI()
        </SELECT>
        INTO THE CELL
        <SELECT NAME="intoCol">
<%
    for( int i = 2; i <= columnCount; i++ )
    {
      String columnName = rm.getColumnName(i);
      out.println( "          <OPTION>" + columnName);
    }
%>
        </SELECT>
        <SELECT NAME="intoRow">
<%
    for( int j = 1; j <= rowCount; j++ )
      out.println( "          <OPTION>" + j);
%>
        </SELECT>
        WITH RANGE FROM CELL
        <SELECT NAME="fromCol">
<%
    for( int i = 2; i <= columnCount; i++ )
    {
      String columnName = rm.getColumnName(i);
      out.println( "          <OPTION>" + columnName);
    }
%>
        </SELECT>
        <SELECT NAME="fromRow">
<%
    for( int j = 1; j <= rowCount; j++ )
      out.println( "          <OPTION>" + j);
%>
        </SELECT>
        TO CELL
        <SELECT NAME="toCol">
<%
    for( int i = 2; i <= columnCount; i++ )
    {
      String columnName = rm.getColumnName(i);
      out.println( "          <OPTION>" + columnName);
    }
%>
        </SELECT>
        <SELECT NAME="toRow">
<%
    for( int j = 1; j <= rowCount; j++ )
      out.println( "          <OPTION>" + j);
%>
        </SELECT>
      </TD>
      <TD>
        <INPUT TYPE="Submit" Name="ok" VALUE="Insert Function" onClick="javascript: document.spreadsheet.submenu.value='function'">
        <INPUT TYPE="Button" Name="graph" VALUE="Graph" STYLE="color: #ffffff; background: #990000; border-color: #550000;" onClick="window.open('/tosp/jsp/menu/InsertGraph.jsp','rename','height=700, width=1000')">
      </TD>
    </TR>
  </TABLE>

<% rs = statement.executeQuery("SELECT * FROM " + table + ";"); %>

  <TABLE>
    <TR>
<%
    out.println( "      <TD>" );
    for( int i = 2; i <= columnCount; i++ )
      out.println( "      <TD ALIGN=\"Center\">" + rm.getColumnName(i) );
%>
    </TR>
<%
    int j=1;
    while( rs.next() )
    {
      out.println( "    <TR>" );
      out.println( "      <TD ALIGN=\"Center\">" + j );
      for( int i = 2; i <= columnCount; i++ )
        out.println( "      <TD><INPUT TYPE=TEXT NAME=\"" + rm.getColumnName(i) + j + "\" SIZE=15 TABINDEX=\"" +
                     ( (i-2)*rowCount + j ) + "\" VALUE=\"" + rs.getString(i) + "\">");
      out.println( "    </TR>" );
      j++;
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
  </TABLE>
</FORM>

</BODY>
</HTML>
