package in.pandit.services;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.pandit.dao.CommentDao;
import in.pandit.dao.CompanyDao;
import in.pandit.dao.LeadDao;
import in.pandit.dao.UserDao;
import in.pandit.helper.CookiesHelper;
import in.pandit.model.Company;
import in.pandit.model.User;

/**
 * Servlet implementation class UpdateCompany
 */
@WebServlet("/UpdateCompany")
public class UpdateCompany extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public UpdateCompany() {
        super();
        // TODO Auto-generated constructor stub
    }
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String companyName = request.getParameter("company-name");
		String companyAddress = request.getParameter("company-address");
		String managerContact = request.getParameter("manager-contact");
		String managerName = request.getParameter("manager-name");
		String managerEmail = request.getParameter("manager-email");
		Company company = CookiesHelper.getCompanyCookies(request, "company");
		HttpSession session = request.getSession();
		CompanyDao companyDao = new CompanyDao();
		Company companyById = companyDao.getCompanyById(company.getCompanyId());
		if(managerContact.length() == 10) {
			if (!managerContact.equals(company.getManagerContact())) {
				Company getCompanyByMobile = companyDao.getCompanyByMobile(managerContact);
				if (getCompanyByMobile.getCompanyName() == null) {
					companyById.setManagerContact(managerContact);
				} else {
					session.setAttribute("company-register", "Mobile number already available");
					response.sendRedirect("update-company.jsp?update=" + company.getCompanyId());
					return;
				}
			}
			if (!managerEmail.equals(company.getManagerEmail())) {
				Company  getCompanyByEmail= companyDao.getCompanyByEmail(managerEmail);
				if (getCompanyByEmail.getCompanyName() == null) {
					companyById.setManagerEmail(managerEmail);
				} else {
					session.setAttribute("company-register", "Email id already available");
					response.sendRedirect("update-company.jsp?update=" + company.getCompanyId());
					return;
				}
			}
			companyById.setCompanyAddress(companyAddress);
			companyById.setCompanyName(companyName);
			companyById.setManagerName(managerName);
			int update = companyDao.updateCompany(companyById);
			if(update>0) {
				session.setAttribute("company-register", "Company Information Updated");
				response.sendRedirect("all-company.jsp");
			}else {
				session.setAttribute("company-register", "Something went wrong");
				response.sendRedirect("update-company.jsp?update=" + company.getCompanyId());
			}

		}else {
			session.setAttribute("company-register", "Email id already available");
			response.sendRedirect("update-company.jsp?update=" + company.getCompanyId());
			
		}
	}

}
