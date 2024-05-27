package in.pandit.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import in.pandit.model.Comment;
import in.pandit.model.Contact;
import in.pandit.persistance.DatabaseConnection;

public class ContactDao {

	private static final String INSERT_CONTACT="INSERT INTO contacts(name,email,mobile,comments,subject) VALUES(?,?,?,?,?)";
	private static final String GET_CONTACT_BY_CONTACT_ID="SELECT * FROM contacts WHERE id=?";
	private static final String GET_CONTACTS="SELECT * FROM contacts";
	
	private static Connection con = DatabaseConnection.getConnection();
	private static PreparedStatement pst = null;
	
	public int insertContact(Contact contact) {
		int done = 0;
		try {
			pst = con.prepareStatement(INSERT_CONTACT);
			pst.setString(1, contact.getName());
			pst.setString(2, contact.getEmail());
			pst.setString(3, contact.getMobile());
			pst.setString(4, contact.getComment());
			pst.setString(5, contact.getSubject());
			done = pst.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return done;
	}
	
	public List<Contact> getAllContacts(){
		List<Contact> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_CONTACTS);
			ResultSet rst = pst.executeQuery();
			while(rst.next()) {
				Contact contact = new Contact();
				contact.setId(rst.getInt("id"));
				contact.setComment(rst.getString("comments"));
				contact.setSubject(rst.getString("subject"));
				contact.setName(rst.getString("name"));
				contact.setEmail(rst.getString("email"));
				contact.setMobile(rst.getString("mobile"));
				list.add(contact);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public Contact getContactsById(int id){
		Contact contact = new Contact();
		try {
			pst = con.prepareStatement(GET_CONTACT_BY_CONTACT_ID);
			pst.setInt(1, id);
			ResultSet rst = pst.executeQuery();
			while(rst.next()) {
				contact.setId(rst.getInt("id"));
				contact.setComment(rst.getString("comments"));
				contact.setSubject(rst.getString("subject"));
				contact.setName(rst.getString("name"));
				contact.setEmail(rst.getString("email"));
				contact.setMobile(rst.getString("mobile"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return contact;
	}
	
}
