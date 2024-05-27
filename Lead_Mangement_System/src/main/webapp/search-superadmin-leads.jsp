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
<%@page import = "in.pandit.persistance.DatabaseConnection" %>
<%@page import = "java.text.SimpleDateFormat" %>
<%@page import = "java.util.Date" %>
<%
String searchBy = request.getParameter("searchby").trim();
String search = request.getParameter("search").trim();

LeadDao leadDao = new LeadDao();
SuperAdminDao superAdminDao = new SuperAdminDao();
User userCookie = CookiesHelper.getUserCookies(request, "user");
int companyId = userCookie.getCompanyId();
int userCount = superAdminDao.getUserCount("User");
int adminCount = superAdminDao.getUserCount("Admin");
int totalLeadCountByStatusFinished = leadDao.getLeadsCountUsingCompanyIdAndStatus(companyId, "Already Enrolled");
int totalLeadCount = superAdminDao.getTotalLeadsCount();

Connection connect = DatabaseConnection.getConnection();

int leadCount = 0;
if(searchBy.equals("id")){
	leadCount = 1;
}else if(searchBy.equals("email")){
	leadCount = superAdminDao.getLeadsCount("SELECT COUNT(id) FROM leads WHERE email=?", search);
}else if(searchBy.equals("address")){
	leadCount = superAdminDao.getLeadsCount("SELECT COUNT(id) FROM leads WHERE address=?", search);
}else if(searchBy.equals("name")){
	leadCount = superAdminDao.getLeadsCount("SELECT COUNT(id) FROM leads WHERE name=?", search);
}else if(searchBy.equals("mobile")){
	leadCount = superAdminDao.getLeadsCount("SELECT COUNT(id) FROM leads WHERE mobile=?", search);
}else if(searchBy.equals("owner")){
	leadCount = superAdminDao.getLeadsCount("SELECT COUNT(id) FROM leads WHERE owner=?", search);
}else if(searchBy.equals("status")){
	leadCount = superAdminDao.getLeadsCount("SELECT COUNT(id) FROM leads WHERE status=?", search);
}else if(searchBy.equals("currentowner")){
	leadCount = leadDao.getLeadsCountByCompanyId("SELECT COUNT(id) FROM leads WHERE currentowner=? AND companyid=?", search, companyId);
}
int currentPage = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;
int itemsPerPage = 10;
int totalPages = (int) Math.ceil((double) leadCount / itemsPerPage);
List<Lead> list = leadDao.searchLead(searchBy, search,itemsPerPage, (currentPage - 1) * itemsPerPage,companyId);

%>
<!Doctype HTML>
	<html>
	<head>
		<title>All Leads</title>
		<link rel="stylesheet" href="css/style.css" type="text/css"/>
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
		<!-- cdn for table with pagination -->
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
		
<style>
body{
	margin:0px;
	padding: 0px;
	background-color:#1b203d;
	/* overflow: hidden; */
	font-family: system-ui;
}
.clearfix{
	clear: both;
}
.logo{
	margin: 0px;
	margin-left: 80px;
    font-weight: bold;
    color: white;
    margin-bottom: 30px;
}
.logo span{
	color: #f7403b;
}
.sidenav {
  height: 100%;
  width: 300px;
  position: fixed;
  z-index: 1;
  top: 0;
  left: 0;
  background-color: #272c4a;
  overflow: hidden;
  transition: 0.5s;
  padding-top: 30px;
}
.sidenav a {
  padding: 15px 8px 15px 32px;
  text-decoration: none;
  font-size: 20px;
  color: #818181;
  display: block;
  transition: 0.3s;
}
.sidenav a:hover {
  color: #f1f1f1;
  background-color:#1b203d;
}
.sidenav{
  position: fixed;
  top: 0;
  right: 25px;
  font-size: 36px;
}
#main {
  transition: margin-left .5s;
  padding: 16px;
  margin-left: 300px;
}
.head{
	padding:20px;
}
.col-div-6{
	width: 50%;
	float: left;
}
.profile{
	display: inline-block;
	float: right;
	width: 160px;
}
.pro-img{
	float: left;
	width: 40px;
	margin-top: 5px;
	margin-left: -80px;
}
.profile p{
	color: white;
	font-weight: 500;
	margin-left: -70px;
	margin-top: 4px;
	font-size: 13.5px;
}
.profile p span{
	font-weight: 400;
    font-size: 12px;
    display: block;
    color: #8e8b8b;
}
.col-div-3{
	width: 25%;
	float: left;
}
.box{
	width: 85%;
	height: 100px;
	background-color: #272c4a;
	margin-left: 10px;
	padding:10px;
}
.box p{
	 font-size: 35px;
    color: white;
    font-weight: bold;
    line-height: 30px;
    padding-left: 10px;
    margin-top: 20px;
    display: inline-block;
}
.box p span{
	font-size: 20px;
	font-weight: 400;
	color: #818181;
}
.box-icon{
	font-size: 40px!important;
    float: right;
    margin-top: 35px!important;
    color: #818181;
    padding-right: 10px;
}
.col-div-8{
	width: 70%;
	float: left;
}
.col-div-4{
	width: 30%;
	float: left;
}
.content-box{
	padding: 20px;
}
.content-box p{
	margin: 0px;
    font-size: 20px;
    color: #f7403b;
}
.content-box p span{
	float: right;
    background-color: #ddd;
    padding: 3px 10px;
    font-size: 15px;
}
.box-8, .box-4{
	width: 95%;
	background-color: #272c4a;
	height: 330px;
	
}
.nav2{
	display: none;
}

