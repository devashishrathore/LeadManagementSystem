package in.pandit.services;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.pandit.dao.LeadDao;


@WebServlet("/deleteAdminLeads")
public class DeleteAdminLeads extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("delete").trim());
		LeadDao leadDao = new LeadDao();
		HttpSession session = request.getSession();
		try {
			int check = leadDao.deleteLeadByLeadId(id);
			if(check>0) {
				session.removeAttribute("adminMsg");
				session.setAttribute("adminMsg", "Lead Deleted Successfully");
				response.sendRedirect("allLeads.jsp");
			}else {
				session.removeAttribute("adminMsg");
				session.setAttribute("adminMsg", "Something went wrong!");
				response.sendRedirect("allLeads.jsp");
			}
		}catch(Exception e) {
			session.removeAttribute("adminMsg");
			session.setAttribute("adminMsg", "Something went wrong!");
			response.sendRedirect("allLeads.jsp");
		}
	}
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("delete").trim());
		LeadDao leadDao = new LeadDao();
		HttpSession session = request.getSession();
		try {
			int check = leadDao.deleteLeadByLeadId(id);
			if(check>0) {
				session.removeAttribute("adminMsg");
				session.setAttribute("adminMsg", "Lead Deleted Successfully");
				response.sendRedirect("allLeads.jsp");
			}else {
				session.removeAttribute("adminMsg");
				session.setAttribute("adminMsg", "Something went wrong!");
				response.sendRedirect("allLeads.jsp");
			}
		}catch(Exception e) {
			session.removeAttribute("adminMsg");
			session.setAttribute("adminMsg", "Something went wrong!");
			response.sendRedirect("allLeads.jsp");
		}
	}

}
