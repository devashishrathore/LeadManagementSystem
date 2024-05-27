<%@page import="in.pandit.model.Lead"%>
<%@page import="in.pandit.dao.UserDao"%>
<%@page import="in.pandit.dao.LeadDao"%>
<%@page import="in.pandit.model.User"%>
<%@page import="in.pandit.helper.CookiesHelper"%>
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
UserDao userDao = new UserDao();
LeadDao leadDao = new LeadDao();
int leadId = Integer.parseInt(request.getParameter("update"));
User userCookie = CookiesHelper.getUserCookies(request, "user");
if(!"Admin".equals(userCookie.getIsAdmin())){
	session.setAttribute("error","You are not admin!");
	response.sendRedirect("index.jsp");
}
int companyId = userCookie.getCompanyId();
Lead lead = leadDao.getLeadById(leadId);
CookiesHelper.setCookies(lead, response, "lead");
int totalLeadCount = leadDao.getTotalLeadsCountByCompanyId(companyId);
int totalLeadCountByFacebookSource = leadDao.getLeadsCountUsingSourceAndCompany("facebook", companyId);
int totalLeadCountByGoogleSource = leadDao.getLeadsCountUsingSourceAndCompany( "google",companyId);
int userCount = userDao.getUserCount("User", companyId);
Connection connect = DatabaseConnection.getConnection();
List<String> listEmail = userDao.getAllEmailByIsAdminAndCompanyId("User", "Admin", companyId);
	
%>
<html>
	<head>
		<title></title>
		<%@include file="./common/jsp/adminhead.jsp" %>
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
	<%@include file="./common/jsp/adminsidebar.jsp" %>
	<div id="main">
		<%@include file="./common/jsp/adminnavbar.jsp" %>
	<div class="mt-3 mb-3 status-card-cantainer">
			<div class="d-flex text-white align-items-center justify-content-around status-card">
				<div class="d-flex flex-column">
					<span class="fs-2 fw-bold"><%= totalLeadCount %> </span>
					<span>Total Leads</span>
				</div>
				<i class="fa fa-line-chart box-icon"></i>
			</div>
			<div class="d-flex text-white align-items-center justify-content-around status-card">
				<div class="d-flex flex-column">
					<span  class="fs-2 fw-bold"><%= userCount %></span>
					<span>All Users</span>
				</div>
				<i class="fa fa-users box-icon"></i>
			</div>
			<div class="d-flex text-white align-items-center justify-content-around status-card">
				<div class="d-flex flex-column">
					<span  class="fs-2 fw-bold"><%= totalLeadCountByFacebookSource %></span>
					<span>Facebook Leads</span>
				</div>
				<i class="fa fa-facebook-square box-icon"></i>
			</div>
			<div class="d-flex text-white align-items-center justify-content-around status-card">
				<div class="d-flex flex-column">
					<span  class="fs-2 fw-bold"><%= totalLeadCountByGoogleSource %></span>
					<span>Google Leads</span>
				</div>
				<i class="fa fa-google-plus box-icon"></i>
			</div>
		</div>
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">Update Lead</p>
		</div>
		<hr class="divide">
		<div class="main-container">
			<div class="p-2">
				<%try{
				  String adminMsg = (String)session.getAttribute("adminMsg");
				if(adminMsg != null){ %>
					<div class='alert alert-success alert-dismissible fade show'>
						<%= adminMsg %>
					</div>
				<% 
				session.removeAttribute("adminMsg");
				}
				}catch(Exception e){
					e.printStackTrace();
				} %>
				</div>
				<form action = "updateAdminAllLeads" method = "post">
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
							<label class="fs-5 mb-2 mt-3">Mobile</label>
							<input class="form-control" type = "tel" name = "mobile" maxlength= "10" value = "<%=lead.getMobile()%>" required/>
						</div>
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Source</label>
							<input class="form-control" type = "text" name = "source" value = "<%=lead.getSource()%>" required/>
						</div>
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Education </label>
							<input class="form-control" type = "text" name = "education" value = "<%=lead.getEducation() %>" placeholder="Lead Education" required/>
						</div>
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Experience </label>
							<input class="form-control" type = "text" name = "experience" value = "<%=lead.getExperience()%>" placeholder="Lead Experience" required/>
						</div>
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Salary in LPA </label>
							<input class="form-control" type = "number" name = "salary" value = "<%=lead.getSalary()%>" placeholder="Lead Salary" required/>
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
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Notes </label>
							<input class="form-control" type = "text" name = "address" value = "<%=lead.getAddress()%>" required/>
						</div>
						<div class="col-12 mt-2 w-100 d-flex justify-content-center">
							<button type= "submit" class="submit-btn w-50 fw-bold">Update Lead</button>
						</div>
					</div>
				</form>
			</div>
		</div>	
		
	<%@include file="./common/jsp/adminfooter.jsp" %>
</body>
</html>