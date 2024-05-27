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
<%@page import = "in.pandit.persistance.DatabaseConnection" %>
<%@page import = "java.text.SimpleDateFormat" %>
<%@page import = "java.util.Date" %>
<%
UserDao userDao = new UserDao();
LeadDao leadDao = new LeadDao();
User userCookie = CookiesHelper.getUserCookies(request, "user");
if(!"Superadmin".equals(userCookie.getIsAdmin())){
	session.setAttribute("error","You are not super admin!");
	response.sendRedirect("index.jsp");
}
CompanyDao companyDao = new CompanyDao();
CommentDao commentDao = new CommentDao();
int userid = Integer.parseInt(request.getParameter("userid"));
List<Comment> listComment = commentDao.getAllCommentByUserId(userid);

int companyCount = companyDao.getAllCompanyCount();
User user = userDao.getUserByEmail((String)session.getAttribute("email"));
int userCount = userDao.getUserCount("User");
int adminCount = userDao.getUserCount("Admin");
int totalLeadCount = leadDao.getTotalLeadsCount();
Connection connect = DatabaseConnection.getConnection();
%>
<!Doctype HTML>
<html>
<head>
	<title>All Leads</title>
	<%@include file="./common/jsp/superadminhead.jsp" %>
</head>
<body>
	<%response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // Preventing from back after logout.
		if(session.getAttribute("email") == null){%>
		<script type="text/javascript">
			alert('You are no longer logged in');
		</script>
	<%}%>
	<%@include file="./common/jsp/superadminsidebar.jsp" %>
	<div id="main">
		<%@include file="./common/jsp/superadminnavbar.jsp" %>
		<div class="mt-3 mb-3 status-card-cantainer">
			<div class="d-flex text-white align-items-center justify-content-around status-card">
				<div class="d-flex flex-column">
					<span class="fs-2 fw-bold"><%= totalLeadCount %> </span>
					<span>Total Leads</span>
				</div>
				<i class="fa fa-line-chart box-icon"></i>
			</div>
			<div class="d-flex text-white align-items-center justify-content-around status-card">
				<div class="d-flex flex-column">
					<span  class="fs-2 fw-bold"><%= userCount %></span>
					<span>All Users</span>
				</div>
				<i class="fa fa-users box-icon"></i>
			</div>
			<div class="d-flex text-white align-items-center justify-content-around status-card">
				<div class="d-flex flex-column">
					<span  class="fs-2 fw-bold"><%= adminCount %></span>
					<span>All Admins</span>
				</div>
					<i class="fa fa-user-circle box-icon"></i>
			</div>
			<div class="d-flex text-white align-items-center justify-content-around status-card">
				<div class="d-flex flex-column">
					<span  class="fs-2 fw-bold"><%= companyCount %></span>
					<span>All Company</span>
				</div>
				<i class="fa fa-building box-icon" aria-hidden="true"></i>
			</div>
		</div>
		<div class="main-container">
			<%if(listComment.size()>0){%>
			<div class="comment-container">
				<%for(Comment comment : listComment){
					User user1 = userDao.getUserByEmail(comment.getUseremail());
				%>
				<div class="comment-inner-conatiner mt-2">
					<div class="comment-content">
			            <h5>Posted By : <%= user1.getName() %></h5>
			            <p>Comment : <%= comment.getComment() %></p>
			            <h5>Posted on : <%= comment.getCreationDate().toLocaleString() %></h5>
			        </div>
			            <div class="btn-container">
							<h5>Lead Id : <%= comment.getLeadid() %></h5>
				        </div>
			        
		        	</div>
				<%} %>
			</div>
			<%}else{ %>
				<div class="pe-2 ps-2">
					<p class="fs-2 text-white box-heading text-center">No Comments</p>
				</div>
			<%}%>
		</div>
	</div>
<%@include file="./common/jsp/superadminfooter.jsp" %>
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
</body>
</html>