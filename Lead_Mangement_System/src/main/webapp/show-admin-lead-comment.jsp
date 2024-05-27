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
<%@page import = "in.pandit.persistance.DatabaseConnection" %>
<%@page import = "java.text.SimpleDateFormat" %>
<%@page import = "java.util.Date" %>
<%
	UserDao userDao = new UserDao();
	LeadDao leadDao = new LeadDao();
	User userCookie = CookiesHelper.getUserCookies(request, "user");
	if(!"Admin".equals(userCookie.getIsAdmin())){
		session.setAttribute("error","You are not admin!");
		response.sendRedirect("index.jsp");
	}
	CommentDao commentDao = new CommentDao();
	int leadId = Integer.parseInt(request.getParameter("leadid"));
	int companyId = userCookie.getCompanyId();
	Lead leadByLeadId = leadDao.getLeadById(leadId);
	List<Comment> listComment = commentDao.getAllCommentByLeadId(leadId);
	User user = userDao.getUserByEmail((String)session.getAttribute("email"),companyId);

	int userCount = userDao.getUserCount("User", companyId);
	int totalLeadCount = leadDao.getTotalLeadsCountByCompanyId(companyId);
	int totalLeadCountByFacebookSource = leadDao.getLeadsCountUsingSourceAndCompany("facebook", companyId);
	int totalLeadCountByGoogleSource = leadDao.getLeadsCountUsingSourceAndCompany( "google",companyId);
	Connection connect = DatabaseConnection.getConnection();
	
%>
<!Doctype HTML>
	<html>
	<head>
		<title>All Leads</title>
		<%@include file="./common/jsp/adminhead.jsp" %>
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
	<%@include file="./common/jsp/adminsidebar.jsp" %>
	<div id="main">
		<%@include file="./common/jsp/adminnavbar.jsp" %>
		<%@include file="./common/jsp/admin-count-card.jsp" %>
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">Show Comment</p>
		</div>
		<hr class="divide">
		<div class="main-container">
			<table class="table table-dark table-striped table-hover" id= "table-id">
 					<thead>
					<tr>
						<th>Lead Id</th>
						<th>Name</th>
						<th>Email</th>
						<th>Mobile</th>
						<th>Status</th>
						<th>Date</th>
						<th>Current Owner</th>
						<th colspan="2">Action</th>
					</tr>
 					</thead>
  				<tbody>
					<tr>
						<td><%= leadByLeadId.getId() %></td>
						<td><%= leadByLeadId.getName() %></td>
						<td><%= leadByLeadId.getEmail() %></td>
						<td><%= leadByLeadId.getMobile() %></td>
						<td><%= leadByLeadId.getStatus() %></td>
						<td><%= leadByLeadId.getCreationDate().toGMTString() %></td>
						<td><%= leadByLeadId.getCurrentowner() %></td>
						<td class="btn-td">
							<form action ='updateAdminAllLeads.jsp' method = 'post'>
								<button type = 'submit' class = 'submit-btn w-100'  name = 'update' value = "<%= leadByLeadId.getId() %>">Update</button>
							</form>
							<form action ='deleteAdminLeads' method = 'post'>
								<button type = 'submit' class = 'submit-btn w-100 mt-2' name = 'delete' value = "<%= leadByLeadId.getId() %>" onclick='myFunction()'>Delete</button>
							</form>
						</td>
					</tr>
   				</tbody>
			</table>
			<%if(listComment.size()>0){%>
		
			<div class="comment-container">
				<%for(Comment comment : listComment){%>
				<div class="comment-inner-conatiner">
					<div class="comment-content">
			            <h5>Posted By : <%= UserDao.getUserNameByEmail(comment.getUseremail(),companyId) %></h5>
			            <p>Comment : <%= comment.getComment() %></p>
			            <h5>Posted on : <%= comment.getCreationDate().toLocaleString() %></h5>
			        </div>
			        <%if(comment.getUserid() == user.getId()) {%>
				        <div class="btn-container">
							<form method="post" action="update-admin-comment.jsp">
								<input name="comment-id" value="<%= comment.getId() %>" hidden="true">
								<input name="user-id" value="<%= comment.getUserid() %>" hidden="true">
								<input name="lead-id" value="<%= comment.getLeadid()%>" hidden="true">
								<input name="user-email" value="<%= comment.getUseremail() %>" hidden="true">
								<input name="comment" value="<%= comment.getComment() %>" hidden="true">
				            	<button type="submit" class="comment-update-btn">Update</button>
							</form>
				        </div>
			        <%} %>
		        	</div>
				<%} %>
			</div>
			<%}else{%>
				<div class="pe-2 ps-2">
					<p class="fs-2 text-white box-heading text-center">No Comments</p>
				</div>
			<%} %>
		</div>
	</div>
	<script>
		/* Script for progress bar */
		$(".animated-progress span").each(function () {
		  $(this).animate(
		    {
		      width: $(this).attr("data-progress") + "%",
		    },
		    1000
		  );
		  $(this).text($(this).attr("data-progress") + "%");
		});
		
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
	<%@include file="./common/jsp/adminfooter.jsp" %>
</body>
</html>