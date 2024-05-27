<%@page import="in.pandit.dao.CompanyDao"%>
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
<%@page import = "java.text.SimpleDateFormat" %>
<%@page import = "java.util.Date" %>
<%
LeadDao leadDao = new LeadDao();

UserDao userDao = new UserDao();
CompanyDao companyDao = new CompanyDao();
int userCount = userDao.getUserCount("User");
int adminCount = userDao.getUserCount("Admin");
int companyCount = companyDao.getAllCompanyCount();
User userCookie = CookiesHelper.getUserCookies(request, "user");
if(!"Superadmin".equals(userCookie.getIsAdmin())){
	session.setAttribute("error","You are not super admin!");
	response.sendRedirect("index.jsp");
}
int totalLeadCount = leadDao.getTotalLeadsCount();
Connection connect = DatabaseConnection.getConnection();
%>
<!Doctype HTML>
<html>
<head>
	<title>Help</title>
	<%@include file="./common/jsp/superadminhead.jsp" %>
</head>
<body>
	<%response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // Preventing from back after logout.
	if(session.getAttribute("email") == null){%>
	<script type="text/javascript">
		alert('You are no longer logged in');
	</script>
	<%}%>
	<%@include file="./common/jsp/superadminsidebar.jsp" %>
	<div id="main">
		<%@include file="./common/jsp/superadminnavbar.jsp" %>
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
					<span  class="fs-2 fw-bold"><%= adminCount %></span>
					<span>All Admins</span>
				</div>
					<i class="fa fa-user-circle box-icon"></i>
			</div>
			<div class="d-flex text-white align-items-center justify-content-around status-card">
				<div class="d-flex flex-column">
					<span  class="fs-2 fw-bold"><%= companyCount %></span>
					<span>All Company</span>
				</div>
				<i class="fa fa-building box-icon" aria-hidden="true"></i>
			</div>
		</div>
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">Get In Touch</p>
		</div>
		<hr class="divide">
		<div class="main-container p-2">
			<form action = "helpSuperAdmin" method = "post">
				<div  class = "getInTouch">
					<div>
						<label>Name</label>
						<input class="form-control" type = "text" name = "name" placeholder = "Your name" value="<%=userCookie.getName() %>"/>
					</div>
					<div>
						<label>Email</label>
						<input class="form-control" type = "email" name = "email" placeholder = "Your email" value="<%=userCookie.getEmail() %>"/>
					</div>
					<div>
						<label>Mobile</label>
						<input class="form-control" class="form-control" type = "tel" name = "mobile" placeholder = "Your mobile" maxlength = "10" value="<%=userCookie.getMobile() %>"/>
					</div>
					<div>
						<label>Subject</label>
						<input  class="form-control" type = "text" name = "subject" placeholder = "Enter Subject"/>
					</div>
					<div>
						<label>Comments</label>
						<textarea class="form-control" name = "comments" rows="5" cols="35" placeholder = "Write you message here"></textarea>
					</div>
					<button  type = "submit" class = "submit-btn">Send</button>
				</div>
			</form>		
		</div>	
	</div>
	<%@include file="./common/jsp/superadminfooter.jsp" %>
</body>
</html>