package in.pandit.persistance;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseConnection {
	public static Connection getConnection() {
		Connection conn = null;
		try {
			String url = "jdbc:postgresql://localhost:5432/lms";
			String user = "postgres";
			String pass = "root";
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(url, user, pass);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}
}
