package in.pandit.services;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import in.pandit.persistance.DatabaseConnection;


@WebServlet("/RegisterUsers")
public class RegisterUser extends HttpServlet {
	private static final long serialVersionUID = 1L;

    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter pw = response.getWriter();
		String username = request.getParameter("name").trim();
		String email = request.getParameter("email").toLowerCase().trim();
		String mobile = request.getParameter("mobile").trim();
		String password = request.getParameter("password").trim();
		String admin = "User";
		String gender = request.getParameter("gender").trim();
		
		try {
			Connection connect = DatabaseConnection.getConnection();
			
//			 Fetching max id from sign up table for auto increment id
			int count = 0;
			PreparedStatement st = connect.prepareStatement("select max(id) as id from users");

			ResultSet rs = st.executeQuery();
			while (rs.next()) {
				count = rs.getInt("id");
			}
			
			HttpSession session = request.getSession();
			session.setAttribute("totalLeads", count);
			
			
			// Inserting data into data base
			PreparedStatement stmt = connect.prepareStatement("INSERT INTO users(name,email,mobile,password,isadmin,gender) values( ?, ?, ?, ?, ?, ?)");
			stmt.setString(1, username);
			stmt.setString(2, email);
			stmt.setString(3, mobile);
			stmt.setString(4, password);
			stmt.setString(5, admin);
			stmt.setString(6, gender);

			int status = stmt.executeUpdate();
		if(status > 0) {
			pw.println("<script type=\"text/javascript\">");
			pw.println("alert('You have registered Successfully');");
			pw.println("</script>");
			RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
			rd.include(request, response);
			
		}
		else {
			pw.print("Something wrong with database");
		}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		
	}

}
