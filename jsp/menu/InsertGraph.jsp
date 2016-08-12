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
    <TITLE>Insert Graph:</TITLE>
    <LINK REL=STYLESHEET TYPE="text/css" HREF="/tosp/tosp.css" TITLE="general">
  </HEAD>
<script language="JavaScript">
  window.moveTo(0,0);
  window.resizeTo(screen.width,screen.height);
</script>
<BODY BGCOLOR="#222222" TEXT="#FFFFFF" LINK="#009900" VLINK="#999999">
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
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

    // Unicode characters for greek letters:
    char rho = '\u03C1';
    char theta = '\u03B8';
    char phi = '\u03D5';

    java.util.Enumeration parameterNames = request.getParameterNames();
    String coordinates = "" + request.getParameter("coordinates");
    String variables = "" + request.getParameter("variables");
    String values = "" + request.getParameter("values");
    String opt = ""; // any radio button.

    if( coordinates.equals("null") )
      coordinates = "r";
    if( variables.equals("null") )
      variables = "x";
    if( values.equals("null") )
      values = "auto";
/*
    while(parameterNames.hasMoreElements())
    { String element = (String) parameterNames.nextElement();
      out.println("element='" + element + "' request.getParameter(element)='" + request.getParameter(element) + "'<BR>");
//      if ( request.getParameter( element ).equals("on"))
//        opt = element; // detects which radio button is on out of all passed parameters and assigns its name to "opt".
    }
*/
%>
<!--FORM NAME="graph" METHOD="Post" ACTION="/tosp/jsp/menu/ChartFrame.jsp" Target="dn"-->
<FORM NAME="graph" METHOD="Post" ACTION="/tosp/jsp/menu/InsertGraph.jsp">
<INPUT TYPE="Hidden" NAME="table">
<INPUT TYPE="Hidden" NAME="draw">
<TABLE WIDTH=100% border=0><TR VALIGN="Top"><TD>
<%
    char dim; // replaces x, y or z in HTML Form variables.
    int index; // determines "dim" from position in String "variables".
    switch( coordinates.charAt(0) )
    {
      case 'p':
      case 'c':
      case 's': {
        out.println("        <FONT COLOR=\"red\">Sorry, not implemented. Try RECTANGULAR.</FONT><BR>");
        break;
      }
      default : {
        for( index=0; index < variables.length(); index++ )
        {
          dim = variables.charAt(index);
          out.println("  <TABLE STYLE=\"border: 1px solid white\" border=0>");
          out.println("    <TR VALIGN=\"baseline\">");
          out.println("      <TD CLASS=\"graph\">");
          out.println("        <B>"+(char) (dim-32)+"</B>");
          out.println("      </TD>");
          if( values.equals( "data" ) )
          {
            out.println("      <TD CLASS=\"graph\">");
            out.println("        &nbsp; from");
            out.println("        <SELECT NAME=\""+dim+"FromCol\">");
            for( int i = 2; i <= columnCount; i++ )
            {
              String columnName = rm.getColumnName(i);
              out.println("          <OPTION>" + columnName);
            }
            out.println("        </SELECT>");
            out.println("        <SELECT NAME=\""+dim+"FromRow\">");
            for( int j = 1; j <= rowCount; j++ ) {
              out.println("          <OPTION>" + j);
            }
            out.println("        </SELECT>");
            out.println("      </TD>");
            out.println("      <TD CLASS=\"graph\">");
            out.println("        &nbsp; to");
            out.println("        <SELECT NAME=\""+dim+"ToCol\">");
            for( int i = 2; i <= columnCount; i++ )
            {
              String columnName = rm.getColumnName(i);
              out.println("          <OPTION>" + columnName);
            }
            out.println("        </SELECT>");
            out.println("        <SELECT NAME=\""+dim+"ToRow\">");
            for( int j = 1; j <= rowCount; j++ ) {
              out.println("          <OPTION>" + j);
            }
            out.println("        </SELECT>");
            out.println("      </TD>");
          } // end if
          out.println("      <TD CLASS=\"graph\">");
          out.println("        axis:");
          out.println("      </TD>");
          out.println("      <TD CLASS=\"graph\">");
          out.println("        <INPUT TYPE=\"Text\" NAME=\""+dim+"Label\">");
          out.println("      </TD>");
          out.println("    </TR>");
          out.println("  </TABLE>");
        } // end for
      } // end default
    } // end switch

    if( values.equals("auto") )
    {
      out.println("  <TABLE STYLE=\"border: 1px solid white\" border=0>");
      out.println("    <TR>");
      out.println("      <TD CLASS=\"graph\">");
      out.println("        <!--INPUT TYPE=\"Text\" NAME=\"function\"-->");
      out.println("        <SELECT name=\"function\">");
      out.println("          <OPTION SELECTED value=\"\">function");
      out.println("          <OPTION value=\"abs(x)\">abs(x)");
      out.println("          <OPTION value=\"arg(x)\">arg(x)");
      out.println("          <OPTION value=\"asin(x)\">asin(x)");
      out.println("          <OPTION value=\"atan(x)\">atan(x)");
      out.println("          <OPTION value=\"besj0(x)\">besj0(x)");
      out.println("          <OPTION value=\"besj1(x)\">besj1(x)");
      out.println("          <OPTION value=\"besy0(x)\">besy0(x)");
      out.println("          <OPTION value=\"besy1(x)\">besy1(x)");
      out.println("          <OPTION value=\"ceil(x)\">ceil(x)");
      out.println("          <OPTION value=\"cos(x)\">cos(x)");
      out.println("          <OPTION value=\"cosh(x)\">cosh(x)");
      out.println("          <OPTION value=\"erf(x)\">erf(x)");
      out.println("          <OPTION value=\"erfc(x)\">erfc(x)");
      out.println("          <OPTION value=\"exp(x)\">exp(x)");
      out.println("          <OPTION value=\"floor(x)\">floor(x)");
      out.println("          <OPTION value=\"gamma(x)\">gamma(x)");
      out.println("          <OPTION value=\"\">ibeta(p,q,x)");
      out.println("          <OPTION value=\"\">igamma(a,x)");
      out.println("          <OPTION value=\"imag(x)\">imag(x)");
      out.println("          <OPTION value=\"int(x)\">int(x)");
      out.println("          <OPTION value=\"lgamma(x)\">lgamma(x)");
      out.println("          <OPTION value=\"log(x)\">log(x)");
      out.println("          <OPTION value=\"log10(x)\">log10(x)");
      out.println("          <OPTION value=\"rand(x)\">rand(x)");
      out.println("          <OPTION value=\"real(x)\">real(x)");
      out.println("          <OPTION value=\"sgn(x)\">sgn(x)");
      out.println("          <OPTION value=\"sin(x)\">sin(x)");
      out.println("          <OPTION value=\"sinh(x)\">sinh(x)");
      out.println("          <OPTION value=\"sqrt(x)\">sqrt(x)");
      out.println("          <OPTION value=\"tan(x)\">tan(x)");
      out.println("          <OPTION value=\"tanh(x)\">tanh(x)");
      out.println("        </SELECT>");
      out.println("      </TD>");
    } // end if
    else
    {
      out.println("  <TABLE STYLE=\"border: 1px solid white\" border=0>");
      out.println("    <TR>");
      out.println("      <TD CLASS=\"graph\">");
      out.println("        in");
      out.println("        <SELECT NAME=\"dimension\">");
      out.println("          <OPTION value=\"plot\">2D");
      out.println("          <OPTION value=\"splot\">3D");
      out.println("        </SELECT>");
      out.println("      </TD>");
      out.println("      <TD CLASS=\"graph\">");
      out.println("        Series:");
      out.println("        <INPUT TYPE=\"Text\" NAME=\"series\">");
      out.println("      </TD>");
    }
