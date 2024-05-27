package in.pandit.services;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.pandit.dao.LeadDao;
import in.pandit.persistance.DatabaseConnection;


@WebServlet("/deleteSuperAdminLead")
public class deleteSuperAdminLead extends HttpServlet {
	private static final long serialVersionUID = 1L;

   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("delete").trim());
		HttpSession session = request.getSession();
		LeadDao leadDao = new LeadDao();
		try {
			int check = leadDao.deleteLeadByLeadId(id);
			if(check>0) {
				session.setAttribute("msg", "Data Deleted Successfully");
				response.sendRedirect("allLeadsSuperAdmin.jsp");
			}else {
				session.setAttribute("msg", "Something went wrong!");
				response.sendRedirect("allLeadsSuperAdmin.jsp");
			}
		}catch(Exception e) {
			e.printStackTrace();
			session.setAttribute("msg", "Something went wrong!");
			response.sendRedirect("allLeadsSuperAdmin.jsp");
		}
	}

}
