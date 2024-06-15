<%@page import="java.util.Date"%>
<div class="mt-3 mb-3 status-card-cantainer">
	<div class="d-flex text-white align-items-center justify-content-around status-card" onclick="window.location.href='/Lead_Management_System/search-user-leads.jsp?searchby=status&search=New';" style="cursor: pointer;">
		<div class="d-flex flex-column">
			<span class="fs-2 fw-bold"><%= 	totalLeadCountByNew %> </span>
			<span>New Leads</span>
		</div>
		<i class="fa fa-line-chart box-icon"></i>
	</div>
	<div class="d-flex text-white align-items-center justify-content-around status-card" onclick="window.location.href='/Lead_Management_System/show-all-added.jsp?';" style="cursor: pointer;">
		<div class="d-flex flex-column">
			<span class="fs-2 fw-bold"><%= 	totalLeadCountByAdded %> </span>
			<span>Added in Batch</span>
		</div>
		<i class="fa fa-user-plus box-icon"></i>
	</div>
	<div class="d-flex text-white align-items-center justify-content-around status-card" onclick="window.location.href='/Lead_Management_System/show-all-interview.jsp';" style="cursor: pointer;">
		<div class="d-flex flex-column">
			<span class="fs-2 fw-bold"><%= 	totalLeadCountByInterview %> </span>
			<span>Interviews</span>
		</div>
		<i class="fa fa-calendar box-icon"></i>
	</div>
	<div class="d-flex text-white align-items-center justify-content-around status-card" onclick="window.location.href='/Lead_Management_System/search-user-leads.jsp?searchby=status&search=Already';" style="cursor: pointer;">
		<div class="d-flex flex-column">
			<span class="fs-2 fw-bold"><%= totalLeadCountByStatusFinished %> </span>
			<span>Enrolled Leads</span>
		</div>
		<i class="fa fa-tasks box-icon"></i>
	</div>
</div>