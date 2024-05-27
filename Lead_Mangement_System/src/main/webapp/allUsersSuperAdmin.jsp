<%@page import="in.pandit.dao.CompanyDao"%>
<%@page import="in.pandit.dao.SuperAdminDao"%>
<%@page import="java.util.List"%>
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
SuperAdminDao superAdminDao = new SuperAdminDao();
CompanyDao companyDao = new CompanyDao();

User userCookie = CookiesHelper.getUserCookies(request, "user");
if(!"Superadmin".equals(userCookie.getIsAdmin())){
	session.setAttribute("error","You are not super admin!");
	response.sendRedirect("index.jsp");
}
int userCount = superAdminDao.getUserCount("User");
int companyCount = companyDao.getAllCompanyCount();
int adminCount = superAdminDao.getUserCount("Admin");
int totalLeadCount = superAdminDao.getTotalLeadsCount();
Connection connect = DatabaseConnection.getConnection();
int currentPage = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;
int itemsPerPage = 10;
int totalPages = (int) Math.ceil((double) userCount / itemsPerPage);
List<User> userList = superAdminDao.getAllUserByLimitAndOffset(itemsPerPage, (currentPage - 1) * itemsPerPage,"User");

%>
<!Doctype HTML>
<html>
<head>
	<title>All Users</title>
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
			<p class="fs-2 text-white box-heading">All User</p>
		</div>	
		<hr class="divide">
		<div class="main-container">
			<div class="p-2 overflow-x-scroll">
				<% try{
					String updateMsg = (String)session.getAttribute("updateMsg"); 
					if(updateMsg!= null){%>
						<div class='alert alert-danger alert-dismissible fade show'>
							<%=updateMsg %>
						</div>
				<%}
					session.removeAttribute("updateMsg");
				}catch(Exception e){
					e.printStackTrace();
				}
				if(userList.size()>0){
				%>
			
				<table class="table table-dark table-striped table-hover">
					<thead>
						<tr>
							<th>User Id</th>
							<th>Company Id</th>
							<th>Name</th>
							<th>Email</th>
							<th>Mobile</th>
							<th>All Comments</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody>
						<% for(User u :userList){ %>
						<tr>
							<td><%= u.getId() %></td>
							<td><%= u.getCompanyId() %></td>
							<td><%= u.getName() %></td>
							<td><%= u.getEmail() %></td>
							<td><%= u.getMobile() %></td>
							<td>
								<a class = 'submit-btn all-comments-btn btn' style="text-decoration: none;width:100%;"  href="/Lead_Mangement_System/show-user-comment-by-superadmin.jsp?userid=<%= u.getId()%>">View</a>
							</td>
							<td>
								<form action ='update-user-super-admin.jsp' method = 'post'>
									<button type = 'submit' class = 'submit-btn w-100' name = 'update' value ="<%= u.getEmail() %>">Update</button>
								</form>
								<button class = 'submit-btn w-100 mt-2' name = 'delete' onclick='myFunction("<%= u.getId() %>")'>Delete</button>
							</td>
						</tr>
					<%}%>
   				</tbody>
			</table>
			<%}else{%>
				<div class="pe-2 ps-2">
					<p class="fs-2 text-white box-heading text-center">No User</p>
				</div>
			<%}%>
<!--		Start Pagination -->
			<div>
			    <% if (currentPage > 1) { %>
			        <a class="btn btn-primary" style="padding: 2px 4px; text-decoration: none;" href="?page=<%= currentPage - 1 %>"> &lt; Previous</a>
			    <% } %>
			    <% if (currentPage < totalPages) { %>
			        <a class="btn btn-primary" style="padding: 2px 4px; text-decoration: none;" href="?page=<%= currentPage + 1 %>">Next &gt;</a>
			    <% } %>
			</div>
			</div>
		</div>
	</div>

	<%@include file="./common/jsp/superadminfooter.jsp" %>
	<script>
	/* Alert message code */
	$(document).ready(function () {  
	    $(".close").click(function () {  
	        $("#myAlert").alert("close");  
	    });  
	});
	/* Delete confirmation alert */
	function myFunction(id) {
		if(confirm("Are you sure want to delete?") == true){
			window.location.href = "/Lead_Mangement_System/DeleteSuperAdminUsers?delete="+id ;
		}else{
			alert("Canceled!");
			
		}
	}
	</script>
</body>
</html>