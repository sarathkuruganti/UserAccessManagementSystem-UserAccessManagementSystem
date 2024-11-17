import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ApprovalServlet")
public class ApprovalServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection details for PostgreSQL
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/user_management_system;"; // Change to your PostgreSQL DB details
    private static final String DB_USER = "postgres"; // Your PostgreSQL username
    private static final String DB_PASSWORD = "root"; // Your PostgreSQL password

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve the request id and action (approve/reject) from the form
        String requestId = request.getParameter("requestId");
        String action = request.getParameter("action"); // 'approve' or 'reject'

        // Log the received parameters (for debugging)
        System.out.println("Received requestId: " + requestId);
        System.out.println("Received action: " + action);

        // Validate the requestId and action
        if (requestId == null || requestId.isEmpty()) {
            response.getWriter().write("Error: Request ID is missing.");
            return;
        }

        if (action == null || (!action.equals("approve") && !action.equals("reject"))) {
            response.getWriter().write("Error: Invalid action.");
            return;
        }

        Connection connection = null;
        PreparedStatement preparedStatement = null;

        try {
            // Load PostgreSQL JDBC driver
            Class.forName("org.postgresql.Driver");

            // Establish database connection
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // SQL query to update the request status based on requestId
            String sql = "UPDATE requests SET status = ? WHERE id = ?";

            // Prepare the statement based on the action (approve or reject)
            preparedStatement = connection.prepareStatement(sql);
            if (action.equals("approve")) {
                preparedStatement.setString(1, "Approved");
            } else if (action.equals("reject")) {
                preparedStatement.setString(1, "Rejected");
            }

            // Ensure that requestId is not null and is a valid integer
            int reqId;
            try {
                reqId = Integer.parseInt(requestId); // Safe parsing
            } catch (NumberFormatException e) {
                response.getWriter().write("Error: Invalid request ID format.");
                return;
            }

            preparedStatement.setInt(2, reqId);

            // Execute the update query
            int rowsUpdated = preparedStatement.executeUpdate();

            // Check if the request was successfully updated
            if (rowsUpdated > 0) {
                // Redirect to the pending requests page (or any other page after processing)
                response.sendRedirect("pendingRequests.jsp");
            } else {
                // In case no matching request was found, send an error message
                response.getWriter().write("Error: Request not found or failed to update.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (preparedStatement != null) preparedStatement.close();
                if (connection != null) connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
