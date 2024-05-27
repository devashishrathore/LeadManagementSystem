package in.pandit.services;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.pandit.dao.LeadDao;
import in.pandit.dao.SuperAdminDao;
import in.pandit.model.Lead;
import in.pandit.persistance.DatabaseConnection;


@WebServlet("/addLeadsSuperAdmin")
public class addLeadsSuperAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;

    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter pw = response.getWriter();
		String name = request.getParameter("name").trim();
		String email = request.getParameter("email").trim().toLowerCase();
		String address = request.getParameter("address").trim();
		String mobile = request.getParameter("mobile").trim();
		String source = request.getParameter("source").toLowerCase().trim();
		String owner = request.getParameter("owner").trim();
		String currentOwner = request.getParameter("currentOwner").trim();
		String status = request.getParameter("status").trim();
		HttpSession session = request.getSession();
		SuperAdminDao superAdminDao = new SuperAdminDao();
		LeadDao leadDao = new LeadDao();
		Lead leadByMobile = superAdminDao.getLeadByMobile(mobile);
		if (mobile.length() == 10) {
			if(leadByMobile.getName()==null){
			Lead leadByEmail = superAdminDao.getLeadByEmail(email);
			if(leadByEmail.getName()==null){
				Lead lead = new Lead();
				lead.setAddress(address);
				lead.setCurrentowner(currentOwner);
				lead.setEmail(email);
				lead.setMobile(mobile);
				lead.setName(name);
				lead.setOwner(owner);
				lead.setSource(source);
				lead.setStatus(status);
				lead.setCompanyId(superAdminDao.getCompanyIdByCurrentOwner(currentOwner));
				int insert = leadDao.insertLead(lead);
				if(insert>0) {
					pw.println("<script type=\"text/javascript\">");
					pw.println("alert('Lead added Successfully');");
					pw.println("</script>");
					RequestDispatcher rd = request.getRequestDispatcher("allLeadsSuperAdmin.jsp");
					rd.include(request, response);
				}else {
					pw.println("<script type=\"text/javascript\">");
					pw.println("alert('Something went wrong! try again');");
					pw.println("</script>");
					session.setAttribute("already-lead", "Something went wrong! try again");
					response.sendRedirect("superadmin.jsp");
				}
				}else {
					session.setAttribute("already-lead", "Lead already available with same email!");
					response.sendRedirect("superadmin.jsp");
				}
			}else {
				session.setAttribute("already-lead", "Lead already available with same mobile!");
				response.sendRedirect("superadmin.jsp");
			}
		} else {
			session.setAttribute("already-lead", "Mobile number should be of 10 digit!");
			response.sendRedirect("superadmin.jsp");
		}
	}

}
