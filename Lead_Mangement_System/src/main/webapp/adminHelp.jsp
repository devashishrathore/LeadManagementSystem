<%@page import="in.pandit.dao.UserDao"%>
<%@page import="in.pandit.dao.LeadDao"%>
<%@page import="in.pandit.helper.CookiesHelper"%>
<%@page import="in.pandit.model.User"%>
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
	User userCookie = CookiesHelper.getUserCookies(request, "user");
	if(!"Admin".equals(userCookie.getIsAdmin())){
		session.setAttribute("error","You are not admin!");
		response.sendRedirect("index.jsp");
	}
	int companyId = userCookie.getCompanyId();
	int totalLeadCount = leadDao.getTotalLeadsCountByCompanyId(companyId);
	int totalLeadCountByFacebookSource = leadDao.getLeadsCountUsingSourceAndCompany("facebook", companyId);
	int totalLeadCountByGoogleSource = leadDao.getLeadsCountUsingSourceAndCompany( "google",companyId);	
	int userCount = userDao.getUserCount("User", companyId);
	Connection connect = DatabaseConnection.getConnection();
	
%>
<!Doctype HTML>
	<html>
	<head>
		<title>Help</title>
		<%@include file="./common/jsp/adminhead.jsp" %>
</head>
<body>
	<%response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // Preventing from back after logout.
		if(session.getAttribute("email") == null){%>
		<script type="text/javascript">
			alert('You are no longer logged in');
		</script>
	<%}%>
	<%@include file="./common/jsp/adminsidebar.jsp" %>
	<div id="main">
		<%@include file="./common/jsp/adminnavbar.jsp" %>
		<%@include file="./common/jsp/admin-count-card.jsp" %>
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">Get In Touch</p>
		</div>
		<hr class="divide">
		<div class="main-container p-2">
				<form action = "helpAdmin" method = "post">
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
	<%@include file="./common/jsp/adminfooter.jsp" %>
</body>
</html>