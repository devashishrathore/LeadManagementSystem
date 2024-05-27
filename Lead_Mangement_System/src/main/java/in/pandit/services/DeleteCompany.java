package in.pandit.services;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.pandit.dao.CompanyDao;
import in.pandit.dao.LeadDao;
import in.pandit.dao.UserDao;

/**
 * Servlet implementation class DeleteCompany
 */
@WebServlet("/DeleteCompany")
public class DeleteCompany extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int companyid = Integer.parseInt(request.getParameter("delete"));
		HttpSession session = request.getSession();
		CompanyDao companyDao = new CompanyDao();
		UserDao userDao = new UserDao();
		LeadDao leadDao = new LeadDao();
		try {
			int companyDelete = companyDao.deleteCompany(companyid);
			if(companyDelete> 0) {
				userDao.deleteUserByCompanyId(companyid);
				leadDao.deleteLeadByCompanyId(companyid);
				session.setAttribute("company-register", "Data Deleted Successfully");
				response.sendRedirect("all-company.jsp");
			}else {
				session.setAttribute("company-register", "Something went wrong!");
				response.sendRedirect("all-company.jsp");
			}
		} catch (Exception e) {
			session.setAttribute("company-register", "Something went wrong!");
			response.sendRedirect("all-company.jsp");
		}
	}

}
