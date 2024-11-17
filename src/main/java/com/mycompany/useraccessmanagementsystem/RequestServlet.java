package com.mycompany.useraccessmanagementsystem;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RequestServlet")
public class RequestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // PostgreSQL database connection details
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/user_management_system;";
    private static final String DB_USER = "postgres"; // Change this if necessary
    private static final String DB_PASSWORD = "root"; // Change this if necessary

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");

        if (username == null || role == null || !role.equals("Employee")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String software = request.getParameter("software");
        String accessType = request.getParameter("accessType");
        String reason = request.getParameter("reason");

        try {
            // Explicitly load the PostgreSQL JDBC driver
            Class.forName("org.postgresql.Driver");

            // Connect to PostgreSQL database
            try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement getUserStmt = connection.prepareStatement("SELECT id FROM users WHERE username = ?");
                 PreparedStatement getSoftwareStmt = connection.prepareStatement("SELECT id FROM software WHERE name = ?");
                 PreparedStatement insertRequestStmt = connection.prepareStatement(
                         "INSERT INTO requests (user_id, software_id, access_type, reason, status) VALUES (?, ?, ?, ?, 'Pending')")
            ) {
                // Fetch user ID
                getUserStmt.setString(1, username);
                try (ResultSet userResultSet = getUserStmt.executeQuery()) {
                    if (!userResultSet.next()) {
                        request.setAttribute("message", "Error: Unable to find user.");
                        request.getRequestDispatcher("requestAccess.jsp").forward(request, response);
                        return;
                    }
                    int userId = userResultSet.getInt("id");

                    // Fetch software ID
                    getSoftwareStmt.setString(1, software);
                    try (ResultSet softwareResultSet = getSoftwareStmt.executeQuery()) {
                        if (!softwareResultSet.next()) {
                            request.setAttribute("message", "Error: Unable to find software.");
                            request.getRequestDispatcher("requestAccess.jsp").forward(request, response);
                            return;
                        }
                        int softwareId = softwareResultSet.getInt("id");

                        // Insert request into requests table
                        insertRequestStmt.setInt(1, userId);
                        insertRequestStmt.setInt(2, softwareId);
                        insertRequestStmt.setString(3, accessType);
                        insertRequestStmt.setString(4, reason);

                        int rowsInserted = insertRequestStmt.executeUpdate();
                        if (rowsInserted > 0) {
                            request.setAttribute("message", "Request submitted successfully!");
                        } else {
                            request.setAttribute("message", "Error: Unable to submit request.");
                        }
                        request.getRequestDispatcher("requestAccess.jsp").forward(request, response);
                    }
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: PostgreSQL Driver not found.");
            request.getRequestDispatcher("requestAccess.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: Unable to process your request due to a database error.");
            request.getRequestDispatcher("requestAccess.jsp").forward(request, response);
        }
    }
}
