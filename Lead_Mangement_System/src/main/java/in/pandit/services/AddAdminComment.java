package in.pandit.services;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.pandit.dao.CommentDao;
import in.pandit.dao.LeadDao;
import in.pandit.helper.CookiesHelper;
import in.pandit.model.Comment;
import in.pandit.model.Lead;
import in.pandit.model.User;

/**
 * Servlet implementation class AddComment
 */
@WebServlet("/AddAdminComment")
public class AddAdminComment extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public AddAdminComment() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int leadid = Integer.parseInt(request.getParameter("leadid"));
		String commentText = request.getParameter("comment");
		HttpSession session = request.getSession();
		String status = request.getParameter("status");
		User user = CookiesHelper.getUserCookies(request, "user");
		LeadDao leadDao = new LeadDao();
		CommentDao commentDao = new CommentDao();
		Lead lead = leadDao.getLeadById(leadid);
		int companyId = user.getCompanyId();
		try {
			Comment comment = new Comment();
			comment.setComment(commentText);
			comment.setUserid(user.getId());
			comment.setUseremail(user.getEmail());
			comment.setCompanyId(companyId);
			comment.setLeadid(leadid);
			int done = commentDao.insertComment(comment);
			if(done>0) {
				lead.setStatus(status);
				leadDao.updateLead(lead);
				session.setAttribute("adminMsg", "Comment Posted");
				response.sendRedirect("allLeads.jsp");
			}else {
				session.setAttribute("adminMsg", "Something went wrong! please try again");
				response.sendRedirect("add-admin-comment.jsp?leadid="+leadid+"&useremail="+user.getEmail());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
