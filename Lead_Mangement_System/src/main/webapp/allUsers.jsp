<%@page import="java.util.List"%>
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
<%@page import="in.pandit.persistance.DatabaseConnection"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%
	
	UserDao userDao = new UserDao();
	LeadDao leadDao = new LeadDao();
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
	int currentPage = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;
	int itemsPerPage = 10;
	int totalPages = (int) Math.ceil((double) userCount / itemsPerPage);

	Connection connect = DatabaseConnection.getConnection();
	List<User> userList = userDao.getAllUserByLimitAndOffsetCompany(itemsPerPage, (currentPage - 1) * itemsPerPage,"User",companyId);
	
%>
<!Doctype HTML>
<html>
<head>
<title>All Users</title>
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
			<p class="fs-2 text-white box-heading">All User</p>
		</div>
		<hr class="divide">		
		<div class="main-container">
			<div class="p-2 overflow-x-scroll">
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
				<%try{
					String update = (String)session.getAttribute("update");
					if(update != null){ %>
						<div class='alert alert-success alert-dismissible fade show'>
							<%= update %>
						</div>
					<% 
					session.removeAttribute("update");
					}
				}catch(Exception e){
					e.printStackTrace();
				} %>
					<table class="table table-dark table-striped table-hover">
						<thead>
							<tr>
								<th>User Id</th>
								<th>Name</th>
								<th>Email</th>
								<th>Mobile</th>
								<th>All Comment</th>
								<th>Action</th>
							</tr>
						</thead>
						<tbody>
							<%
								for(User u :userList){
							%>
							<tr>
								<td><%= u.getId() %></td>
								<td><%= u.getName() %></td>
								<td><%= u.getEmail() %></td>
								<td><%= u.getMobile() %></td>
								<td>
									<a class = 'submit-btn all-comments-btn btn' style="text-decoration: none;width:100%;" href="/Lead_Mangement_System/show-user-comments-by-admin.jsp?userid=<%= u.getId()%>">View</a>
								</td>
								<td>
									<form action ='update-user-admin.jsp' method = 'post'>
										<button type = 'submit' class = 'submit-btn w-100' name = 'update' value ="<%= u.getEmail() %>">Update</button>
									</form>
									<button  class = 'submit-btn w-100 mt-2' name = 'delete'  onclick='myFunction("<%= u.getEmail() %>")'>Delete</button>
								</td>
							</tr>
						<%}%>
						</tbody>
					</table>
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
	<%@include file="./common/jsp/adminfooter.jsp" %>
	<script>
/* Alert message code */
$(document).ready(function () {  
           $(".close").click(function () {  
               $("#myAlert").alert("close");  
           });  
       });
       
/* Delete confirmation alert */
	function myFunction(email) {
		console.log(email)
		if(confirm("Are you sure want to delete?") == true){
			window.location.href = "/Lead_Mangement_System/deleteAdminUsers?delete="+email ;
		}else{
			alert("Canceled!");
			
		}
	}
	</script>
</body>
</html>