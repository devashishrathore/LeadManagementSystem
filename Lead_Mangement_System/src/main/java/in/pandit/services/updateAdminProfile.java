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

import in.pandit.dao.CommentDao;
import in.pandit.dao.LeadDao;
import in.pandit.dao.UserDao;
import in.pandit.helper.CookiesHelper;
import in.pandit.model.User;
import in.pandit.persistance.DatabaseConnection;

@WebServlet("/updateAdminProfile")
public class updateAdminProfile extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String name = request.getParameter("name").trim();
		String email = request.getParameter("email").toLowerCase().trim();
		String mobile = request.getParameter("mobile").trim();
		String gender = request.getParameter("gender").trim();
		HttpSession session = request.getSession();
		User user = CookiesHelper.getUserCookies(request, "user");
		UserDao userDao = new UserDao();
		if (mobile.length() == 10) {
			if (!mobile.equals(user.getMobile())) {
				User userByMobile = userDao.getUserByMobile(mobile, user.getCompanyId());
				if (userByMobile.getName() == null) {
					user.setMobile(mobile);
				} else {
					session.setAttribute("update", "Mobile number already available");
					response.sendRedirect("updateAdminProfile.jsp");
					return;
				}
			}
			user.setEmail(email);
			user.setName(name);
			user.setGender(gender);
			boolean check = userDao.updateUserInformation(user);
			if (check) {
				CookiesHelper.setCookies(user, response, "user");
				session.setAttribute("update", "Data Updated Successfully");
				response.sendRedirect("adminProfile.jsp");
			} else {
				session.setAttribute("update", "Something went wrong!");
				response.sendRedirect("adminProfile.jsp");
			}
		} else {
			session.setAttribute("update", "Mobile number should be of 10 digit!");
			response.sendRedirect("updateAdminProfile.jsp");
		}
	}

}
