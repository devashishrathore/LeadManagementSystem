package in.pandit.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import in.pandit.model.User;
import in.pandit.persistance.DatabaseConnection;

public class UserDao {
	private static final String GET_USER_BY_EMAIL_COMPANY_ID = "SELECT * FROM users WHERE email=? AND companyid=?";
	private static final String GET_USER_BY_EMAIL = "SELECT * FROM users WHERE email=?";
	private static final String GET_EMAIL_BY_ISADMIN_AND_COMPAN_ID = "SELECT email FROM users WHERE (isadmin=? OR isadmin=?) AND companyid=?";
	private static final String GET_EMAIL_BY_ISADMIN = "SELECT email FROM users WHERE isadmin=? OR isadmin=?";
	private static final String GET_ALL_USER_LIMIT_OFFSET_ADN_COMPANY_ID = "SELECT * FROM users WHERE isadmin=? AND companyid=? ORDER BY id DESC LIMIT ? OFFSET ? ";
	private static final String GET_ALL_USER_LIMIT_OFFSET = "SELECT * FROM users WHERE isadmin=? ORDER BY id DESC LIMIT ? OFFSET ? ";
	
	private static final String GET_USER_BY_MOBILE_AND_COMPANY_ID = "SELECT * FROM users WHERE mobile=? AND companyid=?";
	private static final String GET_USER_BY_MOBILE = "SELECT * FROM users WHERE mobile=?";
	private static final String GET_NAME_BY_EMAIL_AND_COMPANY_ID = "SELECT name FROM users WHERE email=? AND companyid=?";
	private static final String GET_NAME_BY_EMAIL = "SELECT name FROM users WHERE email=? ";
	private static final String UPDATE_USER_INFORMATION = "UPDATE users SET name=?,email=?,gender=?,mobile=? WHERE id=?";
	private static final String CHANGE_USER_PASSWORD = "UPDATE users SET password=? WHERE id=?";
	private static final String UPDATE_USER_EMAIL = "UPDATE users SET email=? WHERE email=?";
	private static final String ADD_USER_INFORMATION = "INSERT INTO users(email,gender,isadmin,mobile,name,password,companyid) VALUES(?,?,?,?,?,?,?)";
	public static final String TOTAL_COUNT_USING_COMPANY_ID = "SELECT COUNT(id) FROM users WHERE isadmin=? AND companyid=?";
	public static final String TOTAL_COUNT = "SELECT COUNT(id) FROM users WHERE isadmin=?";
	public static final String LOGIN_USER = "SELECT * FROM users WHERE email=? AND password=?";
	public static final String DELETE_USER = "DELETE FROM users WHERE id=?";
	public static final String DELETE_USER_BY_COMPANY_ID = "DELETE FROM users WHERE companyid=?";
	
	private static PreparedStatement pst = null;
	private static Connection con = DatabaseConnection.getConnection();
	
