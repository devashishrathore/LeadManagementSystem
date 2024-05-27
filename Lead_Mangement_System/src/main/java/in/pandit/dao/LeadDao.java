package in.pandit.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import in.pandit.model.Lead;
import in.pandit.persistance.DatabaseConnection;

public class LeadDao {
	private static final String GET_LEAD_BY_ID = "SELECT * FROM leads WHERE id=?";
	private static final String GET_LEAD_BY_EMAIL = "SELECT * FROM leads WHERE email=? AND companyid=?";
	private static final String GET_LEAD_BY_MOBILE = "SELECT * FROM leads WHERE mobile=? AND companyid=?" ;
	private static final String GET_ALL_LEAD_BY_CURRENT_OWNER = "SELECT * FROM leads WHERE currentowner=? AND companyid=?";
	private static final String GET_ALL_LEAD_BY_OWNER = "SELECT * FROM leads WHERE owner=? AND companyid=?";
	private static final String DETETE_LEAD_BY_LEAD_ID="DELETE FROM leads WHERE id=?";
	private static final String TOTAL_LEADS_COUNT_OF_USER_USING_ID_AND_STATUS = "SELECT COUNT(id) FROM leads WHERE status=? AND companyid=?";
	private static final String TOTAL_LEADS_USING_COMPANY_ID = "SELECT COUNT(id) FROM leads WHERE companyid=?";
	private static final String TOTAL_LEADS = "SELECT COUNT(id) FROM leads";
	private static final String TOTAL_LEADS_COUNT_SOURCE = "SELECT COUNT(id) FROM leads WHERE source=?  AND companyid=?";
	private static final String TOTAL_LEADS_COUNT_SOURCE_FACEBOOK_OR_GOOGLE = "SELECT COUNT(id) FROM leads WHERE (source=? OR source=?) AND companyid=?";
	private static final String TOTAL_LEADS_COUNT_NEW_LEADS = "SELECT COUNT(id) FROM leads WHERE creation_date::date = CURRENT_DATE  AND companyid=?";
	
	private static final String GET_ALL_LEADS_BY_OFFSET_AND_LIMIT = "SELECT * FROM leads  WHERE companyid=? ORDER BY id DESC LIMIT ? OFFSET ? ";
	private static final String GET_LEADS_BY_OFFSET_AND_LIMIT = "SELECT * FROM leads ORDER BY id DESC LIMIT ? OFFSET ? ";
	private static final String GET_ALL_LEADS_BY_OFFSET_AND_LIMIT_AND_OWNER_AND_COMPAN_ID = "SELECT * FROM leads  WHERE companyid=? AND owner=? ORDER BY id DESC LIMIT ? OFFSET ? ";
	private static final String GET_ALL_LEADS_BY_OFFSET_AND_LIMIT_AND_CURRENT_OWNER_AND_COMPAN_ID = "SELECT * FROM leads  WHERE companyid=? AND currentowner=? ORDER BY id DESC LIMIT ? OFFSET ? ";
	private static final String GET_ALL_LEADS_BY_OFFSET_AND_LIMIT_AND_CURRENTOWNER = "SELECT * FROM leads WHERE currentowner=? AND companyid = ? ORDER BY id DESC LIMIT ? OFFSET ? ";
	
	
	private static final String INSERT_LEAD = "INSERT INTO leads(name,email,address,mobile,source,owner,currentowner,status,companyid,education,salary,experience) VALUES(?, ?, ?, ?, ?, ?, ?, ?,?,?, ?,?)";
	private static final String UPDATE_LEAD = "UPDATE leads SET name = ?, email = ?, address = ?, mobile = ?, source = ? , owner = ?, currentOwner = ?, status = ?,education = ?,salary = ?,experience = ? WHERE id=?";
	
	private static final String UPDATE_LEAD_CURRENT_OWNER_EMAIL_BY_CURRENT_OWNER_EMAIL = "UPDATE leads SET currentowner = ? WHERE currentowner = ?";
	private static final String UPDATE_LEAD_OWNER_EMAIL_BY_OWNER_EMAIL = "UPDATE leads SET owner = ? WHERE owner = ?";
	
