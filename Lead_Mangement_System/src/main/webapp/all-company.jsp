<%@page import="in.pandit.model.Company"%>
<%@page import="java.util.List"%>
<%@page import="in.pandit.dao.CompanyDao"%>
<%@page import="in.pandit.persistance.DatabaseConnection"%>
<%@page import="java.sql.Connection"%>
<%@page import="in.pandit.dao.LeadDao"%>
<%@page import="in.pandit.helper.CookiesHelper"%>
<%@page import="in.pandit.model.User"%>
<%@page import="in.pandit.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
int currentPage = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;
int itemsPerPage = 10;
int totalPages = (int) Math.ceil((double) companyCount / itemsPerPage);
List<Company> list = companyDao.getAllCompany(itemsPerPage, (currentPage - 1) * itemsPerPage);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>All Company</title>
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
					<span>All Companies</span>
				</div>
				<i class="fa fa-building box-icon" aria-hidden="true"></i>
			</div>
		</div>
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">All Company</p>
		</div>	
		<hr class="divide">
		<div class="main-container">
			<div class="p-2 overflow-x-scroll">
					<% try{
						String superAdminMsg = (String)session.getAttribute("company-register"); 
						if(superAdminMsg!= null){%>
						<div class='alert alert-danger alert-dismissible fade show'>
							<%=superAdminMsg %>
						</div>
						<%}
							session.removeAttribute("company-register");
						}catch(Exception e){
							e.printStackTrace();
						}%>
					<table class="table table-dark table-striped table-hover">
	  					<thead>
							<tr>
								<th>Company Id</th>
								<th>Company Name</th>
								<th>Company Address</th>
								<th>Manager Name</th>
								<th>Manager Email</th>
								<th>Manager Contact</th>
								<th colspan="2">Action</th>
							</tr>
	  					</thead>
		  				<tbody>
			  			<%
			  			for(Company c : list){
						%>				
							<tr>
							<td><%=c.getCompanyId() %></td>
							<td><%=c.getCompanyName() %></td>
							<td><%=c.getCompanyAddress() %></td>
							<td><%=c.getManagerName() %></td>
							<td><%=c.getManagerEmail() %></td>
							<td><%=c.getManagerContact() %></td>
							<td>
								<form action ='update-company.jsp' method='post'>
									<button type='submit' class = 'submit-btn w-100'  name = 'update' value="<%= c.getCompanyId() %>">Update</button>
								</form>
								<button type='submit' class = "submit-btn w-100 mt-2" name = 'delete' onclick='deleleCompany("<%= c.getCompanyId() %>")'>Delete</button>
								
							</td>
							</tr>	
							<%} %>
		   				</tbody>
					</table>
				<div>
				    <% if (currentPage > 1) { %>
				        <a class="submit-btn" style="padding: 2px 4px; text-decoration: none;" href="?page=<%= currentPage - 1 %>"> &lt; Previous</a>
				    <% } %>
				    <% if (currentPage < totalPages) { %>
				        <a class="submit-btn" style="padding: 2px 4px; text-decoration: none;" href="?page=<%= currentPage + 1 %>">Next &gt;</a>
				    <% } %>
				</div>
			</div>
		</div>
	</div>	
	<script>
	function deleleCompany(id) {
		if(confirm("Are you sure want to delete?") == true){
			window.location.href = "/Lead_Mangement_System/DeleteCompany?delete="+id ;
		}else{
			alert("Canceled!");
		}
	}
	</script>
	<%@include file="./common/jsp/superadminfooter.jsp" %>
</body>
</html>