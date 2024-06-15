package in.pandit.model;

public class User {
	private int id;
	private String name;
	private String email;
	private String gender;
	private String mobile;
	private String isAdmin;
	private String password;
	private int companyId;
	private byte[] image ;
	
	public User() {
		
	}
	public User(int id, String name, String email, String gender, String mobile, String isAdmin,
			String password, byte[] image, int companyId) {
		super();
		this.id = id;
		this.name = name;
		this.email = email;
		this.gender = gender;
		this.mobile = mobile;
		this.isAdmin = isAdmin;
		this.password = password;
		this.image = image;
		this.setCompanyId(companyId); 
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getIsAdmin() {
		return isAdmin;
	}
	public void setIsAdmin(String isAdmin) {
		this.isAdmin = isAdmin;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public byte[] getImage() {
		return image;
	}
	public void setImage(byte[] image) {
		this.image = image;
	}
	public int getCompanyId() {
		return companyId;
	}
	public void setCompanyId(int companyId) {
		this.companyId = companyId;
	}
	
}
