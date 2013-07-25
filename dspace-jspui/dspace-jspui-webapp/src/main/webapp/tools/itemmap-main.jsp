<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>

<%--
  - Display the main page for item mapping (status and controls)
  -
  - Attributes to pass in:
  -
  -   collection        - Collection we're managing
  -   collections       - Map of Collections, keyed by collection_id
  -   collection_counts - Map of Collection IDs to counts
  -   count_native      - how many items are in collection
  -   count_import      - how many items are 'virtual'
  --%>
  
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.net.URLEncoder"            %>
<%@ page import="java.util.Iterator"             %>
<%@ page import="java.util.Map"                  %>
<%@ page import="org.dspace.content.Collection"  %>
<%@ page import="org.dspace.content.Item"        %>
<%@ page import="org.dspace.core.ConfigurationManager" %>

<%
    Collection collection = (Collection)request.getAttribute("collection");
    int count_native  =
        ((Integer)request.getAttribute("count_native")).intValue();
    int count_import  =
        ((Integer)request.getAttribute("count_import")).intValue();
    Map items             = (Map)request.getAttribute("items");
    Map collections       = (Map)request.getAttribute("collections");
    Map collection_counts = (Map)request.getAttribute("collection_counts");
    Collection [] all_collections = (Collection[])
                                    request.getAttribute("all_collections");
%>

<dspace:layout titlekey="jsp.tools.itemmap-main.title">

    <%-- <h2>Item Mapper - Map Items from Other Collections</h2> --%>
	<h2><fmt:message key="jsp.tools.itemmap-main.heading"/></h2>

    <%--  <p>Collection: "<%=collection.getMetadata("name")%>"</p> --%>
    <p><fmt:message key="jsp.tools.itemmap-main.collection">
        <fmt:param><%=collection.getMetadata("name")%></fmt:param>
    </fmt:message></p>
	 
    <%-- <p>There are <%=count_native%> items owned by this collection, and
    <%=count_import%> items mapped in from other collections.</p> --%>
	<p><fmt:message key="jsp.tools.itemmap-main.info1">
        <fmt:param><%=count_native%></fmt:param>
        <fmt:param><%=count_import%></fmt:param>
    </fmt:message></p>
   
<%-- 
    <h3>Quick Add Item:</h3>

    <p>Enter the Handle or internal item ID of the item you want to add:</p>
    
    <form method="post" action="">
        <input type="hidden" name="action" value="add"/>
        <input type="hidden" name="cid" value="<%=collection.getID()%>"/>
        <center>
            <table class="miscTable">
                <tr class="oddRowEvenCol">
                    <td class="submitFormLabel"><label for="thandle">Handle:</label></td>
                    <td>
                            <input type="text" name="handle" id="thandle" value="<%= ConfigurationManager.getProperty("handle.prefix") %>/" size="12"/>
                            <input type="submit" name="submit" value="Add"/>
                    </td>
                </tr>
                <tr></tr>
                <tr class="oddRowEvenCol">
                    <td class="submitFormLabel"><label for="titem_id">Internal ID:</label></td>
                    <td>
                            <input type="text" name="item_id" id="titem_id" size="12"/>
                            <input type="submit" name="submit" value="Add"/>
                    </td>
                </tr>
            </table>
        </center>
    </form>

    <h3>Import an entire collection</h3>
    <form method="post" action="">
    <input type="hidden" name="cid" value="<%=collection.getID()%>"/>
    <select name="collection2import">
<%  for(int i=0; i<all_collections.length; i++)
    {
        int myID = all_collections[i].getID();
        
        if( myID != collection.getID() )  // leave out this collection!
        {   %>
        <option value="<%= all_collections[i].getID()%>">
        <%= all_collections[i].getMetadata("name")%>
        </option>
    <%  }
    } %>
    </select>

    <input type="submit" name="action" value="Add Entire Collection!"/>
    </form>        
    --%>

    <%-- <h3>Import By Author Match</h3>
    Enter part of an author's name for a list of matching items<br> --%>
	<h3><fmt:message key="jsp.tools.itemmap-main.info4"/></h3>
    <fmt:message key="jsp.tools.itemmap-main.info5"/><br/>

    <form method="post" action="">
        <input type="hidden" name="cid" value="<%=collection.getID()%>"/>
        <input name="namepart"/>
        <%-- <input type="submit" name="action" value="Search Authors"/> --%>
        <input type="hidden" name="action" value="Search Authors"/>
	    <input type="submit" value="<fmt:message key="jsp.tools.itemmap-main.search.button"/>" />
        <br/>
    </form> 

    <%-- <h3>Browse Items Imported From Collections:</h3> --%>
	<h3><fmt:message key="jsp.tools.itemmap-main.info6"/></h3>

    <%-- <p>Click on collection names to browse for items to remove that were mapped in from that collection.</p> --%>
	<p><fmt:message key="jsp.tools.itemmap-main.info7"/></p>

<%
    String row = "even";
    Iterator colKeys = collections.keySet().iterator();

    if(!colKeys.hasNext())
    {
%>
    <%-- <p>This collection has no items mapped into it.</p> --%>
	<p><fmt:message key="jsp.tools.itemmap-main.info8"/></p>
<%
    }

    while( colKeys.hasNext() )
    {
        Collection myCollection = (Collection)collections.get(colKeys.next());
        String myTitle = myCollection.getMetadata("name");
        int cid        = collection.getID();
        int myID       = myCollection.getID();
        int myCount    = ((Integer)collection_counts.get(
                                new Integer(myID))).intValue();    

        String myLink = request.getContextPath()+"/tools/itemmap?action=browse";
%>
    <p align="center"><a href="<%=myLink%>&amp;cid=<%=cid%>&amp;t=<%=myID%>"><%=myTitle%> (<%=myCount%>)</a></p>
<%  } %>            
</dspace:layout>