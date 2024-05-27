<%@page import="in.pandit.dao.SuperAdminDao"%>
<%@page import="in.pandit.model.Company"%>
<%@page import="in.pandit.dao.CompanyDao"%>
<%@page import="in.pandit.model.User"%>
<%@page import="in.pandit.helper.CookiesHelper"%>
<%@page import="in.pandit.dao.LeadDao"%>
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
User userCookie = CookiesHelper.getUserCookies(request, "user");
if(!"Superadmin".equals(userCookie.getIsAdmin())){
	session.setAttribute("error","You are not super admin!");
	response.sendRedirect("index.jsp");
}
LeadDao leadDao = new LeadDao();
SuperAdminDao superAdminDao = new SuperAdminDao();
CompanyDao companyDao = new CompanyDao();
int companyId = Integer.parseInt((String)request.getParameter("update"));
int companyCount = companyDao.getAllCompanyCount();
int userCount = superAdminDao.getUserCount("User");
int adminCount = superAdminDao.getUserCount("Admin");
int totalLeadCount = leadDao.getTotalLeadsCount();
List<String> companyList = companyDao.getAllCompanyName();
List<Integer> companyIdList = companyDao.getAllCompanyId();
Company company = companyDao.getCompanyById(companyId);
CookiesHelper.setCookies(company, response, "company");
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
			<form action="UpdateCompany" method="post">
				<div class="row p-3">
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Company Name</label>
						<input class="form-control" type = "text" name = "company-name" value="<%= company.getCompanyName() %>" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Company Address</label>
						<input class="form-control" type = "text" name = "company-address" value="<%= company.getCompanyAddress() %>" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Manager Name</label>
						<input class="form-control" type = "text" name = "manager-name"  value="<%= company.getManagerName() %>" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Manager Contact</label>
						<input class="form-control" type = "tel" name = "manager-contact" value="<%= company.getManagerContact() %>" maxlength= "10" required/>
					</div>
					<div class="col-6 d-flex flex-column text-white">
						<label class="fs-5 mb-2 mt-3">Manager Email</label>
						<input class="form-control" type="email" name = "manager-email" value="<%= company.getManagerEmail() %>" required/>
					</div>
					<div class="col-12 mt-2 w-100 d-flex justify-content-center">
						<button type= "submit" class="submit-btn w-50 fw-bold">Update Company</button>
					</div>
				</div>
			</form>
		</div>
	</div>
		
	<%@include file="./common/jsp/superadminfooter.jsp" %>
</body>
</html>