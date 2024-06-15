package in.pandit.model;

import java.sql.Timestamp;

public class Comment {
	private int id;
	private int leadid;
	private int userid;
	private int companyId;
	private String useremail;
	private String comment;
	private Timestamp creationDate;
	private Timestamp updationDate;
	public Comment() {
		super();
		// TODO Auto-generated constructor stub
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getLeadid() {
		return leadid;
	}
	public void setLeadid(int leadid) {
		this.leadid = leadid;
	}
	public int getUserid() {
		return userid;
	}
	public void setUserid(int userid) {
		this.userid = userid;
	}
	public String getUseremail() {
		return useremail;
	}
	public void setUseremail(String useremail) {
		this.useremail = useremail;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public Timestamp getCreationDate() {
		return creationDate;
	}
	public void setCreationDate(Timestamp creationDate) {
		this.creationDate = creationDate;
	}
	public Timestamp getUpdationDate() {
		return updationDate;
	}
	public void setUpdationDate(Timestamp updationDate) {
		this.updationDate = updationDate;
	}
	public int getCompanyId() {
		return companyId;
	}
	public void setCompanyId(int companyId) {
		this.companyId = companyId;
	}
}
