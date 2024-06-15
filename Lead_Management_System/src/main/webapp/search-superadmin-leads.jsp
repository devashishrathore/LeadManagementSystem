<%@page import="in.pandit.dao.CompanyDao"%>
<%@page import="in.pandit.dao.SuperAdminDao"%>
<%@page import="in.pandit.model.Lead"%>
<%@page import="java.util.List"%>
<%@page import="in.pandit.model.User"%>
<%@page import="in.pandit.dao.LeadDao"%>
<%@page import="in.pandit.helper.CookiesHelper"%>
<%@page import="in.pandit.dao.UserDao"%>
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
SuperAdminDao superAdminDao = new SuperAdminDao();
CompanyDao companyDao = new CompanyDao();
User userCookie = CookiesHelper.getUserCookies(request, "user");
int companyId = userCookie.getCompanyId();
int userCount = superAdminDao.getUserCount("User");
int companyCount = companyDao.getAllCompanyCount();
int adminCount = superAdminDao.getUserCount("Admin");
int totalLeadCountByStatusFinished = superAdminDao.getLeadsCountUsingStatus("Already Enrolled");
int totalLeadCountNewLeads = superAdminDao.getLeadsCountUsingStatus("New");
int totalLeadCount = superAdminDao.getTotalLeadsCount();

Connection connect = DatabaseConnection.getConnection();

int leadCount = 0;
if (searchBy.equals("id")) {
	leadCount = 1;
} else if (searchBy.equals("email")) {
	leadCount = superAdminDao.getLeadsCount("SELECT COUNT(id) FROM leads WHERE email LIKE ?", search);
} else if (searchBy.equals("address")) {
	leadCount = superAdminDao.getLeadsCount("SELECT COUNT(id) FROM leads WHERE address LIKE ?", search);
} else if (searchBy.equals("name")) {
	leadCount = superAdminDao.getLeadsCount("SELECT COUNT(id) FROM leads WHERE name LIKE ?", search);
} else if (searchBy.equals("mobile")) {
	leadCount = superAdminDao.getLeadsCount("SELECT COUNT(id) FROM leads WHERE mobile LIKE ?", search);
} else if (searchBy.equals("owner")) {
	leadCount = superAdminDao.getLeadsCount("SELECT COUNT(id) FROM leads WHERE owner LIKE ?", search);
} else if (searchBy.equals("status")) {
	leadCount = superAdminDao.getLeadsCount("SELECT COUNT(id) FROM leads WHERE status LIKE ?", search);
} else if (searchBy.equals("currentowner")) {
	leadCount = superAdminDao.getLeadsCount("SELECT COUNT(id) FROM leads WHERE currentowner LIKE ?", search);
}
int currentPage = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;
int itemsPerPage = 20;
int totalPages = (int) Math.ceil((double) leadCount / itemsPerPage);
List<Lead> list = superAdminDao.searchLead(searchBy, search, itemsPerPage, (currentPage - 1) * itemsPerPage);
%>

