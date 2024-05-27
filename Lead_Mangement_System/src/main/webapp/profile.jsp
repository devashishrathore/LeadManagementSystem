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
<%@page import ="java.text.SimpleDateFormat"%>
<%@page import = "java.util.Date"  %>
<%@page import = "java.sql.Blob" %>
<%@page import = "java.io.OutputStream" %>
<%@page import = "java.io.*" %>
<%@page import = "java.text.SimpleDateFormat" %>
<%@page import = "java.util.Date" %>
<%
String gender = null;

%>
<%
UserDao userDao = new UserDao();
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
						String userMsg = (String)session.getAttribute("userMsg");
						if(userMsg != null){ %>
						<div class='alert alert-success alert-dismissible fade show'>
							<%= userMsg %>
						</div>
						<% 
						session.removeAttribute("userMsg");
						}
					}catch(Exception e){
						e.printStackTrace();
					} %>
				<div class="user-info-container p-4 gap-2"> 	
				<% User getUserByEmail = userDao.getUserByEmail(userCookie.getEmail()); %>
					<div class="d-flex flex-column text-white info-container">
						<h3>Name</h3>
						<h5 style = "color: white;"><%=getUserByEmail.getName() %></h5>
					</div>
					<div class="d-flex flex-column text-white info-container">
						<h3>Email</h3>
						<h5 style = "color: white;"><%= getUserByEmail.getEmail() %></h5>
					</div>
					<div class="d-flex flex-column text-white info-container">
						<h3>Mobile</h3>
						<h5 style = "color: white;"><%= getUserByEmail.getMobile()%></h5>
					</div>
					<div class="d-flex flex-column text-white info-container">
						<h3>Gender</h3>
						<h5 style = "color: white;"><%= getUserByEmail.getGender()%></h5>
					</div>
					<div class="d-flex flex-column text-white info-container">
						<h3>User Id</h3>
						<h5 style = "color: white;"><%= getUserByEmail.getId()%></h5>
					</div>
				</div>
				<form action = "updateProfileForm.jsp" method = "post" class="w-100 d-flex align-items-center justify-content-center mb-5">
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
<%@include file="./common/jsp/footer.jsp" %>
</body>
</html>