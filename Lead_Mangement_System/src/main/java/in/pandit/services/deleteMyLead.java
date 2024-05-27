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

import in.pandit.persistance.DatabaseConnection;


@WebServlet("/deleteMyLead")
public class deleteMyLead extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("delete").trim();
		HttpSession session = request.getSession();
		try {
			Connection conn = DatabaseConnection.getConnection();
			PreparedStatement pst = conn.prepareStatement("delete from leads where email = ?");
			pst.setString(1, email);
			int check = pst.executeUpdate();
			if(check>0) {
				session.setAttribute("msg", "Data Deleted Successfully");
				response.sendRedirect("allUserLeads.jsp");
			}else {
				session.setAttribute("msg", "Something went wrong!");
				response.sendRedirect("allUserLeads.jsp");
			}
		}catch(Exception e) {
			e.printStackTrace();
			session.setAttribute("msg", "Something went wrong!");
			response.sendRedirect("allUserLeads.jsp");
		}
	}

}
