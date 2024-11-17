<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.List, java.util.ArrayList" %> 
<%
    // Database connection details for PostgreSQL
    String dbUrl = "jdbc:postgresql://localhost:5432/user_management_system;";
    String dbUser = "postgres";
    String dbPassword = "root";

    // Check if the user is logged in and has the "Employee" role
    String role = (String) session.getAttribute("role");
    if (role == null || (!role.equals("Employee") && !role.equals("Admin"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Initialize variables for retrieving software data
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;
    List<String> softwareList = new ArrayList<>();  // Now List and ArrayList are recognized

    try {
        // Load PostgreSQL driver
        Class.forName("org.postgresql.Driver");
        
        // Establish the database connection
        connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // Create the SQL query to get the list of software
        String sql = "SELECT name FROM software";
        statement = connection.createStatement();
        resultSet = statement.executeQuery(sql);

        // Loop through the results and add to the software list
        while (resultSet.next()) {
            softwareList.add(resultSet.getString("name"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Clean up database resources
        try {
            if (resultSet != null) resultSet.close();
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Request</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f7f7;
            color: #333;
            line-height: 1.6;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-top: 30px;
        }

        .container {
            width: 100%;
            max-width: 500px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        label {
            font-weight: bold;
            color: #555;
        }

        select, textarea, button {
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            width: 100%;
            background-color: #f9f9f9;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        select:focus, textarea:focus, button:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
        }

        button {
            background-color: #007bff;
            color: #fff;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #0056b3;
        }

        textarea {
            resize: vertical;
            height: 120px;
        }

        .footer {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #aaa;
        }
        
        .message {
            padding: 10px;
            margin: 10px 0px;
            font-size: 16px;
            border-radius:5px;
        }

        .message p {
            margin: 0;
        }

        .message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        @media (max-width: 600px) {
            .container {
                padding: 10px;
            }

            h2 {
                font-size: 24px;
            }

            select, textarea, button {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>Access Request</h2>
        <%
            String message = (String) request.getAttribute("message");
            if (message != null) {
        %>
            <div class="message <%= message.contains("Error") ? "error" : "success" %>">
    <p><%= message %></p>
</div>
        <%
            }
        %>
        <form action="RequestServlet" method="POST">
            <div>
                <label for="software">Software Name:</label>
                <select id="software" name="software" required>
                    <%
                        // Loop through the software list and display options
                        for (String software : softwareList) {
                    %>
                        <option value="<%= software %>"><%= software %></option>
                    <%
                        }
                    %>
                </select>
            </div>

            <div>
                <label for="accessType">Access Type:</label>
                <select id="accessType" name="accessType" required>
                    <option value="Read">Read</option>
                    <option value="Write">Write</option>
                    <option value="Admin">Admin</option>
                </select>
            </div>

            <div>
                <label for="reason">Reason for Request:</label>
                <textarea id="reason" name="reason" rows="4" required></textarea>
            </div>

            <button type="submit">Submit Request</button>
        </form>
    </div>

</body>
</html>
