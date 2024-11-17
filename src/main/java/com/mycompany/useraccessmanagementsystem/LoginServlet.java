package com.mycompany.useraccessmanagementsystem;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // PostgreSQL database connection details
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/user_management_system;";
    private static final String DB_USER = "postgres";
    private static final String DB_PASSWORD = "root";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Username and password must not be empty.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            // Load PostgreSQL driver
            Class.forName("org.postgresql.Driver");

            // Establish database connection
            try (
                Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                PreparedStatement statement = connection.prepareStatement(
                    "SELECT role, password FROM users WHERE username = ?")
            ) {
                statement.setString(1, username);

                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        String storedPassword = resultSet.getString("password");
                        String role = resultSet.getString("role");

                        if (password.equals(storedPassword)) {
                            HttpSession session = request.getSession();
                            session.setAttribute("username", username);
                            session.setAttribute("role", role);

                            switch (role) {
                                case "Employee":
                                    response.sendRedirect("requestAccess.jsp");
                                    break;
                                case "Manager":
                                    response.sendRedirect("pendingRequests.jsp");
                                    break;
                                case "Admin":
                                    response.sendRedirect("createSoftware.jsp");
                                    break;
                                default:
                                    request.setAttribute("errorMessage", "Unknown role.");
                                    request.getRequestDispatcher("login.jsp").forward(request, response);
                            }
                        } else {
                            request.setAttribute("errorMessage", "Invalid username or password.");
                            request.getRequestDispatcher("login.jsp").forward(request, response);
                        }
                    } else {
                        request.setAttribute("errorMessage", "Invalid username or password.");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: Unable to connect to the database.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