	private static final String DETETE_LEAD_BY_COMPANY_ID="DELETE FROM leads WHERE companyid=?";
	
	private static Connection con = DatabaseConnection.getConnection();
	private static PreparedStatement pst = null;
	
	CommentDao commentDao = new CommentDao();
	
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
			pst.setString(10, lead.getEducation());
			pst.setInt(11, lead.getSalary());
			pst.setString(12, lead.getExperience());
			done = pst.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return done;
	}
	public int updateLead(Lead lead) {
		int done = 0;
		try {
			pst = con.prepareStatement(UPDATE_LEAD);
			pst.setString(1, lead.getName());
			pst.setString(2, lead.getEmail());
			pst.setString(3, lead.getAddress());
			pst.setString(4, lead.getMobile());
			pst.setString(5, lead.getSource());
			pst.setString(6, lead.getOwner());
			pst.setString(7, lead.getCurrentowner());
			pst.setString(8, lead.getStatus());
			pst.setString(9, lead.getEducation());
			pst.setInt(10, lead.getSalary());
			pst.setString(11, lead.getExperience());
			pst.setInt(12, lead.getId());
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
				lead.setEducation(rst.getString("education"));
				lead.setExperience(rst.getString("experience"));;
				lead.setSalary(rst.getInt("salary"));;
				return lead;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return lead;
	}
	public Lead getLeadByEmail(String leadEmail, int companyId) {
		Lead lead = null;
		try {
			pst = con.prepareStatement(GET_LEAD_BY_EMAIL);
			pst.setString(1, leadEmail);
			pst.setInt(2, companyId);
			ResultSet rst=  pst.executeQuery();
			lead = new Lead();
			while(rst.next()) {
				lead.setAddress(rst.getString("address"));
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
				lead.setEducation(rst.getString("education"));
				lead.setExperience(rst.getString("experience"));;
				lead.setSalary(rst.getInt("salary"));;
				return lead;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return lead;
	}
	
	public Lead getLeadByMobile(String mobile, int companyId) {
		Lead lead = null;
		try {
			pst = con.prepareStatement(GET_LEAD_BY_MOBILE);
			pst.setString(1, mobile);
			pst.setInt(2, companyId);
			ResultSet rst=  pst.executeQuery();
			lead = new Lead();
			while(rst.next()) {
				lead.setAddress(rst.getString("address"));
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
				lead.setEducation(rst.getString("education"));
				lead.setExperience(rst.getString("experience"));;
				lead.setSalary(rst.getInt("salary"));;
				return lead;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return lead;
	}
	
	public List<Lead> getAllLeadByCurrentOwner(String currentOwner, int companyId) {
		List<Lead> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_ALL_LEAD_BY_CURRENT_OWNER);
			pst.setString(1, currentOwner);
			pst.setInt(2, companyId);
			ResultSet rst=  pst.executeQuery();
			while(rst.next()) {
				Lead lead = new Lead();
				lead.setAddress(rst.getString("address"));
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
				lead.setEducation(rst.getString("education"));
				lead.setExperience(rst.getString("experience"));;
				lead.setSalary(rst.getInt("salary"));;
				list.add(lead);
				return list;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public List<Lead> getAllLeadByOwner(String Owner, int companyId) {
		List<Lead> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_ALL_LEAD_BY_OWNER);
			pst.setString(1, Owner);
			pst.setInt(2, companyId);
			ResultSet rst=  pst.executeQuery();
			while(rst.next()) {
				Lead lead = new Lead();
				lead.setAddress(rst.getString("address"));
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
				lead.setEducation(rst.getString("education"));
				lead.setExperience(rst.getString("experience"));;
				lead.setSalary(rst.getInt("salary"));;
				list.add(lead);
				return list;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	
	public int deleteLeadByLeadId(int leadid) {
		int done = 0;
		try {
			int a = commentDao.deleteCommentByLeadId(leadid);
			pst =con.prepareStatement(DETETE_LEAD_BY_LEAD_ID);
			pst.setInt(1, leadid);
			done = pst.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return done;
	}
	public int deleteLeadByCompanyId(int companyId) {
		int done = 0;
		try {
			int a = commentDao.deleteCommentByCompanyId(companyId);
			pst =con.prepareStatement(DETETE_LEAD_BY_COMPANY_ID);
			pst.setInt(1, companyId);
			done = pst.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return done;
	}
	public int deleteLeadByUserId(int companyId) {
		int done = 0;
		try {
			int a = commentDao.deleteCommentByCompanyId(companyId);
			pst =con.prepareStatement(DETETE_LEAD_BY_COMPANY_ID);
			pst.setInt(1, companyId);
			done = pst.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return done;
	}
	
	/* ****************************
	 * ****** GET LEAD COUNT ******
	 * ****************************
	 * */
	public int getTotalLeadsCountByCompanyId(int companyId) {
		int count = 0;
		try {
			pst = con.prepareStatement(TOTAL_LEADS_USING_COMPANY_ID);
			pst.setInt(1, companyId);
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
	/* ****************************
	 * ****** GET LEAD COUNT ******
	 * ****************************
	 * */
//	BY ADDRESS, NAME , EMAIL , MOBILE , ID ,STATUS , OWNER
	
	public int getLeadsCountByCompanyId(String query, String countBy, int companyId) {
		int count = 0;
		try {
			pst = con.prepareStatement(query);
			pst.setString(1, countBy);
			pst.setInt(2, companyId);
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
	public int getLeadsCountUsingCompanyIdAndStatus(int companyId, String status) {
		int count = 0;
		try {
			pst = con.prepareStatement(TOTAL_LEADS_COUNT_OF_USER_USING_ID_AND_STATUS);
			pst.setString(1, status);
			pst.setInt(2, companyId);
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
	public int getLeadsCountUsingSourceAndCompany(String source, int companyId) {
		int count = 0;
		try {
			pst = con.prepareStatement(TOTAL_LEADS_COUNT_SOURCE);
			pst.setString(1, source);
			pst.setInt(2, companyId);
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
	public int getLeadsCountUsingSourceFacebookOrGoogleAndCompanyId(int companyId) {
		int count = 0;
		try {
			pst = con.prepareStatement(TOTAL_LEADS_COUNT_SOURCE_FACEBOOK_OR_GOOGLE);
			pst.setString(1, "facebook");
			pst.setString(2, "google");
			pst.setInt(3, companyId);
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
	public int getLeadsCountNewLeadsByCompanyId(int companyId) {
		int count = 0;
		try {
			pst = con.prepareStatement(TOTAL_LEADS_COUNT_NEW_LEADS);
			pst.setInt(1, companyId);
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
	public List<Lead> getAllLeadsByLimitOffsetAndCompany(int limit, int offset, int companyId) {
		List<Lead> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_ALL_LEADS_BY_OFFSET_AND_LIMIT);
			pst.setInt(1, companyId);
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
				lead.setEducation(rst.getString("education"));
				lead.setExperience(rst.getString("experience"));;
				lead.setSalary(rst.getInt("salary"));;
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
	public List<Lead> getAllLeadsByLimitOffsetAndCompanyAndOwner(int limit, int offset, int companyId,String owner) {
		List<Lead> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_ALL_LEADS_BY_OFFSET_AND_LIMIT_AND_OWNER_AND_COMPAN_ID);
			pst.setInt(1, companyId);
			pst.setString(2, owner);
			pst.setInt(3, limit);
			pst.setInt(4, offset);
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
				lead.setEducation(rst.getString("education"));
				lead.setExperience(rst.getString("experience"));;
				lead.setSalary(rst.getInt("salary"));;
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
	public List<Lead> getAllLeadsByLimitOffsetAndCompanyAndCurrentOwner(int limit, int offset, int companyId,String currentOwner) {
		List<Lead> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_ALL_LEADS_BY_OFFSET_AND_LIMIT_AND_CURRENT_OWNER_AND_COMPAN_ID);
			pst.setInt(1, companyId);
			pst.setString(2, currentOwner);
			pst.setInt(3, limit);
			pst.setInt(4, offset);
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
				lead.setEducation(rst.getString("education"));
				lead.setExperience(rst.getString("experience"));;
				lead.setSalary(rst.getInt("salary"));;
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
	public List<Lead> getAllLeadsByLimitCurrentOwnerAndCompany(int limit, int offset,String currentOwner, int companyId) {
		List<Lead> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_ALL_LEADS_BY_OFFSET_AND_LIMIT_AND_CURRENTOWNER);
			pst.setString(1, currentOwner);
			pst.setInt(2, companyId);
			pst.setInt(3, limit);
			pst.setInt(4, offset);
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
				lead.setEducation(rst.getString("education"));
				lead.setExperience(rst.getString("experience"));;
				lead.setSalary(rst.getInt("salary"));;
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
	public static final String SEARCH_LEADS_BY_ID_OFFSET_AND_LIMIT = "SELECT * FROM leads WHERE companyid=? AND id=? ORDER BY id DESC LIMIT ? OFFSET ? ";
	public static final String SEARCH_LEADS_BY_EMAIL_OFFSET_AND_LIMIT = "SELECT * FROM leads WHERE companyid=? AND email ILIKE ? ORDER BY id DESC LIMIT ? OFFSET ? ";
	public static final String SEARCH_LEADS_BY_ADDRESS_OFFSET_AND_LIMIT = "SELECT * FROM leads WHERE companyid=? AND address ILIKE ? ORDER BY id DESC LIMIT ? OFFSET ? ";
	public static final String SEARCH_LEADS_BY_MOBILE_OFFSET_AND_LIMIT = "SELECT * FROM leads WHERE companyid=? AND mobile ILIKE ? ORDER BY id DESC LIMIT ? OFFSET ? ";
	public static final String SEARCH_LEADS_BY_STATUS_OFFSET_AND_LIMIT = "SELECT * FROM leads WHERE companyid=? AND status ILIKE ? ORDER BY id DESC LIMIT ? OFFSET ? ";
	public static final String SEARCH_LEADS_BY_CURRENT_OWNER_OFFSET_AND_LIMIT = "SELECT * FROM leads WHERE companyid=? AND currentowner ILIKE ? ORDER BY id DESC LIMIT ? OFFSET ? ";
	public static final String SEARCH_LEADS_BY_OWNER_OFFSET_AND_LIMIT = "SELECT * FROM leads WHERE companyid=? AND owner ILIKE ? ORDER BY id DESC LIMIT ? OFFSET ? ";
	public static final String SEARCH_LEADS_BY_NAME_OFFSET_AND_LIMIT = "SELECT * FROM leads WHERE companyid=? AND name ILIKE ? ORDER BY id DESC LIMIT ? OFFSET ? ";
	
	
	public List<Lead> searchLead(String searchBy, String search, int limit, int offset, int companyId){
		LeadDao leadDao = new LeadDao();
		List<Lead> list = new ArrayList<>();
		if(searchBy.equals("id")){
			try{
				int id = Integer.parseInt(search);
				pst = con.prepareStatement(SEARCH_LEADS_BY_ID_OFFSET_AND_LIMIT);
				pst.setInt(1, companyId);
				pst.setInt(2, id);
				pst.setInt(3, limit);
				pst.setInt(4, offset);
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
					lead.setEducation(rst.getString("education"));
					lead.setExperience(rst.getString("experience"));;
					lead.setSalary(rst.getInt("salary"));;
					list.add(lead);
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(searchBy.equals("email")){
			list = leadDao.search(SEARCH_LEADS_BY_EMAIL_OFFSET_AND_LIMIT, search, limit, offset, companyId);
		}else if(searchBy.equals("address")){
			list = leadDao.search(SEARCH_LEADS_BY_ADDRESS_OFFSET_AND_LIMIT, search, limit, offset, companyId);
		}else if(searchBy.equals("name")){
			list = leadDao.search(SEARCH_LEADS_BY_NAME_OFFSET_AND_LIMIT, search, limit, offset, companyId);
		}else if(searchBy.equals("mobile")){
			list = leadDao.search(SEARCH_LEADS_BY_MOBILE_OFFSET_AND_LIMIT, search, limit, offset, companyId);
		}else if(searchBy.equals("owner")){
			list = leadDao.search(SEARCH_LEADS_BY_OWNER_OFFSET_AND_LIMIT, search, limit, offset, companyId);
		}else if(searchBy.equals("status")){
			list = leadDao.search(SEARCH_LEADS_BY_STATUS_OFFSET_AND_LIMIT, search, limit, offset, companyId);
		}else if(searchBy.equals("currentowner")){
			list = leadDao.search(SEARCH_LEADS_BY_CURRENT_OWNER_OFFSET_AND_LIMIT, search, limit, offset, companyId);
		}
		return list;
	}
	public List<Lead> search(String query , String search,int limit, int offset, int companyId){
		List<Lead> list = new ArrayList<>();
		try{
			pst = con.prepareStatement(query);
			pst.setInt(1, companyId);
			pst.setString(2, "%"+search+"%");
			pst.setInt(3, limit);
			pst.setInt(4, offset);
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
				lead.setEducation(rst.getString("education"));
				lead.setExperience(rst.getString("experience"));;
				lead.setSalary(rst.getInt("salary"));;
				
				list.add(lead);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return list;
	}
	
	
	public boolean validateEmailByCompanyId(String email, int companyId) {
		LeadDao leadDao = new LeadDao();
		try {
			Lead lead = leadDao.getLeadByEmail(email,companyId);
			if(lead.getName() == null) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return false;
	}
	
	public boolean validateMobileByCompanyId(String mobile, int companyId) {
		LeadDao leadDao = new LeadDao();
		try {
			Lead lead = leadDao.getLeadByMobile(mobile,companyId);
			if(lead.getName() == null) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return false;
	}
	
	
	public int updateCurrentOwnerEmail(String updateEmail,String currentEmail) {
		int updateCurrentOwner = 0;
		try {
			pst = con.prepareStatement(UPDATE_LEAD_CURRENT_OWNER_EMAIL_BY_CURRENT_OWNER_EMAIL);
			pst.setString(1, updateEmail);
			pst.setString(2,currentEmail);
			updateCurrentOwner = pst.executeUpdate();
			return updateCurrentOwner;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return updateCurrentOwner;
	}
	public int updateOwnerEmail(String updateEmail,String currentEmail) {
		int updateOwner = 0;
		try {
			pst = con.prepareStatement(UPDATE_LEAD_OWNER_EMAIL_BY_OWNER_EMAIL);
			pst.setString(1, updateEmail);
			pst.setString(2, currentEmail);
			updateOwner = pst.executeUpdate();
			return updateOwner;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return updateOwner;
	}
	
	/* ***********************************************
	 * ****** GET ALL LEADS BY LIMIT AND OFFSET ******
	 * ***********************************************
	 * */
	public List<Lead> getAllLeadsByLimit(int limit, int offset) {
		List<Lead> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_LEADS_BY_OFFSET_AND_LIMIT);
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
				lead.setCreationDate(rst.getTimestamp("creation_date"));
				lead.setMobile(rst.getString("mobile"));
				lead.setOwner(rst.getString("owner"));
				lead.setSource(rst.getString("source"));
				lead.setStatus(rst.getString("status"));
				lead.setEducation(rst.getString("education"));
				lead.setExperience(rst.getString("experience"));;
				lead.setSalary(rst.getInt("salary"));;
				list.add(lead);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
}
