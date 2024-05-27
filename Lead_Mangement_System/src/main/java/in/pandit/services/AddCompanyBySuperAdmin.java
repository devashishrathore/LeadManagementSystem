package in.pandit.services;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.pandit.dao.CompanyDao;
import in.pandit.dao.UserDao;
import in.pandit.model.Company;
import in.pandit.model.User;

@WebServlet("/AddCompanyBySuperAdmin")
public class AddCompanyBySuperAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String companyName = request.getParameter("company-name");
		String companyAddress = request.getParameter("company-address");
		String managerContact = request.getParameter("manager-contact");
		String managerName = request.getParameter("manager-name");
		String managerEmail = request.getParameter("manager-email");
		HttpSession session = request.getSession();
		CompanyDao companyDao = new CompanyDao();
		Company getCompanyByMobile = companyDao.getCompanyByMobile(managerContact);
		if (managerContact.length() == 10) {
			if (getCompanyByMobile.getCompanyName() == null) {
				Company getCompanyByEmail = companyDao.getCompanyByEmail(managerEmail);
				if (getCompanyByEmail.getCompanyName() == null) {
					Company company = new Company();
					company.setCompanyAddress(companyAddress);
					company.setCompanyName(companyName);
					company.setManagerContact(managerContact);
					company.setManagerEmail(managerEmail);
					company.setManagerName(managerName);
					int inserted = companyDao.insertCompany(company);
					if(inserted>0) {
						session.setAttribute("company-register", "Company registered");
						response.sendRedirect("all-company.jsp");
					}
				} else {
					session.setAttribute("company-register", "Company already registered with same email!");
					response.sendRedirect("superadmin.jsp");
				}
			} else {
				session.setAttribute("company-register", "Company already registered with same mobile!");
				response.sendRedirect("superadmin.jsp");
			}
		} else {
			session.setAttribute("company-register", "Mobile number should be of 10 digit!");
			response.sendRedirect("superadmin.jsp");
		}
	}

}
