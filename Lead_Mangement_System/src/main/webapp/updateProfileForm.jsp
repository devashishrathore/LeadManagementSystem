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
<%@page import = "java.text.SimpleDateFormat" %>
<%@page import = "java.util.Date" %>
<%
User userCookie = CookiesHelper.getUserCookies(request, "user");
UserDao userDao = new UserDao();
LeadDao leadDao = new LeadDao();
String email =  (String)session.getAttribute("email"); 
int companyId = userCookie.getCompanyId();
User user = userDao.getUserByEmail(email,companyId);
int totalLeadCount = leadDao.getTotalLeadsCountByCompanyId(companyId);
int totalLeadCountBySource = leadDao.getLeadsCountUsingSourceFacebookOrGoogleAndCompanyId(companyId);
int totalLeadCountNewLeads = leadDao.getLeadsCountNewLeadsByCompanyId(companyId);
int totalLeadCountByStatusFinished = leadDao.getLeadsCountUsingCompanyIdAndStatus(companyId, "Already Enrolled");
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
			<p class="fs-2 text-white box-heading">Update Profile</p>
		</div>
		<hr class="divide">
		<div class="main-container">
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
				<form action = "updateUserProfile" method = "post">
					<div class="row p-3">
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Name</label>
							<input class="form-control" type = "text" name = "name" value = "<%= user.getName() %>" required/>
						</div>
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Email</label>
							<input class="form-control" type = "text" name = "email" value = "<%= user.getEmail() %>" readonly/>
						</div>
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Mobile</label>
							<input class="form-control" type = "text" name = "mobile" value = "<%= user.getMobile() %>" maxlength="10" required/>
						</div>
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Gender</label>
							<select class="form-control" name = "gender" required>
								<option value="<%= user.getGender() %>"><%= user.getGender() %></option>
								<%if(!"Male".equals(user.getGender())){ %><option value="Male">Male</option><%} %>
								<%if(!"Female".equals(user.getGender())){ %><option value="Female">Female</option><%} %>
								<%if(!"Other".equals(user.getGender())){ %><option value="Other">Other</option><%} %>
							</select>
						</div>
						<div class="hidden" hidden="true">
							<input name="user-id" value = "<%= user.getId() %>" required/>
						</div>
					</div>
					<div class="col-12 mt-2 mb-2 w-100 d-flex justify-content-center">
						<button type= "submit" class ="submit-btn w-50 fw-bold">Update</button>
					</div>
				</form>
		</div>
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">Change Password</p>
		</div>
		<hr class="divide">
		<div class="main-container">
			<%try{
					String change = (String)session.getAttribute("change");
					if(change != null){ %>
					<div class='alert alert-success alert-dismissible fade show'>
						<%= change %>
					</div>
					<% 
					session.removeAttribute("change");
					}
				}catch(Exception e){
					e.printStackTrace();
				} %>
				<form action = "ChangeUserPassword" method = "post">
					<div class="row p-3">
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">Old Password</label>
							<input class="form-control" type = "password" name = "old-password"  placeholder="Enter old password" required/>
						</div>
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">New Password</label>
							<input class="form-control" type = "password" name = "new-password"  placeholder="Enter new password" required/>
						</div>
						<div class="col-6 d-flex flex-column text-white">
							<label class="fs-5 mb-2 mt-3">New Password Again</label>
							<input class="form-control" type = "password" name = "old-password-again" placeholder="Enter new password again" required/>
						</div>
						<div class="hidden" hidden="true">
							<input name="user-id" value = "<%= user.getId() %>" required/>
						</div>
					</div>
					<div class="col-12 mt-2 mb-2 w-100 d-flex justify-content-center">
						<button type= "submit" class ="submit-btn w-50 fw-bold">Change Password</button>
					</div>
				</form>
		</div>
	</div>
	<%@include file="./common/jsp/footer.jsp" %>
</body>
</html>