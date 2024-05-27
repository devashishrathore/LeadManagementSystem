package in.pandit.services;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.pandit.dao.LeadDao;
import in.pandit.helper.CookiesHelper;
import in.pandit.model.Lead;
import in.pandit.model.User;

@WebServlet("/updateAdminAllLeads")
public class updateAdminAllLeads extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		PrintWriter pw = response.getWriter();
		int id = Integer.parseInt(request.getParameter("id").trim());
		String name = request.getParameter("name").trim();
		String email = request.getParameter("email").trim().toLowerCase();
		String address = request.getParameter("address").trim();
		String mobile = request.getParameter("mobile").trim();
		String source = request.getParameter("source").trim();
		String owner = request.getParameter("owner").trim();
		String currentOwner = request.getParameter("currentOwner").trim();
		String status = request.getParameter("status").trim();
		String education = request.getParameter("education").trim();
		String experience = request.getParameter("experience").trim();
		int salary = Integer.parseInt(request.getParameter("salary").trim());
		HttpSession session = request.getSession();
		User userCookie = CookiesHelper.getUserCookies(request, "user");
		LeadDao leadDao = new LeadDao();
		int companyId = userCookie.getCompanyId();
		Lead lead = leadDao.getLeadById(id);

		Lead leadCookie = CookiesHelper.getLeadCookies(request, "lead");
		if (mobile.length() == 10) {

			if (!mobile.equals(leadCookie.getMobile())) {
				boolean isMobileAvailable = leadDao.validateMobileByCompanyId(mobile, companyId);
				if (isMobileAvailable) {
					lead.setMobile(mobile);
				} else {
					session.setAttribute("adminMsg", "Lead already available with same mobile!");
					response.sendRedirect("updateAdminAllLeads.jsp?update=" + id);
					return;
				}
			}

			if (!email.equals(leadCookie.getEmail())) {
				boolean isEmailAvailable = leadDao.validateEmailByCompanyId(email, companyId);
				if (isEmailAvailable) {
					lead.setEmail(email);

				} else {
					session.setAttribute("adminMsg", "Lead already available with same email!");
					response.sendRedirect("updateAdminAllLeads.jsp?update=" + id);
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
			lead.setCompanyId(companyId);
			lead.setSalary(salary);
			lead.setEducation(education);
			lead.setExperience(experience);
			int insert = leadDao.updateLead(lead);
			if (insert > 0) {
				session.removeAttribute("adminMsg");
				pw.println("<script type=\"text/javascript\">");
				pw.println("alert('Lead updated Successfully');");
				pw.println("</script>");
				session.setAttribute("adminMsg", "Lead updated Successfully");
				response.sendRedirect("allLeads.jsp");
			} else {
				session.removeAttribute("adminMsg");
				pw.println("<script type=\"text/javascript\">");
				pw.println("alert('Something went wrong! try again');");
				pw.println("</script>");
				session.setAttribute("adminMsg", "Something went wrong! try again");
				response.sendRedirect("allLeads.jsp");
			}
		} else {
			session.setAttribute("adminMsg", "Mobile number should be of 10 digit!");
			response.sendRedirect("updateAdminAllLeads.jsp?update=" + id);
		}
	}

}
