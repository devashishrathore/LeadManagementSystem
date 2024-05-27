<%@page import="in.pandit.dao.SuperAdminDao"%>
<%@page import="in.pandit.model.Company"%>
<%@page import="in.pandit.dao.CompanyDao"%>
<%@page import="in.pandit.model.User"%>
<%@page import="in.pandit.helper.CookiesHelper"%>
<%@page import="in.pandit.dao.LeadDao"%>
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
LeadDao leadDao = new LeadDao();
SuperAdminDao superAdminDao = new SuperAdminDao();
CompanyDao companyDao = new CompanyDao();
User userCookie = CookiesHelper.getUserCookies(request, "user");
if(!"Superadmin".equals(userCookie.getIsAdmin())){
	session.setAttribute("error","You are not super admin!");
	response.sendRedirect("index.jsp");
}
int companyCount = companyDao.getAllCompanyCount();
int userCount = superAdminDao.getUserCount("User");
int adminCount = superAdminDao.getUserCount("Admin");
int totalLeadCount = leadDao.getTotalLeadsCount();
List<Company> companyList = companyDao.getAllCompanyIdAndName();
Connection connect = DatabaseConnection.getConnection();
%>
<html>
<head>
	<title>Super Dashboard</title>
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
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">Add Company</p>
		</div>
		<hr class="divide">
		<div class="main-container">
			<div class="p-2">
				<%try{
				String companyRegister = (String)session.getAttribute("company-register");
				if(companyRegister != null){ %>
					<div class='alert alert-success alert-dismissible fade show'>
						<%= companyRegister %>
					</div>
				<% 
					session.removeAttribute("company-register");
					}
				}catch(Exception e){
					e.printStackTrace();
				} %>
			</div>
			<form action="AddCompanyBySuperAdmin" method="post">
				<div class="row p-3">
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Company Name</label>
						<input class="form-control" type = "text" name = "company-name" placeholder="Company Name" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Company Address</label>
						<input class="form-control" type = "text" name = "company-address" placeholder="Company Address" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Manager Name</label>
						<input class="form-control" type = "text" name = "manager-name" placeholder="Company Name" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Manager Contact</label>
						<input class="form-control" type = "tel" name = "manager-contact" placeholder="Manager Contact" maxlength= "10" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Manager Email</label>
						<input class="form-control" type="email" name = "manager-email" placeholder="Manager Email" required/>
					</div>
					<div class="col-12 mt-4 w-100 d-flex justify-content-center">
						<button type= "submit" class="submit-btn w-50 fw-bold pt-2 pb-2">Add Company</button>
					</div>
				</div>
			</form>
		</div>
		<hr class="divide">
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">Add Admin</p>
		</div>
		<hr class="divide">
		<div class="main-container">
			<div class="p-2">
			<%try{
			String adminMsg = (String)session.getAttribute("adminMsg");
			if(adminMsg != null){ %>
					<div class='alert alert-success alert-dismissible fade show'>
						<%= adminMsg %>
					</div>
			<% 
				session.removeAttribute("adminMsg");
				}
			}catch(Exception e){
				e.printStackTrace();
			} %>
			</div>
			<form action = "AddAdminBySuperAdmin" method = "post">
				<div class="row p-3">
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Name</label>
						<input class="form-control" type = "text" name = "name" placeholder="User name" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Mobile</label>
						<input class="form-control" type = "tel" name = "mobile" placeholder="User mobile" maxlength= "10" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Password</label>
						<input class="form-control" type = "password" name = "password" placeholder="Password" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Email</label>
						<input class="form-control" type = "email" name = "email" placeholder="User email" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Company Id</label>
						<select name = "company"  class="form-control" name = "company-id">
							<option selected disabled > --Select Company--</option>
							<%for(Company c : companyList){%>
							 	<option value="<%=c.getCompanyId() %>"><%= c.getCompanyId() %> - <%= c.getCompanyName() %></option>
							<%}%>
						</select>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Gender</label>
						<select class="form-control" name = "gender" required>
							<option value="Male">Male</option>
							<option value="Female">Female</option>
							<option value="Other">Other</option>
						</select>
					</div>
					<div class="col-12 mt-4 w-100 d-flex justify-content-center">
						<button type= "submit" class="submit-btn w-50 fw-bold pt-2 pb-2">Add Admin</button>
					</div>
				</div>
			</form>
		</div>
		<hr class="divide">
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading ">Add User</p>
		</div>
		<hr class="divide">
		<div class="main-container">
			<div class="p-2">
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
			</div>
			<form action = "AddUserBySuperAdmin" method = "post">
				<div class="row p-3">
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Name</label>
						<input class="form-control" type = "text" name = "name" placeholder="User name" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Mobile</label>
						<input class="form-control" type = "tel" name = "mobile" placeholder="User mobile" maxlength= "10" value="" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Password</label>
						<input class="form-control" type = "password" name = "password" placeholder="Password" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Email</label>
						<input class="form-control" type = "email" name = "email" placeholder="User email" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Company Id</label>
						<select name = "company"  class="form-control" name = "company-id">
							<option selected disabled > --Select Company--</option>
							<%for(Company c : companyList){%>
								<option value="<%=c.getCompanyId() %>"><%= c.getCompanyId() %> - <%= c.getCompanyName() %></option>
							<%}%>
						</select>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Gender</label>
						<select class="form-control" name="gender">
							<option value="Male">Male</option>
							<option value="Female">Female</option>
							<option value="Other">Other</option>
						</select>
					</div>
					<div class="col-12 mt-4 w-100 d-flex justify-content-center">
						<button type= "submit" class="submit-btn w-50 fw-bold pt-2 pb-2">Add User</button>
					</div>
				</div>
			</form>
		</div>
	</div>
		
	<%@include file="./common/jsp/superadminfooter.jsp" %>
</body>
</html>