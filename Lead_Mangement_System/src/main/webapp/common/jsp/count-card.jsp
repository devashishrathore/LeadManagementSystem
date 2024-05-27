<%@page import="java.util.Date"%>
<div class="mt-3 mb-3 status-card-cantainer">
	<div class="d-flex text-white align-items-center justify-content-around status-card">
		<div class="d-flex flex-column">
			<span class="fs-2 fw-bold"><%=totalLeadCount %> </span>
			<span>Total Leads</span>
		</div>
		<i class="fa fa-line-chart box-icon"></i>
	</div>
	<div class="d-flex text-white align-items-center justify-content-around status-card">
		<div class="d-flex flex-column">
			<span class="fs-2 fw-bold"><%= totalLeadCountNewLeads %> </span>
			<span>New Leads</span>
			<span style="font-size: 8px;"><!-- new Date(System.currentTimeMillis()).toLocaleString() --></span>
		</div>
		<i class="fa fa-cart-plus box-icon"></i>
	</div>
	<div class="d-flex text-white align-items-center justify-content-around status-card">
		<div class="d-flex flex-column">
			<span class="fs-2 fw-bold"><%= totalLeadCountBySource %> </span>
			<span>Social Media</span>
		</div>
		<i class="fa fa-globe box-icon"></i>
	</div>
	<div class="d-flex text-white align-items-center justify-content-around status-card">
		<div class="d-flex flex-column">
			<span class="fs-2 fw-bold"><%= totalLeadCountByStatusFinished %> </span>
			<span>Enrolled</span>
		</div>
		<i class="fa fa-tasks box-icon"></i>
	</div>
</div>