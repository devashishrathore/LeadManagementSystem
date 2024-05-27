package in.pandit.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import in.pandit.model.Lead;
import in.pandit.model.User;
import in.pandit.persistance.DatabaseConnection;

public class SuperAdminDao {
	private static final String GET_LEAD_BY_ID = "SELECT * FROM leads WHERE id=?";
	private static final String GET_USER_BY_EMAIL = "SELECT * FROM users WHERE email=?";
	private static final String GET_ALL_USER_LIMIT_OFFSET = "SELECT * FROM users WHERE isadmin=? ORDER BY id DESC LIMIT ? OFFSET ? ";
	private static final String GET_USER_BY_MOBILE = "SELECT * FROM users WHERE mobile=?";
	public static final String TOTAL_COUNT = "SELECT COUNT(id) FROM users WHERE isadmin=? ";
	
	private static final String GET_LEAD_BY_EMAIL = "SELECT * FROM leads WHERE email=? ";
	private static final String GET_LEAD_BY_MOBILE = "SELECT * FROM leads WHERE mobile=? " ;
	private static final String GET_ALL_LEAD_BY_CURRENT_OWNER = "SELECT * FROM leads WHERE currentowner=? ";
	private static final String GET_ALL_LEAD_BY_OWNER = "SELECT * FROM leads WHERE owner=? ";
	private static final String TOTAL_LEADS_COUNT_OF_USER_USING_ID_AND_STATUS = "SELECT COUNT(id) FROM leads WHERE status=?";
	private static final String TOTAL_LEADS = "SELECT COUNT(id) FROM leads ";
	private static final String TOTAL_LEADS_COUNT_SOURCE = "SELECT COUNT(id) FROM leads WHERE source=?  ";
	private static final String TOTAL_LEADS_COUNT_SOURCE_FACEBOOK_OR_GOOGLE = "SELECT COUNT(id) FROM leads WHERE source=? OR source=? ";
	private static final String TOTAL_LEADS_COUNT_NEW_LEADS = "SELECT COUNT(id) FROM leads WHERE date::date = CURRENT_DATE  ";
	
	private static final String GET_ALL_LEADS_BY_OFFSET_AND_LIMIT = "SELECT * FROM leads  ORDER BY id DESC LIMIT ? OFFSET ? ";
	private static final String GET_ALL_LEADS_BY_OFFSET_AND_LIMIT_AND_CURRENTOWNER = "SELECT * FROM leads WHERE currentowner=? ORDER BY id DESC LIMIT ? OFFSET ? ";
	
	
	private static final String INSERT_LEAD = "INSERT INTO leads(name,email,address,mobile,source,owner,currentowner,status,companyid) VALUES(?, ?, ?, ?, ?, ?, ?, ?,?)";
	
	
	private static Connection con = DatabaseConnection.getConnection();
	private static PreparedStatement pst = null;
	