.box-8{
	margin-left: 10px;
}
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
  
}
td, th {
  text-align: left;
  padding:15px;
  color: #ddd;
  border-bottom: 1px solid #81818140;
}
.circle-wrap {
  margin: 50px auto;
  width: 150px;
  height: 150px;
  background: #e6e2e7;
  border-radius: 50%;
}
.circle-wrap .circle .mask,
.circle-wrap .circle .fill {
  width: 150px;
  height: 150px;
  position: absolute;
  border-radius: 50%;
}
.circle-wrap .circle .mask {
  clip: rect(0px, 150px, 150px, 75px);
}

.circle-wrap .circle .mask .fill {
  clip: rect(0px, 75px, 150px, 0px);
  background-color: #f7403b;
}
.circle-wrap .circle .mask.full,
.circle-wrap .circle .fill {
  animation: fill ease-in-out 3s;
  transform: rotate(126deg);
}

@keyframes fill {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(126deg);
  }
}
.circle-wrap .inside-circle {
  width: 130px;
  height: 130px;
  border-radius: 50%;
  background: #fff;
  line-height: 130px;
  text-align: center;
  margin-top: 10px;
  margin-left: 10px;
  position: absolute;
  z-index: 100;
  font-weight: 700;
  font-size: 2em;
}

/* Css for add lead form */
.boxheading{
	width: 98%;
	/* height: 625px; */
	background-color: #272c4a;
	padding:10px;
}
.boxheading p{
	 font-size: 25px;
    color: white;
    line-height: 30px;
    padding-left: 10px;
    margin-top: 7px;
    display: inline-block;
}
/* Table Desing */


table th , table td{
    text-align: center;
}

table tr:nth-child(even){
    background-color: #1b203d;
}

.pagination li:hover{
    cursor: pointer;
}


/* css for pregress bar */
.animated-progress {
  width: 200px;
  height: 28px;
  border-radius: 5px;
  margin: 10px 10px;
  border: 1px solid rgb(189, 113, 113);
  overflow: hidden;
  position: relative;
}

.animated-progress span {
  height: 100%;
  display: block;
  width: 0;
  color: rgb(255, 251, 251);
  line-height: 30px;
  position: absolute;
  text-align: end;
  padding-right: 5px;
}

.progress-green span {
  background-color: green;
}
.progress-purple span {
  background-color: #d35400;
}
.progress-red span {
  background-color: red;
}
/* Alert css code */
.alert {
    padding: 10px;
    background-color: green;
    color: white;
}
.alert1 {
    padding: 10px;
    background-color: green;
    color: white;
}

.closebtn {
    margin-left: 15px;
    color: white;
    font-weight: bold;
    float: right;
    font-size: 22px;
    line-height: 20px;
    cursor: pointer;
}

.closebtn:hover {
    color: black;
}
.logBtn{
	width: 100%;
	height: 40px;
	background-color: transparent;
	color: gray;
	border: none;
	font-size: 20px;
	color: #818181;
  	display: block;
  	transition: 0.3s;
  	text-align: left;
  	margin-left: -5px;
}
.logBtn:hover {
  color: #f1f1f1;
  background-color:#1b203d;
}
</style>