%>
      <TD CLASS="graph">
        Title:
        <INPUT TYPE="Text" NAME="title">
      </TD>
    </TR>
  </TABLE>
  <TABLE border=1>
    <TR>
      <TD>
        <INPUT TYPE="Submit" Name="ok" VALUE="DRAW" onClick="document.graph.draw.value='true'">
      </TD>
    </TR>
  </TABLE>

</TD><TD>

  <TABLE STYLE="border: 1px solid white">
    <TR>
      <TD CLASS="graph">
<%
    out.println("        Coordinates:<BR>");
    out.print("        <INPUT TYPE=\"Radio\" NAME=\"coordinates\" VALUE=\"r\" onClick=\"document.graph.submit()\"");
    if( coordinates.equals("r") ) out.print(" CHECKED=\"True\""); out.println(">Rectangular<BR>");
    out.print("        <INPUT TYPE=\"Radio\" NAME=\"coordinates\" VALUE=\"p\" onClick=\"document.graph.submit()\"");
    if( coordinates.equals("p") ) out.print(" CHECKED=\"True\""); out.println(">Polar<BR>");
    out.print("        <INPUT TYPE=\"Radio\" NAME=\"coordinates\" VALUE=\"c\" onClick=\"document.graph.submit()\"");
    if( coordinates.equals("c") ) out.print(" CHECKED=\"True\""); out.println(">Cylindrical<BR>");
    out.print("        <INPUT TYPE=\"Radio\" NAME=\"coordinates\" VALUE=\"s\" onClick=\"document.graph.submit()\"");
    if( coordinates.equals("s") ) out.print(" CHECKED=\"True\""); out.println(">Spherical<BR>");
