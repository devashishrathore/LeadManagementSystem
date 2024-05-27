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
<%@page import ="java.text.SimpleDateFormat"%>
<%@page import = "java.util.Date"  %>
<%@page import = "java.sql.Blob" %>
<%@page import = "java.io.OutputStream" %>
<%@page import = "java.io.*" %>
<%@page import = "java.text.SimpleDateFormat" %>
<%@page import = "java.util.Date" %>
<%
UserDao userDao = new UserDao();
LeadDao leadDao = new LeadDao();
CompanyDao companyDao = new CompanyDao();

int userCount = userDao.getUserCount("User");
int adminCount = userDao.getUserCount("Admin");
User userCookie = CookiesHelper.getUserCookies(request, "user");
if(!"Superadmin".equals(userCookie.getIsAdmin())){
	session.setAttribute("error","You are not super admin!");
	response.sendRedirect("index.jsp");
}
int totalLeadCount = leadDao.getTotalLeadsCount();
int companyCount = companyDao.getAllCompanyCount();

Connection connect = DatabaseConnection.getConnection();
%>
<!Doctype HTML>
<html>
<head>
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
			<p class="fs-2 text-white box-heading">My Profile</p>
		</div>
		<hr class="divide">
		<div class="main-container pb-1">
			<div class="d-flex w-100 align-items-center justify-content-center">
				<%if(userCookie.getGender().equals("Male")){%>
					<img class="profile-img-update" src='image/male-av.jpg'  />	
				<%}else{%>
					<img class="profile-img-update" src='image/female-av.jpg' />	
				<%}%>
			</div>
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
			<div class="user-info-container p-4 gap-2"> 	
				<% User user = userDao.getUserByEmail(userCookie.getEmail()); %>
				<div class="d-flex flex-column text-white info-container">
					<h3>Name</h3>
					<h5 style = "color: white;"><%=user.getName() %></h5>
				</div>
				<div class="d-flex flex-column text-white info-container">
					<h3>Email</h3>
					<h5 style = "color: white;"><%= user.getEmail() %></h5>
				</div>
				<div class="d-flex flex-column text-white info-container">
					<h3>Mobile</h3>
					<h5 style = "color: white;"><%= user.getMobile()%></h5>
				</div>
				<div class="d-flex flex-column text-white info-container">
					<h3>Gender</h3>
					<h5 style = "color: white;"><%= user.getGender()%></h5>
				</div>
				<div class="d-flex flex-column text-white info-container">
					<h3>User Id</h3>
					<h5 style = "color: white;"><%= user.getId()%></h5>
				</div>
			</div>
			<form action = "updateSuperAdminProfile.jsp" method = "post" class="w-100 d-flex align-items-center justify-content-center mb-5">
				<button type= "submit" class ="submit-btn w-50">Update Profile</button>
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
 
 /* Popup for user profile */
  myButton.addEventListener("click", function () {
            myPopup.classList.add("show");
        });
        closePopup.addEventListener("click", function () {
            myPopup.classList.remove("show");
        });
        window.addEventListener("click", function (event) {
            if (event.target == myPopup) {
                myPopup.classList.remove("show");
            }
        });
 
	</script>
<%@include file="./common/jsp/superadminfooter.jsp" %>
</body>
</html>