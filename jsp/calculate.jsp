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
  String table;
  synchronized( session )
  {
    username = (String) session.getValue( "username" );
    password = (String) session.getValue( "password" );
    table = (String) session.getValue( "table" );
  }

  String submenu = request.getParameter( "submenu" );
  String function = request.getParameter( "function" );
  String intoRow = request.getParameter( "intoRow" );
  String intoCol = request.getParameter( "intoCol" );
  String fromRow = request.getParameter( "fromRow" );
  String fromCol = request.getParameter( "fromCol" );
  String toRow = request.getParameter( "toRow" );
  String toCol = request.getParameter( "toCol" );
  String functionResult = new String( "0" );

  if( ! submenu.equals( "" ) )
  {
////out.print( "<h1>it's aliiiiive!</h1>" );
  }
  if( submenu.equals( "function" ) )
  {
    if( function.equals( "SUM(X,Y,...)" ) )
    {
      double sum = 0;
      if( fromCol.equals( toCol ) )
      {
        for( int i = Integer.parseInt( fromRow ); i <= Integer.parseInt( toRow ); i++ )
          sum += Double.parseDouble( request.getParameter( fromCol + i ) );
        functionResult = Double.toString( sum );
      }
      if( fromRow.equals( toRow ) )
      {
        char from = fromCol.charAt( 0 );
        char to = toCol.charAt( 0 );
        char colCount = '0';
        for( colCount = from; colCount <= to; colCount++ )
          sum += Double.parseDouble( request.getParameter( colCount + fromRow  ) );
        functionResult = Double.toString( sum );
      }
    }
    if( function.equals( "AVG(X,Y,...)" ))
    {
      double sum = 0, avg = 0;
      if( fromCol.equals( toCol ) )
      {
        for( int i = Integer.parseInt( fromRow ); i <= Integer.parseInt( toRow ); i++ )
          sum += Double.parseDouble( request.getParameter( fromCol + i ) );
        avg = sum / ( Integer.parseInt(toRow) - Integer.parseInt(fromRow) + 1);
        functionResult = Double.toString( avg );
      }
      if( fromRow.equals( toRow ) )
      {
        char from = fromCol.charAt( 0 );
        char to = toCol.charAt( 0 );
        char colCount = '0';
        for( colCount = from; colCount <= to; colCount++ )
          sum += Double.parseDouble( request.getParameter( colCount + fromRow  ) );
        avg = sum / (to - from + 1);
        functionResult = Double.toString( avg );
      }
    }
    if( function.equals( "STDEV(X,Y,...)" ))
    {
      double sumxi = 0, avgxi = 0, sumdisqr = 0, stdev = 0;
      if( fromCol.equals( toCol ) )
      {
        for( int i = Integer.parseInt( fromRow ); i <= Integer.parseInt( toRow ); i++ )
          sumxi += Double.parseDouble( request.getParameter( fromCol + i ) );
        avgxi = sumxi / ( Integer.parseInt(toRow) - Integer.parseInt(fromRow) + 1);
        for( int i = Integer.parseInt( fromRow ); i <= Integer.parseInt( toRow ); i++ )
        {
          double xi = Double.parseDouble( request.getParameter( fromCol + i ) );
          double di = xi - avgxi;
          sumdisqr += java.lang.Math.pow( di, 2.0 );
        }
        stdev = java.lang.Math.sqrt( sumdisqr / ( Integer.parseInt(toRow) - Integer.parseInt(fromRow) ) );
        functionResult = Double.toString( stdev );
      }
      if( fromRow.equals( toRow ) )
      {
        char from = fromCol.charAt( 0 );
        char to = toCol.charAt( 0 );
        char colCount = '0';
        for( colCount = from; colCount <= to; colCount++ )
          sumxi += Double.parseDouble( request.getParameter( colCount + fromRow ) );
        avgxi = sumxi / (to - from + 1);
        for( colCount = from; colCount <= to; colCount++ )
        {
          double xi = Double.parseDouble( request.getParameter( colCount + fromRow ) );
          double di = xi - avgxi;
          sumdisqr += java.lang.Math.pow( di, 2.0 );
        }
        stdev = java.lang.Math.sqrt( sumdisqr / ( to - from ) );
        functionResult = Double.toString( stdev );
      }
    }
    if( function.equals( "PRCNTERR(X,Y)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double y = Double.parseDouble( request.getParameter( toCol + toRow ) );
      double prcnterr = 0;
      prcnterr = ( java.lang.Math.abs( y - x ) / x ) * 100;
      functionResult = Double.toString( prcnterr ) + "%";
    }
    if( function.equals( "PRCNTDIFF(X,Y)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double y = Double.parseDouble( request.getParameter( toCol + toRow ) );
      double prcntdiff = 0;
      prcntdiff = ( java.lang.Math.abs( x - y ) / ((x + y) / 2) ) * 100;
      functionResult = Double.toString( prcntdiff ) + "%";
    }
    if( function.equals( "ABS(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double abs = java.lang.Math.abs( x );
      functionResult = Double.toString( abs );
    }
    if( function.equals( "ACOS(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double acos = java.lang.Math.acos( x );
      functionResult = Double.toString( acos );
    }
    if( function.equals( "ASIN(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double asin = java.lang.Math.asin( x );
      functionResult = Double.toString( asin );
    }
    if( function.equals( "ATAN(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double atan = java.lang.Math.atan( x );
      functionResult = Double.toString( atan );
    }
    if( function.equals( "CEILING(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double ceil = java.lang.Math.ceil( x );
      functionResult = Double.toString( ceil );
    }
    if( function.equals( "COS(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double cos = java.lang.Math.cos( x );
      functionResult = Double.toString( cos );
    }
    if( function.equals( "E()" ))
    {
      functionResult = Double.toString( java.lang.Math.E );
    }
    if( function.equals( "EXP(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double exp = java.lang.Math.exp( x );
      functionResult = Double.toString( exp );
    }
    if( function.equals( "FLOOR(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double floor = java.lang.Math.floor( x );
      functionResult = Double.toString( floor );
    }
    if( function.equals( "LOG(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double log = java.lang.Math.log( x );
      functionResult = Double.toString( log );
    }
    if( function.equals( "LOG10(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double log = java.lang.Math.log( x );
      double log10 = log / java.lang.Math.log( 10.0 );
      functionResult = Double.toString( log10 );
    }
    if( function.equals( "MAX(X,Y,...)" ))
    {
      double max = Double.NEGATIVE_INFINITY;
      if( fromCol.equals( toCol ) )
      {
        for( int i = Integer.parseInt( fromRow ); i <= Integer.parseInt( toRow ); i++ )
          if( Double.parseDouble( request.getParameter( fromCol + i ) ) > max )
            max = Double.parseDouble( request.getParameter( fromCol + i ) );
        functionResult = Double.toString( max );
      }
      if( fromRow.equals( toRow ) )
      {
        char from = fromCol.charAt( 0 );
        char to = toCol.charAt( 0 );
        char colCount = '0';
        for( colCount = from; colCount <= to; colCount++ )
          if( Double.parseDouble( request.getParameter( colCount + fromRow ) ) > max )
            max = Double.parseDouble( request.getParameter( colCount + fromRow  ) );
        functionResult = Double.toString( max );
      }
    }
    if( function.equals( "MIN(X,Y,...)" ))
    {
      double min = Double.POSITIVE_INFINITY;
      if( fromCol.equals( toCol ) )
      {
        for( int i = Integer.parseInt( fromRow ); i <= Integer.parseInt( toRow ); i++ )
          if( Double.parseDouble( request.getParameter( fromCol + i ) ) < min )
            min = Double.parseDouble( request.getParameter( fromCol + i ) );
        functionResult = Double.toString( min );
      }
      if( fromRow.equals( toRow ) )
      {
        char from = fromCol.charAt( 0 );
        char to = toCol.charAt( 0 );
        char colCount = '0';
        for( colCount = from; colCount <= to; colCount++ )
          if( Double.parseDouble( request.getParameter( colCount + fromRow ) ) < min )
            min = Double.parseDouble( request.getParameter( colCount + fromRow  ) );
        functionResult = Double.toString( min );
      }
    }
    if( function.equals( "MOD(N,M)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double y = Double.parseDouble( request.getParameter( toCol + toRow ) );
      double mod = java.lang.Math.IEEEremainder( x, y );
      functionResult = Double.toString( mod );
    }
    if( function.equals( "POW(X,Y)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double y = Double.parseDouble( request.getParameter( toCol + toRow ) );
      double pow = java.lang.Math.pow( x, y );
      functionResult = Double.toString( pow );
    }
    if( function.equals( "RAND()" ))
    {
      functionResult = Double.toString( java.lang.Math.random() );
    }
    if( function.equals( "ROUND(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      functionResult = Long.toString( java.lang.Math.round( x ) );
    }
    if( function.equals( "SIN(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double sin = java.lang.Math.sin( x );
      functionResult = Double.toString( sin );
    }
    if( function.equals( "SQRT(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      functionResult = Double.toString( java.lang.Math.sqrt( x ) );
    }
    if( function.equals( "TAN(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      double tan = java.lang.Math.tan( x );
      functionResult = Double.toString( tan );
    }
    if( function.equals( "TODEG(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      functionResult = Double.toString( java.lang.Math.toDegrees( x ) );
    }
    if( function.equals( "TORAD(X)" ))
    {
      double x = Double.parseDouble( request.getParameter( fromCol + fromRow ) );
      functionResult = Double.toString( java.lang.Math.toRadians( x ) );
    }
    if( function.equals( "PI()" ))
    {
      functionResult = Double.toString( java.lang.Math.PI );
    }
    if( function.equals( "" ))
      return; //don't update anything.
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

    for( int j = 1; j <= rowCount; j++ )
    {
      for( int i = 2; i <= columnCount; i++ )
      {
        String columnName = rm.getColumnName(i);
        String value = request.getParameter( columnName + j );
        String sql = "UPDATE " + table + " SET " + columnName + "=\"" + value + "\" WHERE row=\"" + j + "\";";
////////out.println( sql + "<br>" );
        ResultSet u = statement.executeQuery( sql );
      }
    }

    if( submenu.equals( "function" ) )
    {
      String query = "UPDATE " + table + " SET " + intoCol + "=\"" + functionResult + "\" WHERE row=\"" + intoRow + "\";";
      ResultSet f = statement.executeQuery( query );
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
