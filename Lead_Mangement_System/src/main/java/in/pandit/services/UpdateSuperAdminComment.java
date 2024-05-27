package in.pandit.services;

import java.io.IOException;
import java.util.Objects;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import in.pandit.dao.CommentDao;
import in.pandit.model.Comment;

@WebServlet("/UpdateSuperAdminComment")
public class UpdateSuperAdminComment extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int commentId = Integer.parseInt(request.getParameter("comment-id"));
		String comment = request.getParameter("comment");
		CommentDao commentDao = new CommentDao();
		Comment comments = commentDao.getCommentByCommentId(commentId);
		if(Objects.nonNull(comments)) {
			comments.setComment(comment);
			commentDao.updateComment(comments);
		}
		response.sendRedirect("allLeadsSuperAdmin.jsp");
	}

}
