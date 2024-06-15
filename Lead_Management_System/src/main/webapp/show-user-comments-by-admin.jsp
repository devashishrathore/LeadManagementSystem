<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
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
	int userid = Integer.parseInt(request.getParameter("userid"));
	List<Comment> listComment = commentDao.getAllCommentByUserId(userid);
	User userCookie = CookiesHelper.getUserCookies(request, "user"); 
	int companyId = userCookie.getCompanyId();
	User user = userDao.getUserByEmail((String)session.getAttribute("email"),companyId);
	int totalLeadCount = leadDao.getTotalLeadsCountByCompanyId(companyId);
	int userCount = userDao.getUserCount("User", companyId);
	int totalNewLeadCount = leadDao.getLeadsCountNewLeadsByCompanyId(companyId);
	int totalInterviewLeadCount = leadDao.getLeadsCountUsingCompanyIdAndStatus(companyId, "Interview");
	int totalLeadCountByAdded = leadDao.getLeadsCountUsingCompanyIdAndStatus(companyId, "Added in Batch");
	int totalLeadCountByEnrolled = leadDao.getLeadsCountUsingCompanyIdAndStatus(companyId, "Already Enrolled");
	Connection connect = DatabaseConnection.getConnection();
	
%>
<!Doctype HTML>
	<html>
	<head>
		<title>All Leads</title>
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
	<%if (request.getAttribute("messages") != null) {%>
		<script>swal('Thank You!', 'We will get in touch soon!', 'success')</script>
	<%}%>
	<%@include file="./common/jsp/adminsidebar.jsp" %>
	<div id="main">
		<%@include file="./common/jsp/adminnavbar.jsp" %>
		<%@include file="./common/jsp/admin-count-card.jsp" %>
		<%if(listComment.size()>0){%>
		<div class="pe-2 ps-2">
			<p class="fs-2 text-white box-heading">User All Comments</p>
		</div>
		<hr class="divide">
		<div class="main-container">
			<div class="comment-container">
				<%for(Comment comment : listComment){
					User user1 = userDao.getUserByEmail(comment.getUseremail(),companyId);
				%>
				<div class="comment-inner-conatiner mt-2">
					<div class="comment-content">
			            <h5>Posted By : <%= user1.getName() %></h5>
			            <p>Comment : <%= comment.getComment() %></p>
			            <h5>Posted on : <%= comment.getCreationDate().toLocaleString() %></h5>
			        </div>
			            <div class="btn-container" style="flex-direction: column;text-decoration: none;">
							<h5>Lead Id : <%= comment.getLeadid() %></h5>
							<a style="text-decoration: none;" class="text-center submit-btn w-100" href="/Lead_Management_System/show-admin-lead-comment.jsp?leadid=<%= comment.getLeadid() %>" >View</a>
				        </div>
			        
		        	</div>
		        	<%if(comment.getUserid() == user.getId()) {%>
					        <div class="btn-container">
								<form method="post" action="update-user-comment.jsp">
									<input name="comment-id" value="<%= comment.getId() %>" hidden="true">
									<input name="user-id" value="<%= comment.getUserid() %>" hidden="true">
									<input name="lead-id" value="<%= comment.getLeadid()%>" hidden="true">
									<input name="user-email" value="<%= comment.getUseremail() %>" hidden="true">
									<input name="comment" value="<%= comment.getComment() %>" hidden="true">
					            	<button type="submit" class="comment-update-btn">Update</button>
								</form>
					        </div>
				        <%} %>
				<%} %>
			</div>
		</div>
		<%}else{%>
			<div class="pe-2 ps-2">
				<p class="fs-2 text-white box-heading text-center">No Comments</p>
			</div>
		<%} %>
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