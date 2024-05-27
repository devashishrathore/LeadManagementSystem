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
import in.pandit.persistance.DatabaseConnection;


@WebServlet("/DeleteAdmin")
public class DeleteAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;

   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("delete").trim());
		HttpSession session = request.getSession();
		UserDao userDao = new UserDao();
		CommentDao commentDao = new CommentDao();
		try {
			boolean check = userDao.deleteUserByUserId(id);
			if(check) {
				commentDao.deleteCommentByUserId(id);
				session.setAttribute("updateMsg", "Admin Deleted");
				response.sendRedirect("allAdmin.jsp");
			}else {
				session.setAttribute("updateMsg", "Something went wrong");
				response.sendRedirect("allAdmin.jsp");
			}
		}catch(Exception e) {
			session.setAttribute("updateMsg", "Something went wrong");
			response.sendRedirect("allAdmin.jsp");
		}
	}

}
