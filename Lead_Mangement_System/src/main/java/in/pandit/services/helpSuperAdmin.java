package in.pandit.services;

import java.io.IOException;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import in.pandit.dao.ContactDao;
import in.pandit.model.Contact;


@WebServlet("/helpSuperAdmin")
public class helpSuperAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher = null;
		String name = request.getParameter("name").trim();
		String email = request.getParameter("email").toLowerCase().trim();
		String subject = request.getParameter("subject").trim();
		String mobile = request.getParameter("mobile").trim();
		String comments = request.getParameter("comments").trim();
		Contact contact = new Contact();
		contact.setComment(comments);
		contact.setEmail(email);
		contact.setMobile(mobile);
		contact.setName(name);
		contact.setSubject(subject);
		ContactDao contactDao = new ContactDao();
		
		if(email!=null || !"".equals(email)) {
			String to = "heeralalgupta825313@gmail.com";// change accordingly
			// Get the session object
			Properties props = new Properties();
			props.put("mail.smtp.host", "smtp.gmail.com");
			props.put("mail.smtp.socketFactory.port", "465");
			props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
			props.put("mail.smtp.auth", "true");
			props.put("mail.smtp.port", "465");
			Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication("heeralalgupta000384@gmail.com", "jjgltxikdtugmqsz");// Put your email
				}
			});
			// compose message
			try {
				MimeMessage message = new MimeMessage(session);
				message.setFrom(new InternetAddress(email));// change accordingly
				message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
				message.setSubject("Mail from Lead Management System");
				message.setText("Name  : " + name);
				message.setText("Email  : " + email);
				message.setText("Mobile  : " + mobile);
				message.setText("Comments  : " + comments);
				// send message
				Transport.send(message);
				contactDao.insertContact(contact);
			}
			catch (MessagingException e) {
				throw new RuntimeException(e);
			}
			dispatcher = request.getRequestDispatcher("superadmin.jsp");
			request.setAttribute("messages","Data sent Successfully");
			dispatcher.forward(request, response);
		}
	}

}