%>
      </TD>
    </TR>
  </TABLE>
  <TABLE STYLE="border: 1px solid white">
    <TR>
      <TD CLASS="graph">
        <INPUT TYPE="Checkbox" NAME="grid">Grid
      </TD>
    </TR>
  </TABLE>

</TD><TD>

  <TABLE STYLE="border: 1px solid white">
    <TR>
      <TD CLASS="graph">
<%
    switch( coordinates.charAt(0) )
    {
      case 'p':
      case 'c':
      case 's': {
        out.println("        <FONT COLOR=\"red\">Sorry, not implemented. Try RECTANGULAR.</FONT><BR>");
        break;
      }
      default : {
        out.println("        Variables:<BR>");
        out.print("        <INPUT TYPE=\"Radio\" NAME=\"variables\" VALUE=\"x\" onClick=\"document.graph.submit()\"");
        if( variables.equals("x") ) out.print(" CHECKED=\"True\""); out.println(">Only X<BR>");
        out.print("        <INPUT TYPE=\"Radio\" NAME=\"variables\" VALUE=\"xy\" onClick=\"document.graph.submit()\"");
        if( variables.equals("xy") ) out.print(" CHECKED=\"True\""); out.println(">X and Y<BR>");
        out.print("        <INPUT TYPE=\"Radio\" NAME=\"variables\" VALUE=\"xyz\" onClick=\"document.graph.submit()\"");
        if( variables.equals("xyz") ) out.print(" CHECKED=\"True\""); out.println(">X, Y and Z<BR>");
      }
    }
%>
      </TD>
    </TR>
    <TR>
      <TD CLASS="graph">
<%
    out.println("        Values:<BR>");
    out.print("        <INPUT TYPE=\"Radio\" NAME=\"values\" VALUE=\"auto\" onClick=\"document.graph.submit()\"");
    if( values.equals("auto") ) out.print(" CHECKED=\"True\""); out.println(">Automatic<BR>");
    out.print("        <INPUT TYPE=\"Radio\" NAME=\"values\" VALUE=\"data\" onClick=\"document.graph.submit()\"");
    if( values.equals("data") ) out.print(" CHECKED=\"True\""); out.println(">Spreadsheet<BR>");
%>
      </TD>
    </TR>
 </TABLE>

</TABLE>
</FORM>