	public User getUserByEmail(String email, int companyId) {
		User user = new User();
		try {
			pst = con.prepareStatement(GET_USER_BY_EMAIL_COMPANY_ID);
			pst.setString(1, email);
			pst.setInt(2, companyId);
			ResultSet rst = pst.executeQuery();
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
	public User getUserByEmail(String email) {
		User user = new User();
		try {
			pst = con.prepareStatement(GET_USER_BY_EMAIL);
			pst.setString(1, email);
			ResultSet rst = pst.executeQuery();
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
	public List<User> getAllUserByLimitAndOffsetCompany(int limit, int offset,String isAdmin, int companyId) {
		List<User> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_ALL_USER_LIMIT_OFFSET_ADN_COMPANY_ID);
			pst.setString(1, isAdmin);
			pst.setInt(2, companyId);
			pst.setInt(3, limit);
			pst.setInt(4, offset);
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
	public  List<String> getAllEmailByIsAdminAndCompanyId(String isUser, String isAdmin , int companyId) {
		List<String> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_EMAIL_BY_ISADMIN_AND_COMPAN_ID);
			pst.setString(1, isUser);
			pst.setString(2, isAdmin);
			pst.setInt(3, companyId);
			ResultSet rst = pst.executeQuery();
			while(rst.next()) {
				list.add(rst.getString(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public List<String> getAllEmailByIsAdmin(String isUser, String isAdmin) {
		List<String> list = new ArrayList<>();
		try {
			pst = con.prepareStatement(GET_EMAIL_BY_ISADMIN);
			pst.setString(1, isUser);
			pst.setString(2, isAdmin);
			ResultSet rst = pst.executeQuery();
			while(rst.next()) {
				list.add(rst.getString(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public  int getUserCount(String isadmin, int companyId) {
		int count = 0;
		try {
			pst = con.prepareStatement(TOTAL_COUNT_USING_COMPANY_ID);
			pst.setString(1, isadmin);
			pst.setInt(2, companyId);
			ResultSet rst = pst.executeQuery();
			if (rst.next()) {
				count = rst.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}
	public  int getUserCount(String isadmin) {
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
	
	public  User loginUser(String email,String password) {
		User user = null;
		try {
			pst = con.prepareStatement(LOGIN_USER);
			pst.setString(1, email);
			pst.setString(2, password);
			ResultSet rst = pst.executeQuery();
			while(rst.next()) {
				user = new User();
				user.setName(rst.getString("name"));
				user.setEmail(rst.getString("email"));
				user.setId(rst.getInt("id"));
				user.setIsAdmin(rst.getString("isadmin"));
				user.setPassword(rst.getString("password"));
				user.setGender(rst.getString("gender"));
				user.setMobile(rst.getString("mobile"));
				user.setCompanyId(rst.getInt("companyid"));
			}
			return user;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}
	public  User getUserByMobile(String mobile, int companyId) {
		User user = new User();
		try {
			pst = con.prepareStatement(GET_USER_BY_MOBILE_AND_COMPANY_ID);
			pst.setString(1, mobile);
			pst.setInt(2, companyId);
			ResultSet rst = pst.executeQuery();
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
	
	public  User getUserByMobile(String mobile) {
		User user = new User();
		try {
			pst = con.prepareStatement(GET_USER_BY_MOBILE);
			pst.setString(1, mobile);
			ResultSet rst = pst.executeQuery();
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
	
	public  String getUserNameByEmail(String email) {
		try {
			pst = con.prepareStatement(GET_NAME_BY_EMAIL);
			pst.setString(1, email);
			ResultSet rst = pst.executeQuery();
			while(rst.next()) {
				return rst.getString("name");
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		return "";
	}
	
	public static String getUserNameByEmail(String email,int companyId) {
		try {
			pst = con.prepareStatement(GET_NAME_BY_EMAIL_AND_COMPANY_ID);
			pst.setString(1, email);
			pst.setInt(2, companyId);
			ResultSet rst = pst.executeQuery();
			while(rst.next()) {
				return rst.getString("name");
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		return "";
	}
	public  boolean updateUserInformation(User user) {
		try {
			pst = con.prepareStatement(UPDATE_USER_INFORMATION);
			pst.setString(1, user.getName());
			pst.setString(2, user.getEmail());
			pst.setString(3, user.getGender());
			pst.setString(4, user.getMobile());
			pst.setInt(5, user.getId());
			pst.executeUpdate();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	public  boolean changeUserPassword(User user, String password) {
		try {
			pst = con.prepareStatement(CHANGE_USER_PASSWORD);
			pst.setString(1, password);
			pst.setInt(2, user.getId());
			pst.executeUpdate();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	public  boolean updateUserEmail(String updateEmail,String currentEmail) {
		try {
			pst = con.prepareStatement(UPDATE_USER_EMAIL);
			pst.setString(1, updateEmail);
			pst.setString(2, currentEmail);
			pst.executeUpdate();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	public  boolean addUser(User user) {
		try {
			pst = con.prepareStatement(ADD_USER_INFORMATION);
			pst.setString(1, user.getEmail());
			pst.setString(2, user.getGender());
			pst.setString(3, user.getIsAdmin());
			pst.setString(4, user.getMobile());
			pst.setString(5, user.getName());
			pst.setString(6, user.getPassword());
			pst.setInt(7, user.getCompanyId());
			pst.executeUpdate();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	/* *************************************************************
	 * ****** GET EMPLOYEE COUNT USING USER ID FOR ADMIN(COMPANY) **
	 * *************************************************************
	 * */
	public  int getUserCountUsingIsAdmin(String isAdmin, int companyId) {
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
	public  List<User> getAllUserByLimitAndOffset(int limit, int offset,String isAdmin) {
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
	
	
	
//	delete user by company id
	public boolean deleteUserByCompanyId(int companyId) {
		try {
			pst = con.prepareStatement(DELETE_USER_BY_COMPANY_ID);
			pst.setInt(1, companyId);
			pst.executeUpdate();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
//	delete user by company id
	public boolean deleteUserByUserId(int userId) {
		try {
			pst = con.prepareStatement(DELETE_USER);
			pst.setInt(1, userId);
			pst.executeUpdate();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
}
