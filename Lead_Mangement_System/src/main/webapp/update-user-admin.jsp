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
<%@page import = "java.text.SimpleDateFormat" %>
<%@page import = "java.util.Date" %>
<%
	UserDao userDao = new UserDao();
	LeadDao leadDao = new LeadDao();
	String userEmail = request.getParameter("update").trim();
	User userCookie = CookiesHelper.getUserCookies(request, "user"); 
	int companyId = userCookie.getCompanyId();
	User user = userDao.getUserByEmail(userEmail,companyId);
	CookiesHelper.setCookies(user, response, "userInfo");
	int totalLeadCount = leadDao.getTotalLeadsCountByCompanyId(companyId);
	int totalLeadCountByFacebookSource = leadDao.getLeadsCountUsingSourceAndCompany("facebook", companyId);
	int totalLeadCountByGoogleSource = leadDao.getLeadsCountUsingSourceAndCompany( "google",companyId);
	int userCount = userDao.getUserCount("User", companyId);
	Connection connect = DatabaseConnection.getConnection();
	
%>
<!Doctype HTML>
	<html>
	<head>
		<title>All Admin</title>
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
			<p class="fs-2 text-white box-heading">Update User</p>
		</div>
		<hr class="divide">
		<div class="main-container">
			<div class="p-2">
				<%try{
					String already = (String)session.getAttribute("update");
					if(already != null){ %>
						<div class='alert alert-success alert-dismissible fade show'>
							<%= already %>
						</div>
					<% 
					session.removeAttribute("update");
					}
				}catch(Exception e){
					e.printStackTrace();
				} %>
			</div>
			<form action = "UpdateUserByAdmin" method = "post">
				<div class="row p-3">
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Name</label>
						<input class="form-control" type = "text" name = "name" value="<%= user.getName()%>" placeholder="User name" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Mobile</label>
						<input class="form-control" type = "tel" name = "mobile" value="<%= user.getMobile()%>" placeholder="User mobile" maxlength= "10" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Email</label>
						<input class="form-control" type = "email" value="<%= user.getEmail() %>" name = "email" placeholder="User email" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Gender</label>
						<select name = "gender"  class="form-control">
							<option value="<%= user.getGender() %>"><%= user.getGender() %></option>
							<%if(!user.getGender().equals("Male")){ %><option value="Male">Male</option><%} %>
							<%if(!user.getGender().equals("Female")){ %><option value="Female">Female</option><%} %>
							<%if(!user.getGender().equals("Other")){ %><option value="Other">Other</option><%} %>
						</select>
					</div>
					<div class="col-12 mt-2 w-100 d-flex justify-content-center">
						<button type= "submit" class="submit-btn w-50 fw-bold">Update</button>
					</div>
				</div>
			</form>
		</div>
	</div>
<script>
/* Alert message code */
$(document).ready(function () {  
           $(".close").click(function () {  
               $("#myAlert").alert("close");  
           });  
       });
       
/* Delete confirmation alert */
function myFunction() {
		confirm("Are you sure want to delete?");
	}
	</script>
	<%@include file="./common/jsp/adminfooter.jsp" %>
</body>
</html>