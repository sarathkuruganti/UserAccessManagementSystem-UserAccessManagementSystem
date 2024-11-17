<!DOCTYPE html>
<html>
<head>
    <title>Sign Up</title>
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
        .container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 350px;
            text-align: center;
        }

        h1 {
            color: #333;
        }

        /* Label and input field styling */
        label {
            display: block;
            font-size: 16px;
            color: #333;
            margin: 10px 0 5px;
            margin-top: 15px;
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
            font-size: 14px;
            margin-top: -15px;
            margin-bottom: 10px;
            text-align: left;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Sign Up</h1>
        <form id="signupForm" action="SignUpServlet" method="post">
            <!-- Username field -->
            <label for="username">Username:</label>
            <input type="text" name="username" id="username" required>
            <div id="usernameError" class="error-message"></div>
            
            <!-- Password field -->
            <label for="password">Password:</label>
            <input type="password" name="password" id="password" required>
            <div id="passwordError" class="error-message"></div>
            <br>
            
            <!-- Hidden Role field -->
            <input type="hidden" name="role" value="Employee">
            
            <!-- Submit button -->
            <button type="submit">Sign Up</button>
        </form>
        <br>
        <div class="login-link">
            Already have an account? <a href="login.jsp">Log in</a>
        </div>
    </div>

    <script>
        // Function for validating the form fields
        function validateForm() {
            let isValid = true;
            
            // Clear previous error messages
            document.getElementById("usernameError").innerText = "";
            document.getElementById("passwordError").innerText = "";
            
            // Username validation
            const username = document.getElementById("username").value;
            if (username.length < 3) {
                document.getElementById("usernameError").innerText = "Username must be at least 3 characters long.";
                isValid = false;
            }
            
            // Password validation
            const password = document.getElementById("password").value;
const strongPasswordPattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{6,}$/;
if (!strongPasswordPattern.test(password)) {
    document.getElementById("passwordError").innerText = "Password must be at least 6 characters long and include at least one letter, one number, and one special character.";
    isValid = false;
}
            
            return isValid;
        }

        // Attach the validation function to the form submit event
        document.getElementById("signupForm").onsubmit = function(event) {
            if (!validateForm()) {
                event.preventDefault(); // Prevent form submission if validation fails
            }
        };
    </script>
</body>
</html>
