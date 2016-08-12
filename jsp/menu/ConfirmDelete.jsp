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
    <TITLE>File Delete:</TITLE>
    <LINK REL=STYLESHEET TYPE="text/css" HREF="/tosp/tosp.css" TITLE="general">
  </HEAD>
<BODY BGCOLOR="#222222" TEXT="#FFFFFF" LINK="#009900" VLINK="#999999">
<%
  String tableName = new String();
  java.util.Enumeration parameterNames = request.getParameterNames();
  while(parameterNames.hasMoreElements())
  {
    String element = (String) parameterNames.nextElement();
    if ( request.getParameter( element ).equals("on"))
      tableName = element;
  }
%>
<FORM NAME="delete" ACTION="/tosp/jsp/menu/execute.jsp" TARGET="dn" METHOD="Post">
<INPUT TYPE="Hidden" NAME="submenu" VALUE="delete">
<%
    out.println( "<INPUT TYPE=\"Hidden\" NAME=\"tableName\" VALUE=\"" + tableName +"\">" );
%>
<TABLE ALIGN="Center">
  <TR>
    <TD ALIGN="Center" BGCOLOR="#111111"><FONT FACE="Times"><I>Confirm Password:</I>
  </TR>
  <TR>
    <TD BGCOLOR="#111111"><INPUT TYPE="Password" NAME="p">
  </TR>
</TABLE>
<P ALIGN="Center">
  <INPUT TYPE="Submit" Name="ok" VALUE="OK" onClick="javascript: document.delete.p.value=''">
</P>
</FORM>
</BODY>
</HTML>
