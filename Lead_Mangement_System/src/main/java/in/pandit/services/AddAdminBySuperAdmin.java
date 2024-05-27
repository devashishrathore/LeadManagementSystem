package in.pandit.services;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
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

@WebServlet("/AddAdminBySuperAdmin")
public class AddAdminBySuperAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String name = request.getParameter("name").trim();
		String mobile = request.getParameter("mobile").trim();
		String email = request.getParameter("email").toLowerCase().trim();
		String password = request.getParameter("password").trim();
		String gender = request.getParameter("gender").trim();
		CompanyDao companyDao = new CompanyDao();
		UserDao userDao = new UserDao();
		int compnayId = Integer.parseInt(request.getParameter("company").trim());
		Company company = companyDao.getCompanyById(compnayId);
		HttpSession session = request.getSession();
		if (company.getCompanyName() != null) {
			if (mobile.length() == 10) {
				User userByMobile = userDao.getUserByMobile(mobile, company.getCompanyId());
				if (userByMobile.getName() == null) {
					User userByEmail = userDao.getUserByEmail(email, company.getCompanyId());
					if (userByEmail.getName() == null) {
						User user = new User();
						user.setName(name);
						user.setMobile(mobile);
						user.setIsAdmin("Admin");
						user.setGender(gender);
						user.setEmail(email);
						user.setPassword(password);
						user.setCompanyId(company.getCompanyId());
						boolean b = userDao.addUser(user);
						if (b) {
							session.setAttribute("updateMsg", "Admin registered");
							response.sendRedirect("allAdmin.jsp");
						} else {
							session.setAttribute("adminMsg", "Something went wrong!");
							response.sendRedirect("superadmin.jsp");
						}
					} else {
						session.setAttribute("adminMsg", "User already registered with same email!");
						response.sendRedirect("superadmin.jsp");
					}
				} else {
					session.setAttribute("adminMsg", "User already registered with same mobile!");
					response.sendRedirect("superadmin.jsp");
				}
			} else {
				session.setAttribute("adminMsg", "Mobile number should be of 10 digit!");
				response.sendRedirect("superadmin.jsp");
			}
		} else {
			session.setAttribute("adminMsg", "Company not registered!");
			response.sendRedirect("superadmin.jsp");
		}

	}

}
