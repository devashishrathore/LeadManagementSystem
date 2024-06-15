<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="in.pandit.helper.CookiesHelper"%>
<%@page import="in.pandit.model.User"%>
<%@page import="in.pandit.dao.UserDao"%>
<%@page import="in.pandit.dao.CommentDao"%>
<%@page import="in.pandit.model.Comment"%>
<%@page import="java.util.List"%>
<%@page import="in.pandit.model.Lead"%>
<%@page import="in.pandit.dao.LeadDao"%>
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
CommentDao commentDao = new CommentDao();
int leadId = Integer.parseInt(request.getParameter("leadid"));
User userCookie = CookiesHelper.getUserCookies(request, "user");
int companyId = userCookie.getCompanyId();
Lead leadByLeadId = leadDao.getLeadById(leadId);
List<Comment> listComment = commentDao.getAllCommentByLeadId(leadId);
int totalLeadCount = leadDao.getTotalLeadsCountByCompanyId(companyId);
int totalLeadCountByNew = leadDao.getLeadsCountNewLeadsByCompanyId(companyId);
int totalLeadCountByInterview = leadDao.getUserInterviewLeadsCount(userCookie.getEmail(), companyId, "Interview");
int totalLeadCountByAdded = leadDao.getUserInterviewLeadsCount(userCookie.getEmail(), companyId, "Added in Batch");
User user = userDao.getUserByEmail((String)session.getAttribute("email"),companyId);
int totalLeadCountByStatusFinished = leadDao.getUserInterviewLeadsCount(userCookie.getEmail(), companyId, "Already Enrolled");	
Connection connect = DatabaseConnection.getConnection();

%>
<!Doctype HTML>
	<html>
	<head>
		<title>View Lead</title>
		<link rel="icon" href="image/xyz.jfif">
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
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">View Lead</p>
		</div>
		<hr class="divide">
		<%try {
					String user1Msg = (String) session.getAttribute("user1Msg");
					if (user1Msg != null) {
				%>
				<div class='alert alert-success alert-dismissible fade show'>
					<%=user1Msg%>
				</div>
				<div class="comment-container">
				<% session.removeAttribute("userMsg");
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				%>
		<div class="main-container">
					<table class="table table-dark table-striped table-hover" id= "table-id">
	  					<thead>
							<tr>
								<th>Lead Id</th>
								<th>Name</th>
								<th>Email</th>
								<th>Mobile</th>
								<th>Address</th>
								<th>Experience</th>
								<th>Education</th>
								<th>Salary</th>
								<th>Status</th>
								<th>Source</th>
								<th>Owner</th>
								<th>Current Owner</th>
								<th>Action</th>
							</tr>
	  					</thead>
		  				<tbody>
							<tr>
								<td><%= leadByLeadId.getId() %></td>
								<td><%= leadByLeadId.getName() %></td>
								<td><%= leadByLeadId.getEmail() %></td>
								<td><%= leadByLeadId.getMobile() %></td>
								<td><%= leadByLeadId.getAddress() %></td>
								<td><%= leadByLeadId.getExperience() %></td>
								<td><%= leadByLeadId.getEducation() %></td>
								<td><%= leadByLeadId.getSalary() %></td>
								<td><%= leadByLeadId.getStatus() %></td>
								<td><%= leadByLeadId.getSource() %></td>
								<td><%= leadByLeadId.getOwner() %></td>
								<td><%= leadByLeadId.getCurrentowner() %></td>
								<td><form  class="mt-2" action ='add-comment.jsp?leadid=<%= leadId %>&useremail=<%=leadByLeadId.getEmail() %>' method = 'post'>
								<button type = 'submit' class = 'submit-btn w-100' name = 'add-comment' value = "<%=leadByLeadId.getEmail() %>">Add Comment</button>
							</form>
								</td>
							</tr>
		   				</tbody>
					</table>
			<%if(listComment.size()>0){%>
					<%for(Comment comment : listComment){
						User user1 = userDao.getUserByEmail(comment.getUseremail(),comment.getCompanyId());
					%>
					<div class="comment-inner-conatiner">
						<div class="comment-content">
				        <h6><b>Lead Id : </b><%= comment.getLeadid() %></h6>
			            <p><b>Comment : </b><%= comment.getComment() %></p>
			            <h6><b>Posted By :</b> <%= user1.getName() %> ( <%=user1.getEmail() %>)</h6>
			            <h6><b>Posted on :</b> <%= comment.getCreationDate().toLocaleString() %></h6>
				        </div>
				         <div class="btn-container" style="flex-direction: column;text-decoration: none;">
				        <%if(comment.getUserid() == user.getId()) {%>
					        <div class="btn-container" >
								<form method="post" action="update-user-comment.jsp">
									<input name="comment-id" value="<%= comment.getId() %>" hidden="true">
									<input name="user-id" value="<%= comment.getUserid() %>" hidden="true">
									<input name="lead-id" value="<%= comment.getLeadid()%>" hidden="true">
									<input name="user-email" value="<%= comment.getUseremail() %>" hidden="true">
									<input name="comment" value="<%= comment.getComment() %>" hidden="true">
					            	<button type="submit" class=" submit-btn w-100">Update</button>
								</form>
					        </div>
				        <%} %>
				        </div>
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
<%@include file="./common/jsp/footer.jsp" %>
</body>
</html>