<!-- This is for popup message -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>  
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
</head>


	<body>
		
		<% 
		response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		if(session.getAttribute("email") == null)
		{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('You are no longer logged in');");
			out.println("</script>");
			response.sendRedirect("index.jsp");
		}
	%>
		
		<div id="mySidenav" class="sidenav">
		<p class="logo"><span>L </span>M S</p>
	  <a href="superadmin.jsp" class="icon-a"><i class="fa fa-dashboard icons"></i>   Dashboard</a>
	  <a href="allLeadsSuperAdmin.jsp"class="icon-a"><i class="fa fa-line-chart icons"></i>   All Leads</a>
	  <a href="allAdmin.jsp"class="icon-a"><i class="fa fa-user-circle icons"></i>   All Admin</a>
	  <a href="allUsersSuperAdmin.jsp"class="icon-a"><i class="fa fa-users icons"></i>   All Users</a>
	  <a href="superAdminProfile.jsp"class="icon-a"><i class="fa fa-user icons"></i>   Profile</a>
	  <a href="superAdminHelp.jsp"class="icon-a"><i class="fa fa-question-circle icons"></i>   Help</a>
	 
	  <form action = "logout" method = "post"><a href="#"class="icon-a"><button type = "submit" class = "logBtn"><i class="fa fa-sign-out icons"></i> Logout</button></a></form> 
		 <div class = "timeDate">
	  	<p style = "margin-top: 320px; margin-left: 5px; font-size: 18px; color: gray;">Date and Time</p>
	  	<%
	  		SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy hh:mm a");
			Date date = new Date();
	    	out.println("<p style = 'margin-top: -20px; margin-left: 5px; font-size: 16px; color: lightgray;''>"+formatter.format(date)+"</p>");
	  	%>
	  </div>
	</div>
	<div id="main">

		<div class="head">
			<div class="col-div-6">
	<span style="font-size:30px;cursor:pointer; color: white;" class="nav"  > All Leads</span>
	<span style="font-size:30px;cursor:pointer; color: white;" class="nav2"  > All Leads</span>
	</div>
		
		<div class="col-div-6">
		<div class="profile">

			<img src="image/xyz.jfif" class="pro-img" />
			<%
			String namedb = null;
			String emaildb = null;
			try{
				String email = (String)session.getAttribute("email");
				PreparedStatement pstmt = connect.prepareStatement("select name, email from users where email = ?");			
				pstmt.setString(1, email);
				ResultSet rst = pstmt.executeQuery();

				while(rst.next()) {
					namedb = rst.getString(1);
					emaildb = rst.getString(2);
				}
				%>
					<p style="font-size:20px; text-align: center;"><% out.print(namedb); %> <span  style="font-size:12px; text-align: center;"><% out.print(emaildb); %></span></p>
				<%									
				}catch(Exception e){
					e.printStackTrace();
				}
			%>
		</div>
	</div>
		<div class="clearfix"></div>
	</div>

		<div class="clearfix"></div>
		<br/>
		
		<div class="col-div-3">
			<div class="box">
				<p>
					<%= totalLeadCount %> 
				<br/><span>Total Leads</span></p>
				<i class="fa fa-line-chart box-icon"></i>
			</div>
		</div>
		<div class="col-div-3">
			<div class="box">
				<p>
					<%= userCount%>
				<br/><span>All Users</span></p>
				<i class="fa fa-users box-icon"></i>
			</div>
		</div>
		<div class="col-div-3">
			<div class="box">
				<p>
					<%= adminCount %>
				<br/><span>All Admin</span></p>
				<i class="fa fa-user-circle box-icon"></i>
			</div>
		</div>
		<div class="col-div-3">
			<div class="box">
				<p><%= totalLeadCountByStatusFinished %><br/><span>Enrolled</span></p>
				<i class="fa fa-tasks box-icon"></i>
			</div>
		</div>
		
		<div class="clearfix"></div>
		<br/>
		
		
		<!-- Adding new leads form -->
		<div class="clearfix"></div>
		<br/>
		<div class="col-12 mb-2">
			<div class="boxheading">
				<form action="/Lead_Mangement_System/search-superadmin-leads.jsp" method="get">
					<div class="row">
						<div class="col-4  text-white d-flex flex-column">
							<label for="searchby" class="h5">Search By:</label>
							<select id="searchby" name="searchby" class="form-control text-dark">
								<option value="id">Id</option>
								<option value="email">Email</option>
								<%-- <option value="address">Address</option> --%>
								<option value="name">Name</option>
								<option value="mobile">Mobile</option>
								<option value="owner">Owner</option>
								<option value="status">Status</option>
							</select>
						</div>
						<div class="col-6 text-white d-flex flex-column">
						<label for="search" class="h5">Search Lead:</label>
							<input id="search" name="search" placeholder="Search Lead " type="text" class="form-control text-dark"/>
							
						</div>
						<div class="col-2 d-flex align-items-center justify-content-center">
						<label for="search" class="h5"></label>
						
							<button type="submit" id="button-1" class="btn btn-primary">Search <i class="fa fa-search"></i> </button>
						</div>
					</div>
				</form>
			</div>
		</div>
		<div class="col-12">
			<div class="boxheading">
			<%
				if(list.size()==0){
				%>
					<h1 class="text-white">Record Not found</h1>
				<% } else{%>
				
				<p>All Leads</p>
				

		<div class="container-fluid">
				<% try{
							String success = (String)session.getAttribute("msg"); 
							if(success!= null){
								out.print("<div class='alert alert-success alert-dismissible fade show'>"+
											"<button type='button' class='close' data-dismiss='alert'>×</button>"+
											" <strong>Alert!</strong> Data deleted Successfully </div>");
							}
							session.removeAttribute("msg");
					}catch(Exception e){
						e.printStackTrace();
					} 
					
				%>
				<% try{
						String success = (String)session.getAttribute("updateMsg"); 
						if(success!= null){
							out.print("<div class='alert alert-success alert-dismissible fade show alert1'>"+
										"<button type='button' class='close' data-dismiss='alert'>×</button>"+
										" <strong>Success!</strong> Data updated Successfully </div>");
						}
						session.removeAttribute("updateMsg");
					
					}catch(Exception e){
						e.printStackTrace();
					} 
				%>
				<table class="table table-striped table-class" id= "table-id">
  
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
  						for(Lead l : list){
  					%>
					<tr>
						<td><%= l.getId() %></td>
						<td><%= l.getName() %></td>
						<td><%= l.getEmail() %></td>
						<td><%= l.getSource() %></td>
						<td><%= l.getCreationDate() %></td>
						<td><%= l.getMobile() %></td>
						<td><%= l.getOwner() %></td>
						<td>
							<form action ="show-super-lead-comment.jsp?leadid=<%= l.getId() %>" method = 'post'>
								<button type = 'submit' class = 'btn btn-primary'  name = 'view-comment' value = "<%=l.getEmail() %>">View</button>
							</form>
							<form  class="mt-2" action ='add-superadmin-comment.jsp?leadid=<%= l.getId() %>&useremail=<%=l.getEmail() %>' method = 'post'>
								<button type = 'submit' class = 'btn btn-primary' name = 'add-comment' value = "<%=l.getEmail() %>">Add</button>
							</form>
						</td>
						<td>
							<form action ='updateSuperAdminAllLeads.jsp' method = 'post'>
								<button type = 'submit' class = 'btn btn-primary'  name = 'update' value = "<%=l.getId() %>">Update</button>
							</form>
							<button class = 'btn btn-danger mt-2' name = 'delete' onclick='myFunction(<%= l.getId() %>)'>Delete</button>
						</td>
					</tr>
				<%}%>
   				</tbody>
			</table>
			<% }%>