	public int getTotalLeadsCount() {
		int count = 0;
		try {
			pst = con.prepareStatement(TOTAL_LEADS);
			ResultSet rst = pst.executeQuery();
			if (rst.next()) {
				count = rst.getInt(1);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return count;
	}
	public int insertLead(Lead lead) {
		int done = 0;
		try {
			pst = con.prepareStatement(INSERT_LEAD);
			pst.setString(1, lead.getName());
			pst.setString(2, lead.getEmail());
			pst.setString(3, lead.getAddress());
			pst.setString(4, lead.getMobile());
			pst.setString(5, lead.getSource());
			pst.setString(6, lead.getOwner());
			pst.setString(7, lead.getCurrentowner());
			pst.setString(8, lead.getStatus());
			pst.setInt(9, lead.getCompanyId());
			done = pst.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return done;
	}

	public Lead getLeadById(int leadId) {
		Lead lead = null;
		try {
			pst = con.prepareStatement(GET_LEAD_BY_ID);
			pst.setInt(1, leadId);
			ResultSet rst=  pst.executeQuery();
			lead = new Lead();
			while(rst.next()) {
				lead.setId(rst.getInt("id"));
				lead.setAddress(rst.getString("address"));
				lead.setCurrentowner(rst.getString("currentowner"));
				lead.setEmail(rst.getString("email"));
				lead.setMobile(rst.getString("mobile"));
				lead.setName(rst.getString("name"));
				lead.setOwner(rst.getString("owner"));
				lead.setSource(rst.getString("source"));
				lead.setStatus(rst.getString("status"));
				lead.setCreationDate(rst.getTimestamp("creation_date"));
				lead.setCompanyId(rst.getInt("companyid"));
				return lead;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return lead;
	}
	public int getCompanyIdByCurrentOwner(String currentOwner) {
		int companyId = 0;
		try {
			pst = con.prepareStatement(GET_USER_BY_EMAIL);
			pst.setString(1, currentOwner);
			ResultSet rst=  pst.executeQuery();
			while(rst.next()) {
				companyId = rst.getInt("companyid");
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return companyId;
	}
	public Lead getLeadByEmail(String leadEmail) {
		Lead lead = null;
		try {
			pst = con.prepareStatement(GET_LEAD_BY_EMAIL);
			pst.setString(1, leadEmail);
			ResultSet rst=  pst.executeQuery();
			lead = new Lead();
			while(rst.next()) {
				lead.setAddress(rst.getString("id"));
				lead.setCurrentowner(rst.getString("currentowner"));
				lead.setEmail(rst.getString("email"));
				lead.setCreationDate(rst.getTimestamp("creation_date"));
				lead.setId(rst.getInt("id"));
				lead.setMobile(rst.getString("mobile"));
				lead.setName(rst.getString("name"));
				lead.setOwner(rst.getString("owner"));
				lead.setSource(rst.getString("source"));
				lead.setStatus(rst.getString("status"));
				lead.setCompanyId(rst.getInt("companyid"));
				return lead;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return lead;
	}
	
	public Lead getLeadByMobile(String mobile) {
		Lead lead = null;
		try {
			pst = con.prepareStatement(GET_LEAD_BY_MOBILE);
			pst.setString(1, mobile);
			ResultSet rst=  pst.executeQuery();
			lead = new Lead();
			while(rst.next()) {
				lead.setAddress(rst.getString("id"));
				lead.setCurrentowner(rst.getString("currentowner"));
				lead.setCreationDate(rst.getTimestamp("creation_date"));
				lead.setEmail(rst.getString("email"));
				lead.setId(rst.getInt("id"));
				lead.setMobile(rst.getString("mobile"));
				lead.setName(rst.getString("name"));
				lead.setOwner(rst.getString("owner"));
				lead.setSource(rst.getString("source"));
				lead.setStatus(rst.getString("status"));
				lead.setCompanyId(rst.getInt("companyid"));
				return lead;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return lead;
	}
	
	public List<Lead> getAllLeadByCurrentOwner(String currentOwner) {
		List<Lead> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_ALL_LEAD_BY_CURRENT_OWNER);
			pst.setString(1, currentOwner);
			ResultSet rst=  pst.executeQuery();
			while(rst.next()) {
				Lead lead = new Lead();
				lead.setAddress(rst.getString("id"));
				lead.setCurrentowner(rst.getString("currentowner"));
				lead.setEmail(rst.getString("email"));
				lead.setId(rst.getInt("id"));
				lead.setMobile(rst.getString("mobile"));
				lead.setName(rst.getString("name"));
				lead.setOwner(rst.getString("owner"));
				lead.setSource(rst.getString("source"));
				lead.setStatus(rst.getString("status"));
				lead.setCreationDate(rst.getTimestamp("creation_date"));
				lead.setCompanyId(rst.getInt("companyid"));
				list.add(lead);
				return list;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public List<Lead> getAllLeadByOwner(String Owner) {
		List<Lead> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_ALL_LEAD_BY_OWNER);
			pst.setString(1, Owner);
			ResultSet rst=  pst.executeQuery();
			while(rst.next()) {
				Lead lead = new Lead();
				lead.setAddress(rst.getString("id"));
				lead.setCurrentowner(rst.getString("currentowner"));
				lead.setEmail(rst.getString("email"));
				lead.setId(rst.getInt("id"));
				lead.setMobile(rst.getString("mobile"));
				lead.setName(rst.getString("name"));
				lead.setOwner(rst.getString("owner"));
				lead.setSource(rst.getString("source"));
				lead.setStatus(rst.getString("status"));
				lead.setCreationDate(rst.getTimestamp("creation_date"));
				lead.setCompanyId(rst.getInt("companyid"));
				list.add(lead);
				return list;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	


	public int getLeadsCount(String query, String countBy) {
		int count = 0;
		try {
			pst = con.prepareStatement(query);
			pst.setString(1, countBy);
			ResultSet rst = pst.executeQuery();
			if (rst.next()) {
				count = rst.getInt(1);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return count;
	}
	/* ********************************************************************
	 * ****** GET LEAD COUNT USING USER ID AND STATUS FOR ADMIN(COMPANY) **
	 * ********************************************************************
	 * */
	public int getLeadsCountUsingCompanyStatus(String status) {
		int count = 0;
		try {
			pst = con.prepareStatement(TOTAL_LEADS_COUNT_OF_USER_USING_ID_AND_STATUS);
			pst.setString(1, status);
			ResultSet rst = pst.executeQuery();
			if (rst.next()) {
				count = rst.getInt(1);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return count;
	}
	
	/* *********************************************************
	 * ****** GET LEAD COUNT USING USER ID FOR ADMIN(COMPANY) **
	 * *********************************************************
	 * */
	public int getLeadsCountUsingSourceAndCompany(String source) {
		int count = 0;
		try {
			pst = con.prepareStatement(TOTAL_LEADS_COUNT_SOURCE);
			pst.setString(1, source);
			ResultSet rst = pst.executeQuery();
			if (rst.next()) {
				count = rst.getInt(1);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return count;
	}
	/* *********************************************************
	 * ****** GET LEAD COUNT USING USER ID FOR ADMIN(COMPANY) **
	 * *********************************************************
	 * */
	public int getLeadsCountUsingSourceFacebookOrGoogleAndCompany() {
		int count = 0;
		try {
			pst = con.prepareStatement(TOTAL_LEADS_COUNT_SOURCE_FACEBOOK_OR_GOOGLE);
			pst.setString(1, "facebook");
			pst.setString(2, "google");
			ResultSet rst = pst.executeQuery();
			if (rst.next()) {
				count = rst.getInt(1);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return count;
	}
	/* *********************************************************
	 * ****** GET LEAD COUNT USING USER ID FOR ADMIN(COMPANY) **
	 * *********************************************************
	 * */
	public int getLeadsCountNewLeads() {
		int count = 0;
		try {
			pst = con.prepareStatement(TOTAL_LEADS_COUNT_NEW_LEADS);
			ResultSet rst = pst.executeQuery();
			if (rst.next()) {
				count = rst.getInt(1);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return count;
	}
	/* ***********************************************
	 * ****** GET ALL LEADS BY LIMIT AND OFFSET ******
	 * ***********************************************
	 * */
	public List<Lead> getAllLeadsByLimitOffsetAndCompany(int limit, int offset) {
		List<Lead> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_ALL_LEADS_BY_OFFSET_AND_LIMIT);
			pst.setInt(1, limit);
			pst.setInt(2, offset);
			ResultSet rst = pst.executeQuery();
			while(rst.next()){
				Lead lead = new Lead();
				lead.setId(rst.getInt("id"));
				lead.setName(rst.getString("name"));
				lead.setEmail(rst.getString("email"));
				lead.setAddress(rst.getString("address"));
				lead.setCurrentowner(rst.getString("currentowner"));
				lead.setMobile(rst.getString("mobile"));
				lead.setOwner(rst.getString("owner"));
				lead.setSource(rst.getString("source"));
				lead.setStatus(rst.getString("status"));
				lead.setCreationDate(rst.getTimestamp("creation_date"));
				lead.setCompanyId(rst.getInt("companyid"));
				list.add(lead);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
	/* ***********************************************
	 * ****** GET ALL LEADS BY LIMIT AND OFFSET ******
	 * ***********************************************
	 * */
	public List<Lead> getAllLeadsByLimitCurrentOwnerAndCompany(int limit, int offset,String currentOwner) {
		List<Lead> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_ALL_LEADS_BY_OFFSET_AND_LIMIT_AND_CURRENTOWNER);
			pst.setString(1, currentOwner);
			pst.setInt(2, limit);
			pst.setInt(3, offset);
			ResultSet rst = pst.executeQuery();
			while(rst.next()){
				Lead lead = new Lead();
				lead.setId(rst.getInt("id"));
				lead.setName(rst.getString("name"));
				lead.setEmail(rst.getString("email"));
				lead.setAddress(rst.getString("address"));
				lead.setCurrentowner(rst.getString("currentowner"));
				lead.setMobile(rst.getString("mobile"));
				lead.setOwner(rst.getString("owner"));
				lead.setSource(rst.getString("source"));
				lead.setStatus(rst.getString("status"));
				lead.setCreationDate(rst.getTimestamp("creation_date"));
				lead.setCompanyId(rst.getInt("companyid"));
				list.add(lead);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
	
	
	
	/*
	 * **************************************************************
	 * ************* SEARCH METHODS *********************************
	 * **************************************************************
	 * */
//	GET LEADS BY ADDRESS
//	GET LEADS BY NAME
//	GET LEADS BY ID
//	GET LEADS BY MOBILE
//	GET LEADS BY STATUS
//	GET LEADS BY OWNER
//	GET LEADS BY EMAIL
	public static final String SEARCH_LEADS_BY_ID_OFFSET_AND_LIMIT = "SELECT * FROM leads WHERE id=? ORDER BY id DESC LIMIT ? OFFSET ? ";
	public static final String SEARCH_LEADS_BY_EMAIL_OFFSET_AND_LIMIT = "SELECT * FROM leads WHERE email ILIKE ? ORDER BY id DESC LIMIT ? OFFSET ? ";
	public static final String SEARCH_LEADS_BY_ADDRESS_OFFSET_AND_LIMIT = "SELECT * FROM leads WHERE address ILIKE ? ORDER BY id DESC LIMIT ? OFFSET ? ";
	public static final String SEARCH_LEADS_BY_MOBILE_OFFSET_AND_LIMIT = "SELECT * FROM leads WHERE mobile ILIKE ? ORDER BY id DESC LIMIT ? OFFSET ? ";
	public static final String SEARCH_LEADS_BY_STATUS_OFFSET_AND_LIMIT = "SELECT * FROM leads WHERE status ILIKE ? ORDER BY id DESC LIMIT ? OFFSET ? ";
	public static final String SEARCH_LEADS_BY_OWNER_OFFSET_AND_LIMIT = "SELECT * FROM leads WHERE owner ILIKE ? ORDER BY id DESC LIMIT ? OFFSET ? ";
	public static final String SEARCH_LEADS_BY_NAME_OFFSET_AND_LIMIT = "SELECT * FROM leads WHERE name ILIKE ? ORDER BY id DESC LIMIT ? OFFSET ? ";
	
	
	public List<Lead> searchLead(String searchBy, String search, int limit, int offset){
		SuperAdminDao leadDao = new SuperAdminDao();
		List<Lead> list = new ArrayList<>();
		if(searchBy.equals("id")){
			try{
				int id = Integer.parseInt(search);
				pst = con.prepareStatement(SEARCH_LEADS_BY_ID_OFFSET_AND_LIMIT);
				pst.setInt(1, id);
				pst.setInt(2, limit);
				pst.setInt(3, offset);
				ResultSet rst = pst.executeQuery();
				while(rst.next()){
					Lead lead = new Lead();
					lead.setId(rst.getInt("id"));
					lead.setName(rst.getString("name"));
					lead.setEmail(rst.getString("email"));
					lead.setAddress(rst.getString("address"));
					lead.setCurrentowner(rst.getString("currentowner"));
					lead.setCreationDate(rst.getTimestamp("creation_date"));
					lead.setMobile(rst.getString("mobile"));
					lead.setOwner(rst.getString("owner"));
					lead.setSource(rst.getString("source"));
					lead.setStatus(rst.getString("status"));
					lead.setCompanyId(rst.getInt("companyid"));
					list.add(lead);
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(searchBy.equals("email")){
			list = leadDao.search(SEARCH_LEADS_BY_EMAIL_OFFSET_AND_LIMIT, search, limit, offset);
		}else if(searchBy.equals("address")){
			list = leadDao.search(SEARCH_LEADS_BY_ADDRESS_OFFSET_AND_LIMIT, search, limit, offset);
		}else if(searchBy.equals("name")){
			list = leadDao.search(SEARCH_LEADS_BY_NAME_OFFSET_AND_LIMIT, search, limit, offset);
		}else if(searchBy.equals("mobile")){
			list = leadDao.search(SEARCH_LEADS_BY_MOBILE_OFFSET_AND_LIMIT, search, limit, offset);
		}else if(searchBy.equals("owner")){
			list = leadDao.search(SEARCH_LEADS_BY_OWNER_OFFSET_AND_LIMIT, search, limit, offset);
		}else if(searchBy.equals("status")){
			list = leadDao.search(SEARCH_LEADS_BY_STATUS_OFFSET_AND_LIMIT, search, limit, offset);
		}
		return list;
	}
	public List<Lead> search(String query ,String search,int limit, int offset){
		List<Lead> list = new ArrayList<>();
		try{
			pst = con.prepareStatement(query);
			pst.setString(1, "%"+search+"%");
			pst.setInt(2, limit);
			pst.setInt(3, offset);
			ResultSet rst = pst.executeQuery();
			while(rst.next()){
				Lead lead = new Lead();
				lead.setId(rst.getInt("id"));
				lead.setName(rst.getString("name"));
				lead.setEmail(rst.getString("email"));
				lead.setAddress(rst.getString("address"));
				lead.setCurrentowner(rst.getString("currentowner"));
				lead.setCreationDate(rst.getTimestamp("creation_date"));
				lead.setMobile(rst.getString("mobile"));
				lead.setOwner(rst.getString("owner"));
				lead.setSource(rst.getString("source"));
				lead.setStatus(rst.getString("status"));
				lead.setCompanyId(rst.getInt("companyid"));

				list.add(lead);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return list;
	}
	
	public User getUserByEmail(String email) {
		User user = null;
		try {
			pst = con.prepareStatement(GET_USER_BY_EMAIL);
			pst.setString(1, email);
			ResultSet rst = pst.executeQuery();
			user = new User();
			while(rst.next()) {
				user.setId(rst.getInt("id"));
				user.setEmail(rst.getString("email"));
				user.setGender(rst.getString("gender"));
				user.setIsAdmin(rst.getString("isadmin"));
				user.setMobile(rst.getString("mobile"));
				user.setName(rst.getString("name"));
				user.setPassword(rst.getString("password"));
				user.setCompanyId(rst.getInt("companyid"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}
	public List<User> getAllUserByLimitAndOffset(int limit, int offset,String isAdmin) {
		List<User> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_ALL_USER_LIMIT_OFFSET);
			pst.setString(1, isAdmin);
			pst.setInt(2, limit);
			pst.setInt(3, offset);
			ResultSet rst = pst.executeQuery();
			while(rst.next()) {
				User user = new User();
				user.setId(rst.getInt("id"));
				user.setEmail(rst.getString("email"));
				user.setGender(rst.getString("gender"));
				user.setIsAdmin(rst.getString("isadmin"));
				user.setMobile(rst.getString("mobile"));
				user.setName(rst.getString("name"));
				user.setPassword(rst.getString("password"));
				user.setCompanyId(rst.getInt("companyid"));
				list.add(user);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public int getUserCount(String isadmin) {
		int count = 0;
		try {
			pst = con.prepareStatement(TOTAL_COUNT);
			pst.setString(1, isadmin);
			ResultSet rst = pst.executeQuery();
			if (rst.next()) {
				count = rst.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}
	
	/* *************************************************
	 * ****** GET COMPANY BY COMPANY_ID AND EMAIL ******
	 * *************************************************
	 */
	
	
	public User getUserByMobile(String mobile) {
		User user = null;
		try {
			pst = con.prepareStatement(GET_USER_BY_MOBILE);
			pst.setString(1, mobile);
			ResultSet rst = pst.executeQuery();
			user = new User();
			while(rst.next()) {
				user.setId(rst.getInt("id"));
				user.setEmail(rst.getString("email"));
				user.setGender(rst.getString("gender"));
				user.setIsAdmin(rst.getString("isadmin"));
				user.setMobile(rst.getString("mobile"));
				user.setName(rst.getString("name"));
				user.setPassword(rst.getString("password"));
				user.setCompanyId(rst.getInt("companyid"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}
	

	
	/* *************************************************************
	 * ****** GET EMPLOYEE COUNT USING USER ID FOR ADMIN(COMPANY) **
	 * *************************************************************
	 * */
	public int getUserCountUsingIsAdmin(String isAdmin) {
		int count = 0;
		try {
			pst = con.prepareStatement(TOTAL_COUNT);
			pst.setString(1, isAdmin);
			ResultSet rst = pst.executeQuery();
			if (rst.next()) {
				count = rst.getInt(1);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return count;
	}
}
