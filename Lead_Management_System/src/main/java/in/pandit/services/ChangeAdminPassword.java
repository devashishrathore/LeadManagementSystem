package in.pandit.services;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.pandit.dao.UserDao;
import in.pandit.helper.CookiesHelper;
import in.pandit.model.User;

@WebServlet("/ChangeAdminPassword")
public class ChangeAdminPassword extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ChangeAdminPassword() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String oldPassword = request.getParameter("old-password");
		String newPassword = request.getParameter("new-password");
		String newPasswordAgain = request.getParameter("old-password-again");
		User userCookie = CookiesHelper.getUserCookies(request, "user");
		HttpSession session = request.getSession();
		UserDao userDao = new UserDao();
		session.setAttribute("email", userCookie.getEmail());
		if(newPassword.equals(newPasswordAgain)) {
			User user = userDao.getUserByEmail(userCookie.getEmail());
			if(oldPassword.equals(user.getPassword())) {
				boolean changed = userDao.changeUserPassword(user, newPassword);
				if(changed) {
					session.setAttribute("update", "Password Changed");
					response.sendRedirect("adminProfile.jsp");
				}else {
					session.setAttribute("change", "Something went wrong!");
					response.sendRedirect("updateAdminProfile.jsp");
				}
			}else {
				session.setAttribute("change", "Wrong old password! try again");
				response.sendRedirect("updateAdminProfile.jsp");
			}
		}else {
			session.setAttribute("change", "Both password should be same! try again");
			response.sendRedirect("updateAdminProfile.jsp");
		}
		
		
	}

}
