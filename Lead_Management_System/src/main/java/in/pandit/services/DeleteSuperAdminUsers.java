package in.pandit.services;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.pandit.dao.CommentDao;
import in.pandit.dao.UserDao;


@WebServlet("/DeleteSuperAdminUsers")
public class DeleteSuperAdminUsers extends HttpServlet {
	private static final long serialVersionUID = 1L;

   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("delete").trim());
		HttpSession session = request.getSession();
		UserDao userDao = new UserDao();
		CommentDao commentDao = new CommentDao();
		try {
			boolean check = userDao.deleteUserByUserId(id);
			if(check) {
				session.removeAttribute("updateMsg");
				commentDao.deleteCommentByUserId(id);
				session.setAttribute("updateMsg", "User Deleted");
				response.sendRedirect("allUsersSuperAdmin.jsp");
			}else {
				session.removeAttribute("updateMsg");
				session.setAttribute("updateMsg", "Something went wrong!");
				response.sendRedirect("allUsersSuperAdmin.jsp");
			}
		}catch(Exception e) {
			e.printStackTrace();
			session.removeAttribute("updateMsg");
			session.setAttribute("updateMsg", "Something went wrong!");
			response.sendRedirect("allUsersSuperAdmin.jsp");
		}
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("delete").trim());
		HttpSession session = request.getSession();
		UserDao userDao = new UserDao();
		CommentDao commentDao = new CommentDao();
		try {
			boolean check = userDao.deleteUserByUserId(id);
			if(check) {
				session.removeAttribute("updateMsg");
				commentDao.deleteCommentByUserId(id);
				session.setAttribute("updateMsg", "User Deleted");
				response.sendRedirect("allUsersSuperAdmin.jsp");
			}else {
				session.removeAttribute("updateMsg");
				session.setAttribute("updateMsg", "Something went wrong!");
				response.sendRedirect("allUsersSuperAdmin.jsp");
			}
		}catch(Exception e) {
			e.printStackTrace();
			session.removeAttribute("updateMsg");
			session.setAttribute("updateMsg", "Something went wrong!");
			response.sendRedirect("allUsersSuperAdmin.jsp");
		}
	}

}
