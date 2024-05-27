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

import in.pandit.dao.UserDao;
import in.pandit.helper.CookiesHelper;
import in.pandit.model.User;
import in.pandit.persistance.DatabaseConnection;

@WebServlet("/updateUserProfile")
public class updateUserProfile extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String name = request.getParameter("name").trim();
		String email = request.getParameter("email").toLowerCase().trim();
		String mobile = request.getParameter("mobile").trim();
		String gender = request.getParameter("gender").trim();
		HttpSession session = request.getSession();
		UserDao userDao = new UserDao();
		User user = CookiesHelper.getUserCookies(request, "user");
		if (mobile.length() == 10) {
			if (!mobile.equals(user.getMobile())) {
				User userByMobile = userDao.getUserByMobile(mobile, user.getCompanyId());
				if (userByMobile.getName() == null) {
					user.setMobile(mobile);
				} else {
					session.setAttribute("userMsg", "Mobile number already available");
					response.sendRedirect("updateProfileForm.jsp");
					return;
				}
			}
			user.setEmail(email);
			user.setName(name);
			user.setGender(gender);
			boolean check = userDao.updateUserInformation(user);
			if (check) {
				CookiesHelper.setCookies(user, response, "user");
				session.setAttribute("userMsg", "Data Updated Successfully");
				response.sendRedirect("profile.jsp");
			} else {
				session.setAttribute("userMsg", "Data Not Updated Successfully");
				response.sendRedirect("profile.jsp");
			}
		} else {
			session.setAttribute("userMsg", "Mobile number should be of 10 digit!");
			response.sendRedirect("updateProfileForm.jsp");
		}
	}

}
