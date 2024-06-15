<%@page import="in.pandit.model.Lead"%>
<%@page import="java.util.List"%>
<%@page import="in.pandit.dao.UserDao"%>
<%@page import="in.pandit.dao.LeadDao"%>
<%@page import="in.pandit.model.User"%>
<%@page import="in.pandit.helper.CookiesHelper"%>
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
	session.setAttribute("error","Some error occured, Please log in again!");
	response.sendRedirect("index.jsp");
}
int companyId = userCookie.getCompanyId();
int userCount = userDao.getUserCount("User", companyId);
int totalNewLeadCount = leadDao.getLeadsCountNewLeadsByCompanyId(companyId);
int totalInterviewLeadCount = leadDao.getLeadsCountUsingCompanyIdAndStatus(companyId, "Interview");
int totalLeadCountByAdded = leadDao.getLeadsCountUsingCompanyIdAndStatus(companyId, "Added in Batch");
int totalLeadCountByEnrolled = leadDao.getLeadsCountUsingCompanyIdAndStatus(companyId, "Already Enrolled");Connection connect = DatabaseConnection.getConnection();
int currentPage = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;
int itemsPerPage = 20;
int totalPages = (int) Math.ceil((double) totalInterviewLeadCount / itemsPerPage);
List<Lead> list = leadDao.getAllLeadsByLimitOffsetAndCompanyAndStatus(itemsPerPage, (currentPage - 1) * itemsPerPage, companyId,"Added in Batch");
%>
<!Doctype HTML>
<html>
<head>
<title>All Added in Batch</title>
<link rel="icon" href="image/xyz.jfif">
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
			<p class="fs-2 text-white box-heading"><%if(list.size() <= 0) {
				totalInterviewLeadCount =0; currentPage=0;
				}%>All Added (Total Results: <%= totalInterviewLeadCount %>, Page <%= currentPage %>/<%=totalPages%>)</p>
		</div>
		<hr class="divide">		
		<div class="main-container">
		<%if(list.size()<=0){%>
			<div class="p-2 w-100 text-white">
				<h3>No Leads to show</h3>
				<a href="admin.jsp" class = 'submit-btn w-100 ' style="text-decoration: none;">Add Lead</a>
			</div>
			<%}else{%>
			<div class="p-2">
				<%try{
				String comment = (String)session.getAttribute("comment");
				if(comment != null){ %>
						<div class='alert alert-success alert-dismissible fade show'>
							<%= comment %>
						</div>
				<% 
					session.removeAttribute("comment");
					}
				}catch(Exception e){
					e.printStackTrace();
				} %>
				<%
					try {
						String already = (String) session.getAttribute("updateMsg");
						if (already != null) {
					%>
					<div class='alert alert-success alert-dismissible fade show'>
						<%=already%>
					</div>
					<%
					session.removeAttribute("updateMsg");
					}
					} catch (Exception e) {
						e.printStackTrace();
					}
					%>
					</div>
					<table class="table table-dark table-striped table-hover" id="table-id">
						<thead>
							<tr>
								<th>Lead Id</th>
								<th>Name</th>
								<th>Email</th>
								<th>Mobile</th>
								<th>Status</th>
								<th>Date</th>
								<th>Current Owner</th>
								<th>Comment</th>
								<th colspan="2">Action</th>
							</tr>
						</thead>
						<tbody>
							<%
							int count = 0;
							for (Lead l : list) {
							%>
							<tr>
								<td><%=l.getId()%></td>
								<td><%=l.getName()%></td>
								<td><%=l.getEmail()%></td>
								<td><%=l.getMobile()%></td>
								<td><%=l.getStatus()%></td>
								<td><%=l.getCreationDate().toGMTString()%></td>
								<td><%=l.getCurrentowner()%></td>
								<td>
									<form
										action="show-admin-lead-comment.jsp?leadid=<%=l.getId()%>"
										method='post'>
										<button type='submit' class = 'submit-btn w-100'
											name='view-comment' value="<%=l.getEmail()%>">View</button>
									</form>
									<form class="mt-2"
										action='add-admin-comment.jsp?leadid=<%=l.getId()%>&useremail=<%=l.getEmail()%>'
										method='post'>
										<button type='submit' class = 'submit-btn w-100'
											name='add-comment' value="<%=l.getEmail()%>">Add</button>
									</form>
								</td>
								<td>
									<form action='updateAdminAllLeads.jsp' method='post'>
										<button type='submit' class = 'submit-btn w-100'
											name='update' value="<%=l.getId()%>">Update</button>
									</form>
									<button class = 'submit-btn w-100 mt-2' name='delete'
										onclick='myFunction(<%=l.getId()%>)'>Delete</button>
								</td>
							</tr>
							<%
							}
							%>
						</tbody>
					</table>

					<!--		Start Pagination -->
					<div>
					<%
					if (currentPage > 1) {
					%>
					<a class='submit-btn w-100'
						style="padding: 2px 4px; text-decoration: none;"
						href="/Lead_Management_System/show-all-added-by-admin.jsp?page=<%=currentPage - 1%>">
						&lt; Previous</a>
					<%
					}
					%>

					<%
					int maxPageButtons = 5; // Change this number to display more or fewer page buttons
					int startPage = Math.max(1, currentPage - maxPageButtons / 2);
					int endPage = Math.min(totalPages, startPage + maxPageButtons - 1);
					if(endPage!=1){
						for (int i = startPage; i <= endPage; i++) {
							%>
							<a class='submit-btn w-100'
								style="padding: 2px 4px; text-decoration: none;"
								href="/Lead_Management_System/show-all-added-by-admin.jsp?page=<%=i%>"><%=i%></a>
							<%
							}
					}
					%>

					<%
					if (currentPage < totalPages) {
					%>
					<a class='submit-btn w-100'
						style="padding: 2px 4px; text-decoration: none;"
						href="/Lead_Management_System/show-all-added-by-admin.jsp?page=<%=currentPage + 1%>">Next
						&gt;</a>
					<%
					}
					%>
				</div>
					<%} %>
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
	function myFunction(id) {
		if(confirm("Are you sure want to delete?") == true){
			window.location.href = "/Lead_Management_System/deleteAdminLeads?delete="+id ;
		}else{
			alert("Canceled!");
			
		}
	}
	</script>

	
</body>
</html>