package in.pandit.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import in.pandit.model.Company;
import in.pandit.persistance.DatabaseConnection;

public class CompanyDao {

	private static final String GET_COMPANY_BY_COMPANYNAME = "SELECT * FROM company WHERE companyname = ?";
	private static final String GET_ALL_COMPANY_LIMIT_OFFSET = "SELECT * FROM company ORDER BY id DESC LIMIT ? OFFSET ? ";
	private static final String INSERT_COMPANY = "INSERT INTO company(companyname,companyaddress,managername,manageremail,managercontact) VALUES(?,?,?,?,?)";
	private static final String GET_COMPANY_BY_MANAGER_CONTACT = "SELECT * FROM company WHERE managercontact=?";
	private static final String GET_COMPANY_BY_MANAGER_EMAIL = "SELECT * FROM company WHERE manageremail=?";
	private static final String GET_COMPANY_BY_COMPANY_ID = "SELECT * FROM company WHERE companyid=?";
	private static final String GET_COMPANY = "SELECT * FROM company ORDER BY companyid DESC";
	private static final String GET_COMPANY_NAME = "SELECT companyname FROM company";
	private static final String GET_COMPANY_ID = "SELECT companyid FROM company";
	private static final String GET_COMPANY_ID_AND_NAME = "SELECT companyid,companyname FROM company";
	public static final String TOTAL_COMPANY_COUNT = "SELECT COUNT(companyid) FROM company";
	private static final String GET_COMPANY_BY_LIMIN_AND_OFFSET = "SELECT * FROM company ORDER BY companyid DESC LIMIT ? OFFSET ? ";
	private static final String UPDATE_COMPANY = "UPDATE company SET companyname=? ,companyaddress=?,managername=?, managercontact=?, manageremail=? WHERE companyid=?";
	private static final String DELETE_COMPANY = "DELETE FROM company WHERE companyid=?";
	
	
	private static PreparedStatement pst = null;
	private static Connection con = DatabaseConnection.getConnection();
	
