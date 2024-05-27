package in.pandit.services;

import java.io.IOException;
import java.util.Objects;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.pandit.dao.CommentDao;
import in.pandit.dao.LeadDao;
import in.pandit.dao.UserDao;
import in.pandit.model.Comment;
import in.pandit.model.Lead;

/**
 * Servlet implementation class UpdateSuperAdminComment
 */
@WebServlet("/UpdateAdminComment")
public class UpdateAdminComment extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int commentId = Integer.parseInt(request.getParameter("comment-id"));
		String comment = request.getParameter("comment");
		String status = request.getParameter("status");
		LeadDao leadDao = new LeadDao();
		CommentDao commentDao = new CommentDao();
		Comment comments = commentDao.getCommentByCommentId(commentId);
		HttpSession session = request.getSession();
		Lead lead = leadDao.getLeadById(comments.getLeadid());
		if(Objects.nonNull(comments)) {
			lead.setStatus(status);
			comments.setComment(comment);
			commentDao.updateComment(comments);
			leadDao.updateLead(lead);
			session.setAttribute("adminMsg", "Comment Updated");
			response.sendRedirect("allLeads.jsp");
		}else {
			session.setAttribute("adminMsg", "Error Updating Comment!");
			response.sendRedirect("allLeads.jsp");
		}
	}

}
