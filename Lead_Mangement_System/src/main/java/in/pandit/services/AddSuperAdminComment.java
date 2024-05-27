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
import in.pandit.helper.CookiesHelper;
import in.pandit.model.Comment;
import in.pandit.model.User;

/**
 * Servlet implementation class AddComment
 */
@WebServlet("/AddSuperAdminComment")
public class AddSuperAdminComment extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public AddSuperAdminComment() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int leadid = Integer.parseInt(request.getParameter("leadid"));
		String commentText = request.getParameter("comment");
		HttpSession session = request.getSession();
		User user = CookiesHelper.getUserCookies(request, "user");
		CommentDao commentDao = new CommentDao();
		try {
			Comment comment = new Comment();
			comment.setComment(commentText);
			comment.setUserid(user.getId());
			comment.setUseremail(user.getEmail());
			comment.setLeadid(leadid);
			comment.setCompanyId(-1);
			int done = commentDao.insertComment(comment);
			if(done>0) {
				session.setAttribute("superAdminMsg", "Comment Posted");
				response.sendRedirect("allLeadsSuperAdmin.jsp");
			}else {
				session.setAttribute("comment", "Something went wrong! please try again");
				response.sendRedirect("add-superadmin-comment.jsp?leadid="+leadid+"&useremail="+user.getEmail());
			}
		} catch (Exception e) {
			e.printStackTrace();
			session.setAttribute("comment", "Something went wrong! please try again");
			response.sendRedirect("add-superadmin-comment.jsp?leadid="+leadid+"&useremail="+user.getEmail());
		}
	}

}
