<%@page import="java.text.SimpleDateFormat"%>
<%@page import = "java.util.Date" %>
<div id="mySidenav" class="sidenav">
		<p class="logo"><span>L </span>M S</p>
	  <a href="admin.jsp" class="icon-a"><i class="fa fa-dashboard icons"></i>   Dashboard</a>
	  <a href="allLeads.jsp"class="icon-a"><i class="fa fa-line-chart icons"></i>   All Leads</a>
	  <a href="posted-lead-admin.jsp"class="icon-a"><i class="fa fa-location-arrow icons"></i>   Posted Leads</a>
	  <a href="assigned-lead-admin.jsp"class="icon-a"><i class="fa fa-get-pocket icons"></i>   Assigned Leads</a>
	  <a href="allUsers.jsp"class="icon-a"><i class="fa fa-user-plus icons"></i>   All Users</a>
	  <a href="adminProfile.jsp"class="icon-a"><i class="fa fa-user-circle icons"></i>   Profile</a>
	  <a href="adminHelp.jsp"class="icon-a"><i class="fa fa-question-circle icons"></i>   Help</a>
	  <form action = "logout" method = "post"><a href="#"class="icon-a"><button type = "submit" class = "logBtn"><i class="fa fa-sign-out icons"></i> Logout</button></a></form> 
	  <div class = "timeDate">
	  	<p style = "margin-top: 390px; margin-left: 5px; font-size: 18px; color: gray;">Date and Time</p>
	  	<%
	  		SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy hh:mm a");
			Date date = new Date();
	    	out.println("<p style = 'margin-top: -20px; margin-left: 5px; font-size: 16px; color: lightgray;''>"+formatter.format(date)+"</p>");
	  	%>
	  </div>
	</div>