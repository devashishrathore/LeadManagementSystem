<%@page import="in.pandit.dao.CompanyDao"%>
<%@page import="in.pandit.model.Lead"%>
<%@page import="in.pandit.dao.LeadDao"%>
<%@page import="in.pandit.helper.CookiesHelper"%>
<%@page import="in.pandit.model.User"%>
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
String namedb = null;
String emaildb = null;
String commentId = request.getParameter("comment-id");
String userId = request.getParameter("user-id");
String userEmail = request.getParameter("user-email");
String comment = request.getParameter("comment");
String email = (String)session.getAttribute("email");
if(!userEmail.equals(email)) {
	response.sendRedirect("allLeadsSuperAdmin.jsp");
}

%>
<%
UserDao userDao = new UserDao();
LeadDao leadDao = new LeadDao();
CompanyDao companyDao = new CompanyDao();
User userCookie = CookiesHelper.getUserCookies(request, "user");
int companyId = userCookie.getCompanyId();
int companyCount = companyDao.getAllCompanyCount();
int userCount = userDao.getUserCount("User", companyId);
int adminCount = userDao.getUserCount("Admin",companyId);
int totalLeadCountByStatusFinished = leadDao.getLeadsCountUsingCompanyIdAndStatus(companyId, "Already Enrolled");
int totalLeadCount = leadDao.getTotalLeadsCountByCompanyId(companyId);
int leadId = (Integer)session.getAttribute("leadid");
Lead lead = leadDao.getLeadById(leadId);
Connection connect = DatabaseConnection.getConnection();
%>
<html>
	<head>
		<title>Update Comment</title>
		<link rel="icon" href="image/xyz.jfif">
		<%@include file="./common/jsp/superadminhead.jsp" %>
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
	
	<%@include file="./common/jsp/superadminsidebar.jsp" %>
	<div id="main">
		<%@include file="./common/jsp/superadminnavbar.jsp" %>
		<%@include file="./common/jsp/superadmin-count-card.jsp" %>
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">Update Comment</p>
		</div>
		<hr class="divide">
		<div class="main-container">
			<form action ="UpdateSuperAdminComment" method="post" class="form-container">
			    <div class="form-inner-container" hidden="true">
			    	<input  hidden="true" type="text" name="comment-id" value="<%= commentId %>"  required="required" />
			    </div>
			    <div class="form-inner-container">
			    	<label>Comment</label>
			    	<textarea rows="5" class="form-control" name="comment" required="required"><%= comment  %></textarea>
			    </div>
			    <div class="form-inner-container">
			    	<label class="fs-5 mb-2 mt-2">Lead Status</label>
					<select name = "status" class="form-control" required>
						<option selected ><%= lead.getStatus()%></option>
					</select>
			    </div>
			    <div class="btn-container">
					<input type="submit" class="submit-btn" value="Submit"/>
			    </div>
			</form>
		</div>
	</div>	
<%@include file="./common/jsp/superadminfooter.jsp" %>
</body>
</html>