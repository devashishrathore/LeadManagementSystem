<%@page import="in.pandit.model.Lead"%>
<%@page import="java.util.List"%>
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
<%@page import = "java.text.SimpleDateFormat" %>
<%@page import = "java.util.Date" %>
<%
LeadDao leadDao = new LeadDao();
User userCookie = CookiesHelper.getUserCookies(request, "user");
int companyId = userCookie.getCompanyId();
int totalLeadCountByStatusFinished = leadDao.getLeadsCountUsingCompanyIdAndStatus(companyId, "Already Enrolled");
int totalLeadCount = leadDao.getTotalLeadsCountByCompanyId(companyId);
int totalLeadCountBySource = leadDao.getLeadsCountUsingSourceFacebookOrGoogleAndCompanyId(companyId);
int totalLeadCountNewLeads = leadDao.getLeadsCountNewLeadsByCompanyId(companyId);
Connection connect = DatabaseConnection.getConnection();
int currentPage = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;
int itemsPerPage = 10;
int totalPages = (int) Math.ceil((double) totalLeadCount / itemsPerPage);

List<Lead> list = leadDao.getAllLeadsByLimitCurrentOwnerAndCompany(itemsPerPage, (currentPage - 1) * itemsPerPage,userCookie.getEmail(),companyId);

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
		<div class="main-container p-2">
			<form action="/Lead_Mangement_System/search-user-leads.jsp" method="get">
				<div class="row">
					<div class="col-4 text-white d-flex flex-column">
						<label for="searchby" class="h5">Search By:</label>
						<select id="searchby" name="searchby" class="form-control text-dark">
							<option value="id">Id</option>
							<option value="email">Email</option>
							<option value="name">Name</option>
							<option value="mobile">Mobile</option>
							<option value="owner">Owner</option>
							<option value="currentowner">Current Owner</option>
							<option value="status">Status</option>
						</select>
					</div>
					<div class="col-6  text-white d-flex flex-column">
						<label for="search" class="h5">Search Lead:</label>
						<input id="search" name="search" placeholder="Search Lead " type="text" class="form-control text-dark"/>
					</div>
					
					<div class="col-2 d-flex align-items-center justify-content-center flex-column">
						<label for="search" class="h5">.</label> 
						<button type="submit" id="button-1" class = 'submit-btn w-100 pt-1 pb-1'>Search <i class="fa fa-search"></i> </button>
					</div>
				</div>
			</form>
		</div>
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">Assigned Leads</p>
		</div>
		<hr class="divide">
		<div class="main-container">
		<%if(list.size()<=0){%>
			<div class="p-2 w-100 text-white">
				<h3>No Leads to show</h3>
				<a href="dashboard.jsp" class = 'submit-btn w-100 ' style="text-decoration: none;">Add Lead</a>
			</div>
			<%}else{%>
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
			<table class="table table-dark table-striped table-hover" id= "table-id">
 				<thead>
					<tr>
						<th>Lead Id</th>
						<th>Name</th>
						<th>Email</th>
						<th>Mobile</th>
						<th>Status</th>
						<th>Current Owner</th>
						<th>Owner</th>
						<th>Salary</th>
						<th>Experience</th>
						<th>Education</th>
						<th>Comment</th>
					</tr>
 				</thead>
  				<tbody>
  					<%for(Lead l : list){ %>
					<tr>
						<td><%= l.getId() %></td>
						<td><%= l.getName() %></td>
						<td><%= l.getEmail() %></td>
						<td><%= l.getMobile() %></td>
						<td><%= l.getStatus() %></td>
						<td><%= l.getCurrentowner() %></td>
						<td><%= l.getOwner() %></td>
						<td><%= l.getSalary() %></td>
						<td><%= l.getExperience() %></td>
						<td><%= l.getEducation() %></td>
						<td>
							<form action ="show-user-lead-comment.jsp?leadid=<%= l.getId() %>" method = 'post'>
								<button type = 'submit' class="submit-btn w-100 fw-bold" name = 'view-comment' value = "<%=l.getEmail() %>">View</button>
							</form>
							<form  class="mt-2" action ='add-comment.jsp?leadid=<%= l.getId() %>&useremail=<%=l.getEmail() %>' method = 'post'>
								<button type = 'submit' class="submit-btn w-100 fw-bold" name = 'add-comment' value = "<%=l.getEmail() %>">Add</button>
							</form>
						</td>
					</tr>
				<% } %>
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
			 <% } %>
		</div>
	</div>
<script>
/* Alert message code */
$(document).ready(function () {  
    $(".close").click(function () {  
        $("#myAlert").alert("close");  
    });  
});
       
/* Delete confirmation alert */
function myFunction() {
	confirm("Are you sure want to delete?");
}
	</script>
<%@include file="./common/jsp/footer.jsp" %>
</body>
</html>