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
String namedb = null;
String emaildb = null;


%>
<%
LeadDao leadDao = new LeadDao();
UserDao userDao = new UserDao();

User userCookie = CookiesHelper.getUserCookies(request, "user");
int companyId = userCookie.getCompanyId();
int totalLeadCount = leadDao.getTotalLeadsCountByCompanyId(companyId);
int totalLeadCountByNew = leadDao.getLeadsCountNewLeadsByCompanyId(companyId);
int totalLeadCountByInterview = leadDao.getUserInterviewLeadsCount(userCookie.getEmail(), companyId, "Interview");
int totalLeadCountByAdded = leadDao.getUserInterviewLeadsCount(userCookie.getEmail(), companyId, "Added in Batch");
int totalLeadCountByStatusFinished = leadDao.getUserInterviewLeadsCount(userCookie.getEmail(), companyId, "Already Enrolled");	
int leadid = Integer.parseInt(request.getParameter("leadid"));
Connection connect = DatabaseConnection.getConnection();
List<String> lst1 = userDao.getAllEmailByIsAdminAndCompanyId("Admin", "User", companyId);
Lead lead = leadDao.getLeadById(leadid);
%>
<html>
	<head>
		<title>Add Comment</title>
		<link rel="icon" href="image/xyz.jfif">
		<%@include file="./common/jsp/head.jsp" %>
</head>
<body>
	<%response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // Preventing from back after logout.
		if(session.getAttribute("email") == null){%>
		<script type="text/javascript">
			alert('You are no longer logged in');
		</script>
	<%response.sendRedirect("index.jsp");}%>
	<%if (request.getAttribute("messages") != null) {%>
	<script>swal('Thank You!', 'We will get in touch soon!', 'success')</script>
	<%}%>
	
	<%@include file="./common/jsp/sidebar.jsp" %>
	<div id="main">
		<%@include file="./common/jsp/navbar.jsp" %>
		<%@include file="./common/jsp/count-card.jsp" %>
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">Add New Comment</p>
		</div>
		<hr class="divide">
		<div class="main-container">
			<form action ="AddComment" method="post" class="form-container">
			    <div class="form-inner-container"  hidden="true">
			    	<label  hidden="true">Lead Id</label>
			    	<input  hidden="true" type="text" name="leadid" value="<%= leadid %>" placeholder="Enter lead id" required="required"/>
			    </div>
			    <div class="form-inner-container">
			    	<label>Comment</label>
			    	<textarea class="form-control" rows="5" name="comment" placeholder="Enter Your Comment" required="required"></textarea>
			    </div>
			    <div class="form-inner-container">
			    	<label class="fs-5 mb-2 mt-2">Lead Status</label>
					<select name = "status" class="form-control" required>
						<option selected ><%= lead.getStatus()%></option>
						<%if(!lead.getStatus().equals("New")){ %><option value="New">New</option><%} %>
						<%if(!lead.getStatus().equals("Not Interested")){ %><option value="Not Interested">Not Interested</option><%} %>
						<%if(!lead.getStatus().equals("In Conversation")){ %><option value="In Conversation">In Conversation</option><%} %>
						<%if(!lead.getStatus().equals("Follow Up")){ %><option value="Follow Up">Follow Up</option><%} %>
						<%if(!lead.getStatus().equals("Interview")){ %><option value="Interview">Interview</option><%} %>
						<%if(!lead.getStatus().equals("Added in Batch")){ %><option value="Added in Batch">Added in Batch</option><%} %>
						<%if(!lead.getStatus().equals("DNP")){ %><option value="DNP">DNP</option><%} %>
						<%if(!lead.getStatus().equals("Not Reachable")){ %><option value="Not Reachable">Not Reachable</option><%} %>
						<%if(!lead.getStatus().equals("Mobile Switched Off")){ %><option value="Mobile Switched Off">Mobile Switched Off</option><%} %>
						<%if(!lead.getStatus().equals("Not Working")){ %><option value="Not Working">Not Working</option><%} %>
						<%if(!lead.getStatus().equals("Already Enrolled")){ %><option value="Already Enrolled">Already Enrolled</option><%} %>
					</select>
			    </div>
			    <div class="form-inner-container">
			    	<label class="fs-5 mb-2 mt-2">Assign to:</label>
					<select class="form-control" name = "currentOwner" required>
							<option selected><%= lead.getCurrentowner()%> </option>
							<%for(String x : lst1){%>
							<option><%=x %></option>
							<%}%>
						</select>
			    </div>
			    <hr>
			    <div class="btn-container">
					<input type="submit" class="submit-btn" value="Submit"/>
			    </div>
			</form>
		</div>
	</div>	
<%@include file="./common/jsp/footer.jsp" %>
</body>
</html>