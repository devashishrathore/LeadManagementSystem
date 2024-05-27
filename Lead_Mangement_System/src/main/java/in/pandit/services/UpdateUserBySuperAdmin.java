package in.pandit.services;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.RequestDispatcher;
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
import in.pandit.model.Lead;
import in.pandit.model.User;

/**
 * Servlet implementation class UpdateAdminBySuperAdmin
 */
@WebServlet("/UpdateUserBySuperAdmin")
public class UpdateUserBySuperAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String name = request.getParameter("name").trim();
		String mobile = request.getParameter("mobile").trim();
		String email = request.getParameter("email").toLowerCase().trim();
		String gender = request.getParameter("gender").trim();
		HttpSession session = request.getSession();
		User user = CookiesHelper.getUserCookies(request, "userInfo");
		String userEmail = user.getEmail();
		UserDao userDao = new UserDao();
		LeadDao leadDao = new LeadDao();
		CommentDao commentDao = new CommentDao();
		if (mobile.length() == 10) {
			if (!mobile.equals(user.getMobile())) {
				User userByMobile = userDao.getUserByMobile(mobile, user.getCompanyId());
				if (userByMobile.getName() == null) {
					user.setMobile(mobile);
				} else {
					session.setAttribute("update", "Mobile number already available");
					response.sendRedirect("update-user-super-admin.jsp?update=" + user.getEmail());
					return;
				}
			}
			if (!email.equals(user.getEmail())) {
				User getUserByEmail = userDao.getUserByEmail(email, user.getCompanyId());
				if (getUserByEmail.getName() == null) {
					leadDao.updateCurrentOwnerEmail(email, userEmail);
					leadDao.updateOwnerEmail(email, userEmail);
					commentDao.updateCommentUserEmail(email, userEmail);
					user.setEmail(email);
				} else {
					session.setAttribute("update", "Email number already available");
					response.sendRedirect("update-user-super-admin.jsp?update=" + user.getEmail());
					return;
				}
			}
			user.setName(name);
			user.setGender(gender);
			boolean b = userDao.updateUserInformation(user);
			if (b) {
				session.setAttribute("update", "User Information updated");
				response.sendRedirect("allUsersSuperAdmin.jsp");
			} else {
				session.setAttribute("update", "Something went wrong!");
				response.sendRedirect("allUsersSuperAdmin.jsp");
			}
		} else {
			session.setAttribute("update", "Mobile number should be of 10 digit!");
			response.sendRedirect("update-user-super-admin.jsp?update=" + user.getEmail());
		}
	}

}
