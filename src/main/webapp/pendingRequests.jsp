<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.DriverManager" %>

<%
    // Check if the user is logged in and has the "Manager" or "Admin" role
    String role = (String) session.getAttribute("role");
    if (role == null || (!role.equals("Manager") && !role.equals("Admin"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Initialize the list to store pending requests
    List<Map<String, String>> pendingRequests = new ArrayList<>();

    // Establish the database connection and fetch pending requests
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    try {
        // Explicitly load the PostgreSQL JDBC driver
        Class.forName("org.postgresql.Driver");

        // Create the connection (replace with your actual PostgreSQL connection details)
        connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/user_management_system;", "postgres", "root");

        // Query to join requests, users, and software tables to get employee names, software names, and request id
        String sql = "SELECT r.id, u.username, s.name AS software_name, r.access_type, r.reason " +
                     "FROM requests r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN software s ON r.software_id = s.id " +
                     "WHERE r.status = 'Pending'";

        statement = connection.createStatement();
        resultSet = statement.executeQuery(sql);

        // Populate the pendingRequests list
        while (resultSet.next()) {
            Map<String, String> pendingRequest = new HashMap<>();
            pendingRequest.put("id", resultSet.getString("id")); // Fetching request id
            pendingRequest.put("employeeName", resultSet.getString("username")); // Fetching username from users table
            pendingRequest.put("softwareName", resultSet.getString("software_name")); // Fetching software name from software table
            pendingRequest.put("accessType", resultSet.getString("access_type"));
            pendingRequest.put("reason", resultSet.getString("reason"));

            pendingRequests.add(pendingRequest);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (resultSet != null) resultSet.close();
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Access Requests</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-top: 20px;
        }

        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
        }

        button {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 6px 12px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
            border-radius: 4px;
            font-size: 14px;
        }

        button:hover {
            background-color: #0056b3;
            transform: scale(1.05);
        }

        .approve {
            background-color: #28a745;
        }

        .approve:hover {
            background-color: #218838;
        }

        .reject {
            background-color: #dc3545;
        }

        .reject:hover {
            background-color: #c82333;
        }

        .container {
            padding: 20px;
        }

        footer {
            text-align: center;
            margin-top: 30px;
            font-size: 14px;
            color: #999;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Pending Access Requests</h2>

        <% if (pendingRequests.isEmpty()) { %>
            <p>No pending requests at the moment.</p>
        <% } else { %>

        <table>
            <thead>
                <tr>
                    <th>Employee Name</th>
                    <th>Software Name</th>
                    <th>Access Type</th>
                    <th>Reason for Request</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Loop through the pending requests and display them in the table
                    for (Map<String, String> pendingRequest : pendingRequests) {
                %>
                <tr>
                    <td><%= pendingRequest.get("employeeName") %></td>
                    <td><%= pendingRequest.get("softwareName") %></td>
                    <td><%= pendingRequest.get("accessType") %></td>
                    <td><%= pendingRequest.get("reason") %></td>
                    <td>
                        <!-- Form for approving the request -->
                        <form action="ApprovalServlet" method="POST" style="display:inline;">
                            <input type="hidden" name="requestId" value="<%= pendingRequest.get("id") %>">
                            <input type="hidden" name="action" value="approve">
                            <button type="submit" class="approve">Approve</button>
                        </form>

                        <!-- Form for rejecting the request -->
                        <form action="ApprovalServlet" method="POST" style="display:inline;">
                            <input type="hidden" name="requestId" value="<%= pendingRequest.get("id") %>">
                            <input type="hidden" name="action" value="reject">
                            <button type="submit" class="reject">Reject</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <% } %>
    </div>
</body>
</html>
