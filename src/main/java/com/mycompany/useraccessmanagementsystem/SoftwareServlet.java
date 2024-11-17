package com.mycompany.useraccessmanagementsystem;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SoftwareServlet")
public class SoftwareServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection details for PostgreSQL
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/user_management_system;"; // Update the URL as per your PostgreSQL setup
    private static final String DB_USER = "postgres";  // Update with your PostgreSQL username
    private static final String DB_PASSWORD = "root";  // Update with your PostgreSQL password

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String[] accessLevels = request.getParameterValues("accessLevels");

        // Convert access levels array to a comma-separated string
        String accessLevelsString = String.join(",", accessLevels);

        Connection connection = null;
        PreparedStatement statement = null;

        try {
            // Load PostgreSQL JDBC Driver
            Class.forName("org.postgresql.Driver");

            // Establish a database connection
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Insert software data into the `software` table
            String sql = "INSERT INTO software (name, description, access_levels) VALUES (?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setString(1, name);
            statement.setString(2, description);
            statement.setString(3, accessLevelsString);

            int rowsInserted = statement.executeUpdate();
            if (rowsInserted > 0) {
                response.getWriter().println("Software added successfully!");
            } else {
                response.getWriter().println("Error: Unable to add software.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: Unable to connect to the database.");
        } finally {
            try {
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}