	public Company getCompanyByName(String companyName) {
		Company company = null;
		try {
			pst = con.prepareStatement(GET_COMPANY_BY_COMPANYNAME);
			pst.setString(1, companyName);
			ResultSet rst = pst.executeQuery();
			company = new Company();
			while(rst.next()) {
				company.setCompanyAddress(rst.getString("companyaddress"));
				company.setManagerContact(rst.getString("managername"));
				company.setManagerEmail(rst.getString("manageremail"));
				company.setManagerContact(rst.getString("managercontact"));
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
		return company;
	}
	
	public int insertCompany(Company company) {
		int done = 0;
		try {
			pst = con.prepareStatement(INSERT_COMPANY);
			pst.setString(1, company.getCompanyName());
			pst.setString(2, company.getCompanyAddress());
			pst.setString(3, company.getManagerName());
			pst.setString(4,company.getManagerEmail());
			pst.setString(5, company.getManagerContact());
			done = pst.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return done;
	}
	
	public int updateCompany(Company company) {
		int done = 0;
		try {
			pst = con.prepareStatement(UPDATE_COMPANY);
			pst.setString(1, company.getCompanyName());
			pst.setString(2, company.getCompanyAddress());
			pst.setString(3, company.getManagerName());
			pst.setString(4, company.getManagerContact());
			pst.setString(5,company.getManagerEmail());
			pst.setInt(6, company.getCompanyId());
			done = pst.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return done;
	}
	public int deleteCompany(int companyId) {
		int done = 0;
		try {
			pst = con.prepareStatement(DELETE_COMPANY);
			pst.setInt(1, companyId);
			done = pst.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return done;
	}
	
	
	
	public Company getCompanyByMobile(String managerContact) {
		Company company = null;
		try {
			pst = con.prepareStatement(GET_COMPANY_BY_MANAGER_CONTACT);
			pst.setString(1, managerContact);
			ResultSet rst = pst.executeQuery();
			company = new Company();
			while(rst.next()) {
				company.setCompanyId(rst.getInt("companyid"));
				company.setCompanyAddress(rst.getString("companyaddress"));
				company.setCompanyName(rst.getString("companyname"));
				company.setManagerContact(rst.getString("managercontact"));
				company.setManagerEmail(rst.getString("manageremail"));
				company.setManagerName(rst.getString("managername"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return company;
	}
	public Company getCompanyByEmail(String managerEmail) {
		Company company = null;
		try {
			pst = con.prepareStatement(GET_COMPANY_BY_MANAGER_EMAIL);
			pst.setString(1, managerEmail);
			ResultSet rst = pst.executeQuery();
			company = new Company();
			while(rst.next()) {
				company.setCompanyId(rst.getInt("companyid"));
				company.setCompanyAddress(rst.getString("companyaddress"));
				company.setCompanyName(rst.getString("companyname"));
				company.setManagerContact(rst.getString("managercontact"));
				company.setManagerEmail(rst.getString("manageremail"));
				company.setManagerName(rst.getString("managername"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return company;
	}
	public Company getCompanyById(int id) {
		Company company = null;
		try {
			pst = con.prepareStatement(GET_COMPANY_BY_COMPANY_ID);
			pst.setInt(1, id);
			ResultSet rst = pst.executeQuery();
			company = new Company();
			while(rst.next()) {
				company.setCompanyId(rst.getInt("companyid"));
				company.setCompanyAddress(rst.getString("companyaddress"));
				company.setCompanyName(rst.getString("companyname"));
				company.setManagerContact(rst.getString("managercontact"));
				company.setManagerEmail(rst.getString("manageremail"));
				company.setManagerName(rst.getString("managername"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return company;
	}
	public List<Company> getAllCompany(int limit, int offset) {
		List<Company> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_COMPANY_BY_LIMIN_AND_OFFSET);
			pst.setInt(1, limit);
			pst.setInt(2, offset);

			ResultSet rst = pst.executeQuery();
			while(rst.next()) {
				Company company = new Company();
				company.setCompanyId(rst.getInt("companyid"));
				company.setCompanyAddress(rst.getString("companyaddress"));
				company.setCompanyName(rst.getString("companyname"));
				company.setManagerContact(rst.getString("managercontact"));
				company.setManagerEmail(rst.getString("manageremail"));
				company.setManagerName(rst.getString("managername"));
				list.add(company);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public List<Company> getAllCompany() {
		List<Company> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_COMPANY);
			ResultSet rst = pst.executeQuery();
			while(rst.next()) {
				Company company = new Company();
				company.setCompanyId(rst.getInt("companyid"));
				company.setCompanyAddress(rst.getString("companyaddress"));
				company.setCompanyName(rst.getString("companyname"));
				company.setManagerContact(rst.getString("managercontact"));
				company.setManagerEmail(rst.getString("manageremail"));
				company.setManagerName(rst.getString("managername"));
				list.add(company);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public List<String> getAllCompanyName() {
		List<String> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_COMPANY_NAME);
			ResultSet rst = pst.executeQuery();
			while(rst.next()) {
				list.add(rst.getString(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public List<Integer> getAllCompanyId() {
		List<Integer> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_COMPANY_ID);
			ResultSet rst = pst.executeQuery();
			while(rst.next()) {
				list.add(rst.getInt(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public List<Company> getAllCompanyIdAndName() {
		List<Company> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_COMPANY_ID_AND_NAME);
			ResultSet rst = pst.executeQuery();
			while(rst.next()) {
				Company company = new Company();
				company.setCompanyId(rst.getInt("companyid"));
				company.setCompanyName(rst.getString("companyname"));
				list.add(company);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	/* *************************************************************
	 * ****** GET EMPLOYEE COUNT USING USER ID FOR ADMIN(COMPANY) **
	 * *************************************************************
	 * */
	public int getAllCompanyCount() {
		int count = 0;
		try {
			pst = con.prepareStatement(TOTAL_COMPANY_COUNT);
			ResultSet rst = pst.executeQuery();
			if (rst.next()) {
				count = rst.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}
	
}
