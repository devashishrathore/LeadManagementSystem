<%@page import="in.pandit.dao.CompanyDao"%>
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
UserDao userDao = new UserDao();
LeadDao leadDao = new LeadDao();
CompanyDao companyDao = new CompanyDao();

int userCount = userDao.getUserCount("User");
int adminCount = userDao.getUserCount("Admin");
int companyCount = companyDao.getAllCompanyCount();
User userCookie = CookiesHelper.getUserCookies(request, "user");
int totalLeadCount = leadDao.getTotalLeadsCount();
Connection connect = DatabaseConnection.getConnection();
int currentPage = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;
int itemsPerPage = 10;
int totalPages = (int) Math.ceil((double) totalLeadCount / itemsPerPage);

List<Lead> list = leadDao.getAllLeadsByLimit(itemsPerPage, (currentPage - 1) * itemsPerPage);
%>
<!Doctype HTML>
<html>
<head>
<title>All Leads</title>
<%@include file="./common/jsp/superadminhead.jsp"%>
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

	<%@include file="./common/jsp/superadminsidebar.jsp"%>
	<div id="main">
		<%@include file="./common/jsp/superadminnavbar.jsp"%>
		<div class="mt-3 mb-3 status-card-cantainer">
			<div
				class="d-flex text-white align-items-center justify-content-around status-card">
				<div class="d-flex flex-column">
					<span class="fs-2 fw-bold"><%=totalLeadCount%> </span> <span>Total
						Leads</span>
				</div>
				<i class="fa fa-line-chart box-icon"></i>
			</div>
			<div
				class="d-flex text-white align-items-center justify-content-around status-card">
				<div class="d-flex flex-column">
					<span class="fs-2 fw-bold"><%=userCount%></span> <span>All
						Users</span>
				</div>
				<i class="fa fa-users box-icon"></i>
			</div>
			<div
				class="d-flex text-white align-items-center justify-content-around status-card">
				<div class="d-flex flex-column">
					<span class="fs-2 fw-bold"><%=adminCount%></span> <span>All
						Admins</span>
				</div>
				<i class="fa fa-user-circle box-icon"></i>
			</div>
			<div
				class="d-flex text-white align-items-center justify-content-around status-card">
				<div class="d-flex flex-column">
					<span class="fs-2 fw-bold"><%=companyCount%></span> <span>All
						Company</span>
				</div>
				<i class="fa fa-building box-icon" aria-hidden="true"></i>
			</div>
		</div>
		<div class="main-container p-2">
			<form action="/Lead_Mangement_System/search-superadmin-leads.jsp"
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
					<div
						class="col-2 d-flex flex-column align-items-center justify-content-center">
						<label for="searchby" class="h5">.</label>
						<button type="submit" id="button-1"
							class='submit-btn w-100 pt-1 pb-1'>
							Search <i class="fa fa-search"></i>
						</button>
					</div>
				</div>
			</form>
		</div>
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">All Leads</p>
		</div>
		<hr class="divide">
		<div class="main-container">
			<div class="p-2">
				<%
				try {
					String superAdminMsg = (String) session.getAttribute("superAdminMsg");
					if (superAdminMsg != null) {
				%>
				<div class='alert alert-success alert-dismissible fade show'>
					<%=superAdminMsg%>
				</div>
				<%
				session.removeAttribute("superAdminMsg");
				}
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
							<th>Mobile</th>
							<th>Date</th>
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
							<td><%=l.getMobile()%></td>
							<td><%=l.getCreationDate().toGMTString()%></td>
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
									<button type='submit' class='submit-btn w-100'
										name='add-comment' value="<%=l.getEmail()%>">Add</button>
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

				<!--		Start Pagination -->
				<div>
					<%
					if (currentPage > 1) {
					%>
					<a class="btn btn-primary"
						style="padding: 2px 4px; text-decoration: none;"
						href="/Lead_Mangement_System/allLeadsSuperAdmin.jsp?page=<%=currentPage - 1%>">
						&lt; Previous</a>
					<%
					}
					%>
					<%
					if (currentPage < totalPages) {
					%>
					<a class="btn btn-primary"
						style="padding: 2px 4px; text-decoration: none;"
						href="/Lead_Mangement_System/allLeadsSuperAdmin.jsp?page=<%=currentPage + 1%>">Next
						&gt;</a>
					<%
					}
					%>
				</div>
			</div>
		</div>
	</div>
	<%@include file="./common/jsp/superadminfooter.jsp"%>
	<script>
		/* Alert message code */
		$(document).ready(function() {
			$(".close").click(function() {
				$("#myAlert").alert("close");
			});
		});

		/* Delete confirmation alert */
		function myFunction(id) {
			if (confirm("Are you sure want to delete?") == true) {
				window.location.href = "/Lead_Mangement_System/deleteSuperAdminLead?delete="
						+ id;
			} else {
				alert("Canceled!");

			}
		}
	</script>
</body>
</html>