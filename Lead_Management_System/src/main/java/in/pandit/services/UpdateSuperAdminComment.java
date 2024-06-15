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
import in.pandit.model.Comment;
import in.pandit.model.Lead;

@WebServlet("/UpdateSuperAdminComment")
public class UpdateSuperAdminComment extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int commentId = Integer.parseInt(request.getParameter("comment-id"));
		LeadDao leadDao = new LeadDao();

		String comment = request.getParameter("comment");
		String status = request.getParameter("status");
		CommentDao commentDao = new CommentDao();
		Comment comments = commentDao.getCommentByCommentId(commentId);
		Lead lead = leadDao.getLeadById(comments.getLeadid());
		HttpSession session = request.getSession();
		if(Objects.nonNull(comments)) {
			session.removeAttribute("superAdminMsg");
			session.setAttribute("superAdminMsg", "Comment Updated");
			lead.setStatus(status);
			comments.setComment(comment);
			commentDao.updateComment(comments);
			leadDao.updateLead(lead);
		}
		response.sendRedirect("allLeadsSuperAdmin.jsp");
	}

}
