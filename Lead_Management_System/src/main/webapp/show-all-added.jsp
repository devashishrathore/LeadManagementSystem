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
int companyId = userCookie.getCompanyId();
int totalLeadCountByNew = leadDao.getLeadsCountNewLeadsByCompanyId(companyId);
int totalLeadCountByInterview = leadDao.getUserInterviewLeadsCount(userCookie.getEmail(), companyId, "Interview");
int totalLeadCountByAdded = leadDao.getUserInterviewLeadsCount(userCookie.getEmail(), companyId, "Added in Batch");
int totalLeadCountByStatusFinished = leadDao.getUserInterviewLeadsCount(userCookie.getEmail(), companyId, "Already Enrolled");	
int currentPage = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;
int itemsPerPage = 20;
int totalPages = (int) Math.ceil((double) totalLeadCountByInterview / itemsPerPage);
List<Lead> list = leadDao.getUserLeadsByLimitOffsetAndCompanyAndStatus(itemsPerPage, (currentPage - 1) * itemsPerPage, companyId,"Added in batch",userCookie.getEmail());
%>
<!Doctype HTML>
<html>
<head>
<title>Added in Batch</title>
<link rel="icon" href="image/xyz.jfif">
<%@include file="./common/jsp/head.jsp" %>
</head>
<body>
	<%response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // Preventing from back after logout.
		if(session.getAttribute("email") == null){%>
		<script type="text/javascript">
			alert('You are no longer logged in');
		</script>
	<%}%>
		
	<%@include file="./common/jsp/sidebar.jsp" %>
	<div id="main">
		<%@include file="./common/jsp/navbar.jsp" %>
		<%@include file="./common/jsp/count-card.jsp" %>
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading"><%if(list.size() > 0) {%>
			Added in Batch (Total Results: <%= totalLeadCountByInterview %>, Page <%= currentPage %>/<%=totalPages%>)</p>
			<%} %>
		</div>
		<hr class="divide">		
		<div class="main-container">
		<%if(list.size()<=0){%>
			<div class="p-2 w-100 text-white">
				<h3>No Candidates to show</h3>
				<a href="dashboard.jsp" class = 'submit-btn w-100 ' style="text-decoration: none;">Add Candidate</a>
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
										action="show-user-lead-comment.jsp?leadid=<%=l.getId()%>"
										method='post'>
										<button type='submit' class = 'submit-btn w-100'
											name='view-comment' value="<%=l.getEmail()%>">View</button>
									</form>
									<form class="mt-2"
										action='add-user-comment.jsp?leadid=<%=l.getId()%>&useremail=<%=l.getEmail()%>'
										method='post'>
										<button type='submit' class = 'submit-btn w-100'
											name='add-comment' value="<%=l.getEmail()%>">Add</button>
									</form>
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
						href="/Lead_Management_System/show-all-added.jsp?page=<%=currentPage - 1%>">
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
								href="/Lead_Management_System/show-all-added.jsp?page=<%=i%>"><%=i%></a>
							<%
							}
					}
					%>

					<%
					if (currentPage < totalPages) {
					%>
					<a class='submit-btn w-100'
						style="padding: 2px 4px; text-decoration: none;"
						href="/Lead_Management_System/show-all-added.jsp?page=<%=currentPage + 1%>">Next
						&gt;</a>
					<%
					}
					%>
				</div>
					<%} %>
				</div>
			</div>
	<%@include file="./common/jsp/footer.jsp" %>
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