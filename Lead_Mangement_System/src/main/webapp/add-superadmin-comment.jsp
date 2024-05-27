<%@page import="in.pandit.dao.CompanyDao"%>
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


%>
<%
LeadDao leadDao = new LeadDao();
UserDao userDao = new UserDao();
CompanyDao companyDao = new CompanyDao();

User userCookie = CookiesHelper.getUserCookies(request, "user");
int companyCount = companyDao.getAllCompanyCount();
int userCount = userDao.getUserCount("User");
int adminCount = userDao.getUserCount("Admin");
int totalLeadCount = leadDao.getTotalLeadsCount();
%>
<html>
	<head>
		<title>User Dashboard</title>
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
		<hr class="divide">
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading ">Add Comment</p>
		</div>
		<hr class="divide">
		<div class="main-container">
			<div class="p-2">
				<%try{
			String comment = (String)session.getAttribute("comment");
			if(comment != null){ %>
					<div class='alert alert-success alert-dismissible fade show'>
						<%= comment %>
					</div>
			<% 
				session.removeAttribute("comment");
				}
			}catch(Exception e){
				e.printStackTrace();
			} %>
			</div>
			<form action ="AddSuperAdminComment" method="post" class="form-container">
			    <div class="form-inner-container"  hidden="true">
		    	<label  hidden="true">Lead Id</label>
		    	<input  hidden="true" type="text" name="leadid" value="<%= request.getParameter("leadid") %>" required="required"/>
		    </div>
		    <div class="form-inner-container">
		    	<label>Comment</label>
		    	<textarea rows="5" class="form-control" name="comment" placeholder="Enter Your Comment" required="required"></textarea>
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