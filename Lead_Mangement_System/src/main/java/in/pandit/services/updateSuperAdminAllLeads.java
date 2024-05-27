package in.pandit.services;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.pandit.dao.CommentDao;
import in.pandit.dao.LeadDao;
import in.pandit.dao.SuperAdminDao;
import in.pandit.helper.CookiesHelper;
import in.pandit.model.Lead;

@WebServlet("/updateSuperAdminAllLeads")
public class updateSuperAdminAllLeads extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		PrintWriter pw = response.getWriter();
		int id = Integer.parseInt(request.getParameter("id").trim());
		String name = request.getParameter("name").trim();
		String email = request.getParameter("email").toLowerCase().trim();
		String address = request.getParameter("address").trim();
		String mobile = request.getParameter("mobile").trim();
		String source = request.getParameter("source").trim();
		String date = request.getParameter("date").trim();
		String owner = request.getParameter("owner").trim();
		String currentOwner = request.getParameter("currentOwner").trim();
		String status = request.getParameter("status").trim();
		HttpSession session = request.getSession();
		LeadDao leadDao = new LeadDao();
		
		
		Lead lead = leadDao.getLeadById(id);

		Lead leadCookie = CookiesHelper.getLeadCookies(request, "lead");
		if (mobile.length() == 10) {
			if (!mobile.equals(leadCookie.getMobile())) {
				boolean isMobileAvailable = leadDao.validateMobileByCompanyId(mobile, 0);
				if (isMobileAvailable) {
					lead.setMobile(mobile);
				} else {
					session.setAttribute("mobileUpdateMsg", "Lead already available with same mobile!");
					response.sendRedirect("updateSuperAdminAllLeads.jsp?update=" + id);
					return;
				}
			}

			if (!email.equals(leadCookie.getEmail())) {
				boolean isEmailAvailable = leadDao.validateEmailByCompanyId(email, 0);
				if (isEmailAvailable) {
					lead.setEmail(email);
				} else {
					session.setAttribute("emailUpdateMsg", "Lead already available with same email!");
					response.sendRedirect("updateSuperAdminAllLeads.jsp?update=" + id);
					return;
				}
			}

			lead.setAddress(address);
			lead.setCurrentowner(currentOwner);
			lead.setName(name);
			lead.setOwner(owner);
			lead.setSource(source);
			lead.setStatus(status);
			lead.setId(id);
			int insert = leadDao.updateLead(lead);
			if (insert > 0) {
				session.removeAttribute("updateMsg");
				pw.println("<script type=\"text/javascript\">");
				pw.println("alert('Lead updated Successfully');");
				pw.println("</script>");
				session.setAttribute("updateMsg", "Lead updated Successfully");
				response.sendRedirect("allLeadsSuperAdmin.jsp");
			} else {
				session.removeAttribute("updateMsg");
				pw.println("<script type=\"text/javascript\">");
				pw.println("alert('Something went wrong! try again');");
				pw.println("</script>");
				session.setAttribute("updateMsg", "Something went wrong! try again");
				response.sendRedirect("allLeadsSuperAdmin.jsp");
			}
		} else {
			session.setAttribute("emailUpdateMsg", "Mobile number should be of 10 digit!");
			response.sendRedirect("updateSuperAdminAllLeads.jsp?update=" + id);
		}
	}

}
