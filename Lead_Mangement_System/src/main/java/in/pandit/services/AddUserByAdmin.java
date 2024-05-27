package in.pandit.services;

import java.io.IOException;
import java.util.Objects;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.pandit.dao.UserDao;
import in.pandit.helper.CookiesHelper;
import in.pandit.model.User;

/**
 * Servlet implementation class UpdateAdminBySuperAdmin
 */
@WebServlet("/AddUserByAdmin")
public class AddUserByAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String name = request.getParameter("name");
		String mobile = request.getParameter("mobile");
		String email = request.getParameter("email").toLowerCase().trim();
		String password = request.getParameter("password");
		String gender = request.getParameter("gender");
		HttpSession session = request.getSession();
		UserDao userDao = new UserDao();
		User userCookie = CookiesHelper.getUserCookies(request, "user");
		int companyId = userCookie.getCompanyId();
		if (mobile.length() == 10) {
			User userByMobile = userDao.getUserByMobile(mobile, companyId);
			if (userByMobile.getName() == null) {
				User userByEmail = userDao.getUserByEmail(email, companyId);
				if (userByEmail.getName() == null) {
					User user = new User();
					user.setName(name);
					user.setMobile(mobile);
					user.setIsAdmin("User");
					user.setGender(gender);
					user.setEmail(email);
					user.setPassword(password);
					user.setCompanyId(companyId);
					boolean b = userDao.addUser(user);
					if (b) {
						session.setAttribute("adminMsg", "User registered");
						response.sendRedirect("allUsers.jsp");
					} else {
						session.setAttribute("already", "Something went wrong!");
						response.sendRedirect("admin.jsp");
					}
				} else {
					session.setAttribute("already", "User already registered with same email!");
					response.sendRedirect("admin.jsp");
				}
			} else {
				session.setAttribute("already", "User already registered with same mobile!");
				response.sendRedirect("admin.jsp");
			}
		} else {
			session.setAttribute("already", "Mobile number should be of 10 digit!");
			response.sendRedirect("admin.jsp");
		}
	}

}
