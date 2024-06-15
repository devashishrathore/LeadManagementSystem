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
String search = request.getParameter("search").trim();
String searchBy = request.getParameter("searchby").trim();
UserDao userDao = new UserDao();
LeadDao leadDao = new LeadDao();
User userCookie = CookiesHelper.getUserCookies(request, "user");
if (!"Admin".equals(userCookie.getIsAdmin())) {
	session.setAttribute("error", "Some error occured, Please log in again!");
	response.sendRedirect("index.jsp");
}
int companyId = userCookie.getCompanyId();
int userCount = userDao.getUserCount("User", companyId);
int totalLeadCount = leadDao.getTotalLeadsCountByCompanyId(companyId);
int totalNewLeadCount = leadDao.getLeadsCountNewLeadsByCompanyId(companyId);
int totalInterviewLeadCount = leadDao.getLeadsCountUsingCompanyIdAndStatus(companyId, "Interview");
int totalLeadCountByAdded = leadDao.getLeadsCountUsingCompanyIdAndStatus(companyId, "Added in Batch");
int totalLeadCountByAssigned = leadDao.getLeadsCountUsingAssigned(userCookie.getEmail(), companyId);
int totalLeadCountByEnrolled = leadDao.getLeadsCountUsingCompanyIdAndStatus(companyId, "Already Enrolled");
Connection connect = DatabaseConnection.getConnection();

