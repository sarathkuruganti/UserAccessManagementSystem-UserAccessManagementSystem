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

@WebServlet("/SignUpServlet")
public class SignUpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection details for local PostgreSQL
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/user_management_system;";
    private static final String DB_USER = "postgres";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Retrieve form data
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); // Hidden field for user role (default: Employee)

        // Initialize database connection and statement objects
        Connection connection = null;
        PreparedStatement statement = null;

        try {
            // Load PostgreSQL JDBC Driver
            Class.forName("org.postgresql.Driver");

            // Establish a database connection
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // SQL query to insert user data into the `users` table
            String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            statement.setString(2, password); // Consider hashing the password for better security
            statement.setString(3, role);

            // Execute the query
            int rowsInserted = statement.executeUpdate();

            if (rowsInserted > 0) {
                // Set success message and forward to login page
                request.setAttribute("successMessage", "Registration successful! Please log in.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Error: Unable to register user.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: Unable to connect to the database or register user.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        } finally {
            try {
                // Close resources
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}