<%
    String gnuplot_cmd = "/usr/jakarta-tomcat-5.0.14/webapps/tosp/WEB-INF/classes/gnuplot/gnuplot.cmd";
    String gnuplot_dat = "/usr/jakarta-tomcat-5.0.14/webapps/tosp/WEB-INF/classes/gnuplot/gnuplot.dat";
    String draw = "" + request.getParameter( "draw" );
    String prefix = "set terminal png\n";
    String dimension = "" + request.getParameter("dimension");
    String function = "" + request.getParameter("function");
    String t = "" + request.getParameter("title");
    String title = "set title ";
    String s = "" + request.getParameter("series");
    String series = "title ";
    String option = "set ";
    String xL = "" + request.getParameter("xLabel");
    String xLabel = "set xlabel ";
    String yL = "" + request.getParameter("yLabel");
    String yLabel = "set ylabel ";
    String xFR = "" + request.getParameter("xFromRange");
    String xTR = "" + request.getParameter("xToRange");
    String xRange = "set xrange ";
    String yFR = "" + request.getParameter("yFromRange");
    String yTR = "" + request.getParameter("yToRange");
    String yRange = "set yrange ";
    String xF = "" + request.getParameter("xFormat");
    String xFormat = "set format x \"%.";
    String yF = "" + request.getParameter("yFormat");
    String yFormat = "set format y \"%.";
    String xFromRow = "" + request.getParameter( "xFromRow" );
    String xFromCol = "" + request.getParameter( "xFromCol" );
    String xToRow = "" + request.getParameter( "xToRow" );
    String xToCol = "" + request.getParameter( "xToCol" );
    String yFromRow = "" + request.getParameter( "yFromRow" );
    String yFromCol = "" + request.getParameter( "yFromCol" );
    String yToRow = "" + request.getParameter( "yToRow" );
    String yToCol = "" + request.getParameter( "yToCol" );
    String command = "" + prefix;

    if( !t.equals( "null" ) )
    { title += "\"" + t + "\"\n";
      command += title;
    }
    if( !opt.equals( "" ) )
    { option += opt + "\n";
      command += option;
    }
    if( !xL.equals( "null" ) )
    { xLabel += "\"" + xL + "\"\n";
      command += xLabel;
    }
    if( !yL.equals( "null" ) )
    { yLabel += "\"" + yL + "\"\n";
      command += yLabel;
    }
    if( !xFR.equals( "null" ) && !xTR.equals( "null" ) )
    { xRange += "[ " + xFR + " : " + xTR + " ]\n";
      command += xLabel;
    }
    if( !yFR.equals( "null" ) && !yTR.equals( "null" ) )
    { yRange += "[ " + yFR + " : " + yTR + " ]\n";
      command += yLabel;
    }
    if( !xF.equals( "null" ) )
    { xFormat += xF + "f\"\n";
      command += xFormat;
    }
    if( !yF.equals( "null" ) )
    { yFormat += yF + "f\"\n";
      command += yFormat;
    }
    if( !s.equals( "" ) )
    { series += "'"  + s + "'\n";
    }

    if( !xFromRow.equals( "null" ) )
    {
      rs = statement.executeQuery("SELECT * FROM " + table + ";");
      rm = rs.getMetaData();
      FileWriter writer = new FileWriter( gnuplot_dat );
      PrintWriter fout = new PrintWriter( writer );
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
            fout.print( rs.getString( xFromCol.charAt(0) - 65 + 2 ) + ' ' );
            if( !yFromRow.equals( "null" ) )
              fout.print( rs.getString( yFromCol.charAt(0) - 65 + 2 ) + ' ' );
            j++;
            i++;
          }
          fout.println();
        }
        int n = Integer.parseInt( xToRow ) - Integer.parseInt( xFromRow ) + 1;
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
              fout.print( rs.getString(i) + ' ' );
              if( !yFromRow.equals( "null" ) )
                fout.print( rs.getString( yFromCol.charAt(0) - 65 + 2 ) + ' ' );
              j++;
            }
            fout.println();
          }
        }
        int n = to - from + 1;
      }

      fout.close();
    } // end if xFromRow != null

    if( values.equals("auto") )
      command += dimension + ' ' + function;
    if( values.equals("data") )
      command += dimension + " '" + gnuplot_dat + "'" + series;

    FileWriter writer = new FileWriter( gnuplot_cmd );
    PrintWriter fout = new PrintWriter( writer );
    fout.println( command );
    fout.close();

    if( (!function.equals("null") && !function.equals("")) || (values.equals("data") && draw.equals("true")) )
    {
      out.println("<P ALIGN=\"Center\">");
      out.print("<IMG SRC=\"/tosp/servlet/gnuplot.binOutput\"");
      out.println(" ALT=\"this is the '" + dimension + "' graph of " + function + "...\" border=0>");
      out.println("</P>");
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
