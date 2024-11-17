<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
    <style>
        /* Basic page styling */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        /* Container for the form */
        .login-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 350px;
            text-align: center;
        }

        h2 {
            color: #333;
            font-size: 24px;
            margin-bottom: 20px;
        }

        /* Label and input field styling */
        label {
            display: block;
            font-size: 16px;
            color: #333;
            margin: 10px 0 5px;
            text-align: left;
        }

        input[type="text"], input[type="password"] {
            width: 95%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-bottom: 20px;
        }

        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #5c9ded;
            outline: none;
        }

        /* Submit button styling */
        button {
            background-color: #5c9ded;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
        }

        button:hover {
            background-color: #4287b5;
        }

        /* Error message styling */
        .error-message {
            color: red;
            font-size: 16px;
            margin-bottom: 15px;
            text-align: left;
        }

        /* Success message styling */
        .success-message {
            color: green;
            font-size: 16px;
            margin-bottom: 15px;
            text-align: left;
        }

        .signup-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>Login</h1>
        <!-- Display success message if it exists -->
        <%
            String successMessage = (String) request.getAttribute("successMessage");
            if (successMessage != null) {
        %>
            <div class="success-message"><%= successMessage %></div>
        <%
            }
        %>
        <!-- Display error message if it exists -->
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
            <div class="error-message"><%= errorMessage %></div>
        <%
            }
        %>
        <form action="LoginServlet" method="post">
            <!-- Username field -->
            <label for="username">Username:</label>
            <input type="text" name="username" id="username" required>
            
            <!-- Password field -->
            <label for="password">Password:</label>
            <input type="password" name="password" id="password" required>
            
            <!-- Submit button -->
            <button type="submit">Login</button>
        </form>
        <br>
        <!-- Signup link -->
        Don't have an account?
        <a href="signup.jsp" class="signup-link">Sign up</a>
    </div>
</body>
</html>
