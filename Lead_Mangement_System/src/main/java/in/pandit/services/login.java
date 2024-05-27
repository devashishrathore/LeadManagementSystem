package in.pandit.services;

import java.io.IOException;

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

@WebServlet("/login")
public class login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Fetching data from login from

		String email = request.getParameter("email").trim().toLowerCase();
		String password = request.getParameter("pass").trim();
		// Declared variable for storing data, fetched from database
		HttpSession session = request.getSession();
		UserDao userDao = new UserDao();
		try {
			User user = userDao.loginUser(email, password);
			if (email.equals(user.getEmail())) {
				if (password.equals(user.getPassword())) {
					if (user.getName() != null) {
						if (user.getIsAdmin().equals("User")) {
							session.setAttribute("email", email);
							user.setPassword("");
							CookiesHelper.setCookies(user, response, "user");
							response.sendRedirect("dashboard.jsp");
						} else if (user.getIsAdmin().equals("Admin")) {
							session.setAttribute("email", email);
							user.setPassword("");
							CookiesHelper.setCookies(user, response, "user");
							response.sendRedirect("admin.jsp");
						} else if (user.getIsAdmin().equals("Superadmin")) {
							session.setAttribute("email", email);
							user.setPassword("");
							CookiesHelper.setCookies(user, response, "user");
							response.sendRedirect("superadmin.jsp");
						} else {
							session.setAttribute("error", "Invalid Email or Password !");
							response.sendRedirect("index.jsp");
						}
					} else {
						session.setAttribute("error", "Invalid Email or Password !");
						response.sendRedirect("index.jsp");
					}
				} else {
					session.setAttribute("error", "Wrong Password! try again");
					response.sendRedirect("index.jsp");
				}
			} else {
				session.setAttribute("error", "Wrong Email!");
				response.sendRedirect("index.jsp");
			}
		} catch (Exception e) {
			session.setAttribute("error", "Wrong Credentials!");
			response.sendRedirect("index.jsp");
		}
	}

}
