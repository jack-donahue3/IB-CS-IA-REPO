import java.sql.*;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) throws Exception {

        Connection db = DriverManager.getConnection(
            "jdbc:postgresql://localhost:5433/ia_project",
            "ia_user",
            "COMPUTERDATABASEPASSWORD"
        );

        Scanner scan = new Scanner(System.in);

        System.out.print("email: ");
        String email = scan.nextLine();

        System.out.print("password: ");
        String password = scan.nextLine();

        Statement statement = db.createStatement();

        ResultSet user = statement.executeQuery(
            "SELECT * FROM users WHERE email = '" + email +
            "' AND password_hash = '" + password + "'"
        );

        if (user.next()) {
            System.out.println("login successful");
            System.out.println("role: " + user.getString("role"));
        } else {
            System.out.println("invalid");
        }

        db.close();
    }
}