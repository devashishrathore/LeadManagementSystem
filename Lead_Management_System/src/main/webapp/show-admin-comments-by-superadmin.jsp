<%@page import="in.pandit.dao.CompanyDao"%>
<%@page import="in.pandit.helper.CookiesHelper"%>
<%@page import="in.pandit.model.User"%>
<%@page import="in.pandit.dao.UserDao"%>
<%@page import="in.pandit.dao.CommentDao"%>
<%@page import="in.pandit.model.Comment"%>
<%@page import="java.util.List"%>
<%@page import="in.pandit.model.Lead"%>
<%@page import="in.pandit.dao.LeadDao"%>
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
User userCookie = CookiesHelper.getUserCookies(request, "user");
if (!"Superadmin".equals(userCookie.getIsAdmin())) {
	session.setAttribute("error", "You are not super admin!");
	response.sendRedirect("index.jsp");
}
UserDao userDao = new UserDao();
LeadDao leadDao = new LeadDao();
CompanyDao companyDao = new CompanyDao();
CommentDao commentDao = new CommentDao();
int userid = Integer.parseInt(request.getParameter("userid"));
List<Comment> listComment = commentDao.getAllCommentByUserId(userid);
User user = userDao.getUserByEmail((String) session.getAttribute("email"));
int userCount = userDao.getUserCount("User");
int adminCount = userDao.getUserCount("Admin");
int companyCount = companyDao.getAllCompanyCount();
int totalLeadCount = leadDao.getTotalLeadsCount();
%>
<!Doctype HTML>
<html>
<head>
<title>All Leads</title>
<link rel="icon" href="image/xyz.jfif">
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
		<%@include file="./common/jsp/superadmin-count-card.jsp"%>
		<div class="main-container">
			<%
			if (listComment.size() > 0) {
			%>
			<div class="comment-container">
				<%
				for (Comment comment : listComment) {
					User user1 = userDao.getUserByEmail(comment.getUseremail());
				%>
		<div class="comment-inner-conatiner mt-2">
					<div class="comment-content">
			            <h6><b>Lead Id : </b><%= comment.getLeadid() %></h6>
			            <p><b>Comment : </b><%= comment.getComment() %></p>
			            <% if(user1.getEmail()==null) {%>
			            <h6><b>Posted By :</b> SuperAdmin </h6>
			            <%} else{ %>
			            <h6><b>Posted By :</b> <%= user1.getName() %> ( <%=user1.getEmail() %>)</h6>
			            <%} %>
			            <h6><b>Posted on :</b> <%= comment.getCreationDate().toLocaleString() %></h6>
			        </div>
			            <div class="btn-container" style="flex-direction: column;text-decoration: none;">
					<a style="text-decoration: none;" class="text-center submit-btn w-100" href="/Lead_Management_System/show-super-lead-comment.jsp?leadid=<%= comment.getLeadid() %>" >View</a>
			        <%if(comment.getUserid() == user.getId()) {%>
					        <div class="btn-container">
								<form method="post" action="update-super-admin-comment.jsp">
									<input name="comment-id" value="<%= comment.getId() %>" hidden="true">
									<input name="user-id" value="<%= comment.getUserid() %>" hidden="true">
									<input name="lead-id" value="<%= comment.getLeadid()%>" hidden="true">
									<input name="user-email" value="<%= comment.getUseremail() %>" hidden="true">
									<input name="comment" value="<%= comment.getComment() %>" hidden="true">
					            	<button type="submit" class="text-center submit-btn w-100">Update</button>
								</form>
					        </div>
				        <%} %>
				        </div>
		        	</div>
				<%
				}
				%>
			</div>
			<%
			} else {
			%>
			<div class="pe-2 ps-2">
				<p class="fs-2 text-white box-heading text-center">No Comments</p>
			</div>
			<%
			}
			%>
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
		function myFunction() {
			confirm("Are you sure want to delete?");
		}
	</script>
</body>
</html>