int leadCount = 0;
if (searchBy.equals("id")) {
	leadCount = 1;
} else if (searchBy.equals("email")) {
	leadCount = leadDao.getAssignedLeadsCountByCompanyId("SELECT COUNT(id) FROM leads WHERE email LIKE ? AND companyid=? AND currentowner=?",
	search, companyId, userCookie.getEmail());
} else if (searchBy.equals("address")) {
	leadCount = leadDao.getAssignedLeadsCountByCompanyId("SELECT COUNT(id) FROM leads WHERE address LIKE ? AND companyid=? AND currentowner=?",
	search, companyId, userCookie.getEmail());
} else if (searchBy.equals("name")) {
	leadCount = leadDao.getAssignedLeadsCountByCompanyId("SELECT COUNT(id) FROM leads WHERE name LIKE ? AND companyid=? AND currentowner=?",
	search, companyId, userCookie.getEmail());
} else if (searchBy.equals("mobile")) {
	leadCount = leadDao.getAssignedLeadsCountByCompanyId("SELECT COUNT(id) FROM leads WHERE mobile LIKE ? AND companyid=? AND currentowner=?",
	search, companyId, userCookie.getEmail());
} else if (searchBy.equals("owner")) {
	leadCount = leadDao.getAssignedLeadsCountByCompanyId("SELECT COUNT(id) FROM leads WHERE owner LIKE ? AND companyid=? AND currentowner=?",
	search, companyId, userCookie.getEmail());
} else if (searchBy.equals("status")) {
	leadCount = leadDao.getAssignedLeadsCountByCompanyId("SELECT COUNT(id) FROM leads WHERE status LIKE ? AND companyid=? AND currentowner=?",
	search, companyId, userCookie.getEmail());
} else if (searchBy.equals("currentowner")) {
	leadCount = leadDao.getLeadsCountByCompanyId(
	"SELECT COUNT(id) FROM leads WHERE currentowner LIKE ? AND companyid=?", search, companyId);
}
int currentPage = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;
int itemsPerPage = 20;
int totalPages = (int) Math.ceil((double) leadCount / itemsPerPage);
List<Lead> list = leadDao.searchAssigned(searchBy, search, itemsPerPage, (currentPage - 1) * itemsPerPage, companyId, userCookie.getEmail());
%>
<!Doctype HTML>
<html>
<head>
<title>Search Admin Posted Leads</title>
<link rel="icon" href="image/xyz.jfif">
<%@include file="./common/jsp/adminhead.jsp"%>
</head>
<body>
	<%
	response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // Preventing from back after logout.
	if (session.getAttribute("email") == null) {
	%>
	<script type="text/javascript">
			alert('You are no longer logged in');
		</script>
	<%
	}
	%>

	<%@include file="./common/jsp/adminsidebar.jsp"%>
	<div id="main">
		<%@include file="./common/jsp/adminnavbar.jsp"%>
		<%@include file="./common/jsp/admin-count-card.jsp"%>
		<div class="main-container p-2">
			<form action="/Lead_Management_System/search-admin-assigned-leads.jsp"
				method="get" class="">
				<div class="row">
					<div class="col-4 text-white d-flex flex-column">
						<label for="searchby" class="h5">Search By:</label> <select
							id="searchby" name="searchby" class="form-control text-dark">
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
						<label for="search" class="h5">Search Lead:</label> <input
							id="search" name="search" placeholder="Search Lead " type="text"
							class="form-control text-dark" />
					</div>
					<input id="page" name="page" value="<%=currentPage%>"
						hidden="true" />

					<div
						class="col-2 d-flex align-items-center justify-content-center flex-column">
						<label for="search" class="h5">.</label>
						<button type="submit" id="button-1"
							class='submit-btn w-100 pt-1 pb-1'>
							Search <i class="fa fa-search"></i>
						</button>
					</div>
				</div>
			</form>
		</div>
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">
				<%if(list.size() <= 0) {
				leadCount=0; currentPage=0;
				}%>Assigned Leads (Total Search Results:
				<%=leadCount%>, Page <%= currentPage %>/<%=totalPages%>)
			</p>
		</div>
		<hr class="divide">
		<div class="main-container">
			<%
			if (list.size() <= 0) {
			%>
			<div class="p-2 w-100 text-white">
				<h3>No Leads to show</h3>
				<a href="admin.jsp" class='submit-btn w-100 '
					style="text-decoration: none;">Add Lead</a>
			</div>
			<%
			} else {
			%>
			<%
			try {
				String success = (String) session.getAttribute("msg");
				if (success != null) {
					out.print("<div class='alert alert-success alert-dismissible fade show'>"
					+ "<button type='button' class='close' data-dismiss='alert'>×</button>"
					+ " <strong>Alert!</strong> Data deleted Successfully </div>");
				}
				session.removeAttribute("msg");
			} catch (Exception e) {
				e.printStackTrace();
			}
			%>
			<%
			try {
				String success = (String) session.getAttribute("updateMsg");
				if (success != null) {
					out.print("<div class='alert alert-success alert-dismissible fade show alert1'>"
					+ "<button type='button' class='close' data-dismiss='alert'>×</button>"
					+ " <strong>Success!</strong> Data updated Successfully </div>");
				}
				session.removeAttribute("updateMsg");
			} catch (Exception e) {
				e.printStackTrace();
			}
			%>
			<table class="table table-dark table-striped table-hover"
				id="table-id">
				<thead>
					<tr>
						<th>Lead Id</th>
						<th>Name</th>
						<th>Email</th>
						<th>Status</th>
						<th>Date</th>
						<th>Mobile</th>
						<th>Current Owner</th>
						<th>Owner</th>
						<th>Comment</th>
						<th colspan="2">Action</th>
					</tr>
				</thead>
				<tbody>
					<%
					for (Lead l : list) {
					%>
					<tr>
						<td><%=l.getId()%></td>
						<td><%=l.getName()%></td>
						<td><%=l.getEmail()%></td>
						<td><%=l.getStatus()%></td>
						<td><%=l.getCreationDate()%></td>
						<td><%=l.getMobile()%></td>
						<td><%=l.getCurrentowner()%></td>
						<td><%=l.getOwner()%></td>
						<td>
							<form
								action="show-admin-lead-comment.jsp?leadid=<%=l.getId()%>"
								method='post'>
								<button type='submit' class='submit-btn w-100'
									name='view-comment' value="<%=l.getEmail()%>">View</button>
							</form>
							<form class="mt-2"
								action='add-admin-comment.jsp?leadid=<%=l.getId()%>&useremail=<%=l.getEmail()%>'
								method='post'>
								<button type='submit' class='submit-btn w-100'
									name='add-comment' value="<%=l.getEmail()%>">Add</button>
							</form>
						</td>
						<td>
							<form action='updateAdminAllLeads.jsp' method='post'>
								<button type='submit' class='submit-btn w-100' name='update'
									value="<%=l.getId()%>">Update</button>
							</form>
							<button class='submit-btn w-100 mt-2' name='delete'
								onclick='myFunction(<%=l.getId()%>)'>Delete</button>
						</td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
			<%
			}
			%>
			<!--		Start Pagination -->
			<div>
				<%
				if (currentPage > 1) {
				%>
				<a class='submit-btn w-100'
					style="padding: 2px 4px; text-decoration: none;"
					href="/Lead_Management_System/search-admin-assigned-leads.jsp?searchby=<%=searchBy%>&search=<%=search %>&page=<%=currentPage - 1%>">
					&lt; Previous</a>
				<%
				}
				%>

				<%
				int maxPageButtons = 10; // Change this number to display more or fewer page buttons
				int startPage = Math.max(1, currentPage - maxPageButtons / 2);
				int endPage = Math.min(totalPages, startPage + maxPageButtons - 1);
				if (endPage != 1) {
					for (int i = startPage; i <= endPage; i++) {
				%>
				<a class='submit-btn w-100'
					style="padding: 2px 4px; text-decoration: none;"
					href="/Lead_Management_System/search-admin-assigned-leads.jsp?searchby=<%=searchBy%>&search=<%=search %>&page=<%=i%>"><%=i%></a>
				<%
				}
				}
				%>

				<%
				if (currentPage < totalPages) {
				%>
				<a class='submit-btn w-100'
					style="padding: 2px 4px; text-decoration: none;"
					href="/Lead_Management_System/search-admin-assigned-leads.jsp?searchby=<%=searchBy%>&search=<%=search %>&page=<%=currentPage + 1%>">Next
					&gt;</a>
				<%
				}
				%>
			</div>
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
		function myFunction(id) {
			if(confirm("Are you sure want to delete?") == true){
				window.location.href = "/Lead_Management_System/deleteAdminLeads?delete="+id ;
			}else{
				alert("Canceled!");
				
			}
		}
	</script>
	<%@include file="./common/jsp/adminfooter.jsp"%>
</body>
</html>