<!Doctype HTML>
<html>
<head>
<title>Search SuperAdmin Leads</title>
<link rel="icon" href="image/xyz.jfif">
<%@include file="./common/jsp/head.jsp"%>
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
	response.sendRedirect("index.jsp");
	}
	%>
	<%
	if (request.getAttribute("messages") != null) {
	%>
	<script>
		swal('Thank You!', 'We will get in touch soon!', 'success')
	</script>
	<%
	}
	%>
	<%@include file="./common/jsp/superadminsidebar.jsp"%>
	<div id="main">
		<%@include file="./common/jsp/superadminnavbar.jsp"%>
		<%@include file="./common/jsp/superadmin-count-card.jsp"%>
		<div class="main-container">
			<form action="/Lead_Management_System/search-superadmin-leads.jsp"
				method="get">
				<div class="row">
					<div class="col-4  text-white d-flex flex-column">
						<label for="searchby" class="h5">Search By:</label> <select
							id="searchby" name="searchby" class="form-control text-dark">
							<option value="id">Id</option>
							<option value="email">Email</option>
							<option value="name">Name</option>
							<option value="mobile">Mobile</option>
							<option value="owner">Owner</option>
							<option value="status">Status</option>
						</select>
					</div>
					<div class="col-6 text-white d-flex flex-column">
						<label for="search" class="h5">Search Lead:</label> <input
							id="search" name="search" placeholder="Search Lead " type="text"
							class="form-control text-dark" />
					</div>
					<input id="page" name="page" value="<%=currentPage%>" hidden="true" />

					<div class="col-2 d-flex align-items-center justify-content-center flex-column">
						<label for="search" class="h5">.</label>

						<button type="submit" id="button-1" class="submit-btn w-100 pt-1 pb-1">
							Search <i class="fa fa-search"></i>
						</button>
					</div>
				</div>
			</form>
		</div>
		<%
		if (list.size() == 0) {
		%>
		<h1 class="text-white">Record Not found</h1>
		<%
		} else {
		%>
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">
				<%
				if (list.size() <= 0) {
					leadCount = 0;
					currentPage = 0;
				}
				%>All Leads (Total Search Results:
				<%=leadCount%>, Page
				<%=currentPage%>/<%=totalPages%>)
			</p>
		</div>
		<hr class="divide">
		<div class="main-container">
			<div class="p-2">
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
			</div>
			<table class="table table-dark table-striped table-hover" id="table-id">

				<thead>
					<tr>
						<th>Lead Id</th>
						<th>Name</th>
						<th>Email</th>
						<th>Source</th>
						<th>Date</th>
						<th>Mobile</th>
						<th>Owner</th>
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
						<td><%=l.getSource()%></td>
						<td><%=l.getCreationDate()%></td>
						<td><%=l.getMobile()%></td>
						<td><%=l.getOwner()%></td>
						<td>
							<form action="show-super-lead-comment.jsp?leadid=<%=l.getId()%>"
								method='post'>
								<button type='submit' class='submit-btn w-100'
									name='view-comment' value="<%=l.getEmail()%>">View</button>
							</form>
							<form class="mt-2"
								action='add-superadmin-comment.jsp?leadid=<%=l.getId()%>&useremail=<%=l.getEmail()%>'
								method='post'>
								<button type='submit' class='submit-btn w-100' name='add-comment'
									value="<%=l.getEmail()%>">Add</button>
							</form>
						</td>
						<td>
							<form action='updateSuperAdminAllLeads.jsp' method='post'>
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
					href="/Lead_Management_System/search-superadmin-leads.jsp?searchby=<%=searchBy%>&search=<%=search %>&page=<%=currentPage - 1%>">
					&lt; Previous</a>
				<%
				}
				%>

				<%
				int maxPageButtons = 10; // Change this number to display more or fewer page buttons
				int startPage = Math.max(1, currentPage - maxPageButtons / 2);
				int endPage = Math.min(totalPages, startPage + maxPageButtons - 1);
				if(endPage!=1){
					for (int i = startPage; i <= endPage; i++) {
						%>
						<a class='submit-btn w-100'
							style="padding: 2px 4px; text-decoration: none;"
							href="/Lead_Management_System/search-superadmin-leads.jsp?searchby=<%=searchBy%>&search=<%=search %>&page=<%=i%>"><%=i%></a>
						<%
						}
				}
				%>

				<%
				if (currentPage < totalPages) {
				%>
				<a class='submit-btn w-100'
					style="padding: 2px 4px; text-decoration: none;"
					href="/Lead_Management_System/search-superadmin-leads.jsp?searchby=<%=searchBy%>&search=<%=search %>&page=<%=currentPage + 1%>">Next
					&gt;</a>
				<%
				}
				%>
			</div>
		</div>
	</div>
	<script>
		/* Alert message code */
		$(document).ready(function() {
			$(".close").click(function() {
				$("#myAlert").alert("close");
			});
		});

		/* Delete confirmation alert */
		function myFunction() {
			confirm("Are you sure want to delete?");
		}
	</script>
	<%@include file="./common/jsp/superadminfooter.jsp"%>
</body>


</html>