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
User userCookie = CookiesHelper.getUserCookies(request, "user");
int companyId = userCookie.getCompanyId();
int totalLeadCountByStatusFinished = leadDao.getLeadsCountUsingCompanyIdAndStatus(companyId, "Already Enrolled");
int totalLeadCount = leadDao.getTotalLeadsCountByCompanyId(companyId);
int totalLeadCountBySource = leadDao.getLeadsCountUsingSourceFacebookOrGoogleAndCompanyId(companyId);
int totalLeadCountNewLeads = leadDao.getLeadsCountNewLeadsByCompanyId(companyId);
Connection connect = DatabaseConnection.getConnection();

%>
<!Doctype HTML>
	<html>
	<head>
		<title></title>
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
		<p class="fs-2 text-white box-heading">Get In Touch</p>
	</div>
	<hr class="divide">
	<div class="main-container">
		<div class="p-2">
			<%try{
			String help = (String)session.getAttribute("help");
			if(help != null){ %>
					<div class='alert alert-success alert-dismissible fade show'>
						<%= help %>
					</div>
			<% 
				session.removeAttribute("help");
				}
			}catch(Exception e){
				e.printStackTrace();
			} %>
		</div>
		<form action="help" method="post">
				<div  class = "getInTouch mb-2">
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
<%@include file="./common/jsp/footer.jsp" %>
</body>
</html>