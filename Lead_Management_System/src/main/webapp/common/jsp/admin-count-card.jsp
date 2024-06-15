<div class="mt-3 mb-3 status-card-cantainer">
	<div class="d-flex text-white align-items-center justify-content-around status-card" onclick="window.location.href='/Lead_Management_System/search-admin-leads.jsp?searchby=status&search=New';" style="cursor: pointer;">
		<div class="d-flex flex-column" >
			<span  class="fs-2 fw-bold"><%= totalNewLeadCount %></span>
			<span>New Leads</span>
		</div>
		<i class="fa fa-external-link-square box-icon"></i>
	</div>
	<div class="d-flex text-white align-items-center justify-content-around status-card" onclick="window.location.href='/Lead_Management_System/show-all-interview-by-admin.jsp';" style="cursor: pointer;">
		<div class="d-flex flex-column" >
			<span  class="fs-2 fw-bold"><%= totalInterviewLeadCount %></span>
			<span>Interviews</span>
		</div>
		<i class="fa fa-calendar box-icon"></i>
	</div>
	<div class="d-flex text-white align-items-center justify-content-around status-card" onclick="window.location.href='/Lead_Management_System/show-all-added-by-admin.jsp';" style="cursor: pointer;">
		<div class="d-flex flex-column" >
			<span  class="fs-2 fw-bold"><%= totalLeadCountByAdded %></span>
			<span>Added in Batch</span>
		</div>
		<i class="fa fa-user-plus box-icon"></i>
	</div>
	<div class="d-flex text-white align-items-center justify-content-around status-card" onclick="window.location.href='/Lead_Management_System/search-admin-leads.jsp?searchby=status&search=Already Enrolled';" style="cursor: pointer;">
		<div class="d-flex flex-column">
			<span  class="fs-2 fw-bold"><%= totalLeadCountByEnrolled %></span>
			<span>Enrolled Leads</span>
		</div>
		<i class="fa fa-mortar-board box-icon"></i>
	</div>
</div>