<!--		Start Pagination -->
			<div>
			    <% if (currentPage > 1) { %>
			        <a class="btn btn-primary" style="padding: 2px 4px; text-decoration: none;" href="/Lead_Mangement_System/search-superadmin-leads.jsp?page=<%= currentPage - 1 %>&search=<%= search %>&searchby=<%= searchBy %>"> &lt; Previous</a>
			    <% } %>
			    <% if (currentPage < totalPages) { %>
			        <a class="btn btn-primary" style="padding: 2px 4px; text-decoration: none;" href="/Lead_Mangement_System/search-superadmin-leads.jsp?page=<%= currentPage + 1 %>&search=<%= search %>&searchby=<%= searchBy %>">Next &gt;</a>
			    <% } %>
			</div>

			</div>
			</div>
		</div>
		
		</div>


	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script>

	  $(".nav").click(function(){
	    $("#mySidenav").css('width','70px');
	    $("#main").css('margin-left','70px');
	    $(".logo").css('visibility', 'hidden');
	    $(".logo span").css('visibility', 'visible');
	     $(".logo span").css('margin-left', '-10px');
	     $(".icon-a").css('visibility', 'hidden');
	     $(".icons").css('visibility', 'visible');
	     $(".icons").css('margin-left', '-8px');
	      $(".nav").css('display','none');
	      $(".nav2").css('display','block');
	  });

	$(".nav2").click(function(){
	    $("#mySidenav").css('width','300px');
	    $("#main").css('margin-left','300px');
	    $(".logo").css('visibility', 'visible');
	     $(".icon-a").css('visibility', 'visible');
	     $(".icons").css('visibility', 'visible');
	     $(".nav").css('display','block');
	      $(".nav2").css('display','none');
	 });
	
/* Alert message code */
$(document).ready(function () {  
           $(".close").click(function () {  
               $("#myAlert").alert("close");  
           });  
       });
       
/* Delete confirmation alert */
	function myFunction(id) {
		if(confirm("Are you sure want to delete?") == true){
			window.location.href = "/Lead_Mangement_System/deleteSuperAdminLead?delete="+id ;
		}else{
			alert("Canceled!");
			
		}
	}
	</script>

	</body>


	</html>