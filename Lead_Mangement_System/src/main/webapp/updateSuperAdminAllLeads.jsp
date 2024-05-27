<%@page import="in.pandit.dao.CompanyDao"%>
<%@page import="in.pandit.model.Lead"%>
<%@page import="in.pandit.model.User"%>
<%@page import="in.pandit.dao.LeadDao"%>
<%@page import="in.pandit.helper.CookiesHelper"%>
<%@page import="in.pandit.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import = "in.pandit.persistance.DatabaseConnection" %>
<%@page import = "java.util.List" %>
<%@page import = "java.util.ArrayList" %>
<%@page import = "java.text.SimpleDateFormat" %>
<%@page import = "java.util.Date" %>
<%
int leadId = Integer.parseInt(request.getParameter("update"));
UserDao userDao = new UserDao();
LeadDao leadDao = new LeadDao();
Lead lead = leadDao.getLeadById(leadId);
CompanyDao companyDao = new CompanyDao();
CookiesHelper.setCookies(lead, response, "lead");
int companyCount = companyDao.getAllCompanyCount();

User userCookie = CookiesHelper.getUserCookies(request, "user");
int companyId = userCookie.getCompanyId();
int userCount = userDao.getUserCount("User", companyId);
int adminCount = userDao.getUserCount("Admin",companyId);
int totalLeadCount = leadDao.getTotalLeadsCountByCompanyId(companyId);
List<String> listEmail = userDao.getAllEmailByIsAdmin("User", "Admin");

Connection connect = DatabaseConnection.getConnection();
%>
<html>
	<head>
		<title></title>
		<%@include file="./common/jsp/superadminhead.jsp" %>
</head>
<body>
	<%response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // Preventing from back after logout.
		if(session.getAttribute("email") == null){%>
		<script type="text/javascript">
			alert('You are no longer logged in');
		</script>
	<%}%>
	<%if (request.getAttribute("messages") != null) {%>
		<script>swal('Thank You!', 'We will get in touch soon!', 'success')</script>
	<%}%>
	
	<%@include file="./common/jsp/superadminsidebar.jsp" %>
	<div id="main">
		<%@include file="./common/jsp/superadminnavbar.jsp" %>
		<%@include file="./common/jsp/superadmin-count-card.jsp" %>
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">Update Lead</p>
		</div>
		<hr class="divide">
		
		<div class="main-container">
			<div class="p-2">
				<%try{
				String already = (String)session.getAttribute("updateMsg");
				if(already != null){ %>
					<div class='alert alert-success alert-dismissible fade show'>
						<%= already %>
					</div>
				<% 
				session.removeAttribute("updateMsg");
				}
				}catch(Exception e){
					e.printStackTrace();
				} %>
				
				<%try{
				String emailUpdateMsg = (String)session.getAttribute("emailUpdateMsg");
				if(emailUpdateMsg != null){ %>
					<div class='alert alert-success alert-dismissible fade show'>
						<%= emailUpdateMsg %>
					</div>
				<% 
				session.removeAttribute("emailUpdateMsg");
				}
				}catch(Exception e){
					e.printStackTrace();
				} %>
				
				<%try{
				String mobileUpdateMsg = (String)session.getAttribute("mobileUpdateMsg");
				if(mobileUpdateMsg != null){ %>
					<div class='alert alert-success alert-dismissible fade show'>
						<%= mobileUpdateMsg %>
					</div>
				<% 
				session.removeAttribute("mobileUpdateMsg");
				}
				}catch(Exception e){
					e.printStackTrace();
				} %>
				</div>
				<form action = "updateSuperAdminAllLeads" method = "post">
					<input type="text" name="id" value="<%= leadId %>" hidden="true"/>
					<div class="row p-3">
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Name</label>
							<input class="form-control" type = "text" name = "name" value = "<%=lead.getName()%>" required/>
						</div>
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Email</label>
							<input class="form-control" type = "email" name = "email" value = "<%=lead.getEmail()%>" required/>
						</div>
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Notes</label>
							<input class="form-control" type = "text" name = "address" value = "<%=lead.getAddress()%>" required/>
						</div>
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Mobile</label>
							<input class="form-control" type = "tel" name = "mobile" maxlength= "10" value = "<%=lead.getMobile()%>" required/>
						</div>
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Source</label>
							<input class="form-control" type = "text" name = "source" value = "<%=lead.getSource()%>" required/>
						</div>
						<div hidden="true">
							<input type = "email" name = "owner"  value = "<%=lead.getOwner()%>"  hidden="true" required/>
						</div>
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Current Owner</label>
							<select class="form-control" name = "currentOwner" required>
								<option selected> <%=lead.getCurrentowner()%></option>
								<%for(String x : listEmail){
									if(!lead.getCurrentowner().equals(x)){
								%>
									<option value="<%= x %>"><%= x %></option>
								<%}
								}%>
							</select>
						</div>
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Status</label>
							<select class="form-control" name = "status" required>
								<option selected ><%= lead.getStatus() %></option>
								<%if(!lead.getStatus().equals("New")){ %><option value="New">New</option><%} %>
								<%if(!lead.getStatus().equals("Not Interested")){ %><option value="Not Interested">Not Interested</option><%} %>
								<%if(!lead.getStatus().equals("In Conversation")){ %><option value="In Conversation">In Conversation</option><%} %>
								<%if(!lead.getStatus().equals("Follow Up")){ %><option value="Follow Up">Follow Up</option><%} %>
								<%if(!lead.getStatus().equals("DNP")){ %><option value="DNP">DNP</option><%} %>
								<%if(!lead.getStatus().equals("Not Reachable")){ %><option value="Not Reachable">Not Reachable</option><%} %>
								<%if(!lead.getStatus().equals("Mobile Switched Off")){ %><option value="Mobile Switched Off">Mobile Switched Off</option><%} %>
								<%if(!lead.getStatus().equals("Not Working")){ %><option value="Not Working">Not Working</option><%} %>
								<%if(!lead.getStatus().equals("Already Enrolled")){ %><option value="Already Enrolled">Already Enrolled</option><%} %>
							</select>
						</div>
						<div class="col-12 mt-2 w-100 d-flex justify-content-center">
							<button type= "submit" class="submit-btn w-50 fw-bold">Update Lead</button>
						</div>
					</div>
				</form>
			</div>
		</div>	
		
		</div>

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script>

	  $(".nav").click(function(){
	    $("#mySidenav").css('width','70px');
	    $("#main").css('margin-left','70px');
	    $(".logo").css('visibility', 'hidden');
	    $(".logo span").css('visibility', 'visible');
	     $(".logo span").css('margin-left', '-10px');
	     $(".icon-a").css('visibility', 'hidden');
	     $(".icons").css('visibility', 'visible');
	     $(".icons").css('margin-left', '-8px');
	      $(".nav").css('display','none');
	      $(".nav2").css('display','block');
	  });

	$(".nav2").click(function(){
	    $("#mySidenav").css('width','300px');
	    $("#main").css('margin-left','300px');
	    $(".logo").css('visibility', 'visible');
	     $(".icon-a").css('visibility', 'visible');
	     $(".icons").css('visibility', 'visible');
	     $(".nav").css('display','block');
	      $(".nav2").css('display','none');
	 });

	</script>
	
	</body>

</body>
</html>