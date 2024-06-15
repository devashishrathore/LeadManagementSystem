package in.pandit.services;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.pandit.dao.LeadDao;


@WebServlet("/deleteSuperAdminLead")
public class DeleteSuperAdminLead extends HttpServlet {
	private static final long serialVersionUID = 1L;

   
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("delete").trim());
		HttpSession session = request.getSession();
		LeadDao leadDao = new LeadDao();
		try {
			int check = leadDao.deleteLeadByLeadId(id);
			if(check>0) {
				session.removeAttribute("updateMsg");
				session.setAttribute("updateMsg", "Data Deleted Successfully");
				response.sendRedirect("allLeadsSuperAdmin.jsp");
			}else {
				session.removeAttribute("updateMsg");
				session.setAttribute("updateMsg", "Something went wrong!");
				response.sendRedirect("allLeadsSuperAdmin.jsp");
			}
		}catch(Exception e) {
			e.printStackTrace();
			session.removeAttribute("updateMsg");
			session.setAttribute("updateMsg", "Something went wrong!");
			response.sendRedirect("allLeadsSuperAdmin.jsp");
		}
	}
		protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			int id = Integer.parseInt(request.getParameter("delete").trim());
			HttpSession session = request.getSession();
			LeadDao leadDao = new LeadDao();
			try {
				int check = leadDao.deleteLeadByLeadId(id);
				if(check>0) {
					session.removeAttribute("updateMsg");
					session.setAttribute("updateMsg", "Data Deleted Successfully");
					response.sendRedirect("allLeadsSuperAdmin.jsp");
				}else {
					session.removeAttribute("updateMsg");
					session.setAttribute("updateMsg", "Something went wrong!");
					response.sendRedirect("allLeadsSuperAdmin.jsp");
				}
			}catch(Exception e) {
				session.removeAttribute("updateMsg");
				e.printStackTrace();
				session.setAttribute("updateMsg", "Something went wrong!");
				response.sendRedirect("allLeadsSuperAdmin.jsp");
			}
	}

}
