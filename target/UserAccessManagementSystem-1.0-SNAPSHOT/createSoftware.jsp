<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if the user is logged in and has the "Admin" role
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("Admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Software Creation</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        
        .container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
        }

        h2 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }

        input[type="text"], textarea {
            width: 100%;
            padding: 12px;
            margin-top: 8px;
            margin-bottom: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            box-sizing: border-box;
        }

        textarea {
            resize: vertical;
        }

        .checkbox-group {
            display: flex;
            gap: 20px;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .checkbox-group label {
            display: flex;
            align-items: center;
        }

        .checkbox-group input[type="checkbox"] {
            margin-right: 6px;
        }

        button {
            background-color: #3498db;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #2980b9;
        }

        button:focus {
            outline: none;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.6);
        }

        footer {
            text-align: center;
            margin-top: 20px;
            color: #888;
        }

        /* Responsive design */
        @media (max-width: 600px) {
            .container {
                padding: 20px;
            }

            button {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

    <div class="container">
        <form action="SoftwareServlet" method="POST">
            <h2>Create New Software</h2>

            <label for="name">Software Name:</label>
            <input type="text" id="name" name="name" required placeholder="Enter software name"/>

            <label for="description">Description:</label>
            <textarea id="description" name="description" rows="4" required placeholder="Enter a description"></textarea>

            <label>Access Levels:</label>
            <div class="checkbox-group">
                <label><input type="checkbox" name="accessLevels" value="Read" /> Read</label>
                <label><input type="checkbox" name="accessLevels" value="Write" /> Write</label>
                <label><input type="checkbox" name="accessLevels" value="Admin" /> Admin</label>
            </div>
            <br>

            <button type="submit">Create Software</button>
        </form>
    </div>
</body>
</html>
