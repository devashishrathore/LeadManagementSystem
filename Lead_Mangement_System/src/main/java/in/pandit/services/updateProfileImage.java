package in.pandit.services;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import in.pandit.persistance.DatabaseConnection;


@WebServlet("/updateProfileImage")
@MultipartConfig(maxFileSize = 16177215)
public class updateProfileImage extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		InputStream inputStream = null;
		Part image = request.getPart("pfImage");
		
		HttpSession imgStatus = request.getSession();
	    inputStream = image.getInputStream();
		try {
			Connection conn = DatabaseConnection.getConnection();
			HttpSession session = request.getSession();
			String email = session.getAttribute("email").toString();
            PreparedStatement stmt = conn.prepareStatement("update users set image = ? where email = ?");
    
            if(image != null) {
            	stmt.setBinaryStream(1, inputStream);
            }
            stmt.setString(2, email);
            
            int status = stmt.executeUpdate();
            if(status > 0) {
            	
            	imgStatus.setAttribute("imgStatus", "Updated Profile");
            	response.sendRedirect("profile.jsp");
            }
            else {
            	imgStatus.setAttribute("imgStatus", "Something went wrong!");
            	response.sendRedirect("profile.jsp");
            }
		}catch(Exception e) {
			e.printStackTrace();
			imgStatus.setAttribute("imgStatus", "Something went wrong!");
        	response.sendRedirect("profile.jsp");
		}
	}

}
