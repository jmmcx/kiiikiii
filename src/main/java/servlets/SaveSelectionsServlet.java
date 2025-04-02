package servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SaveSelectionsServlet")
public class SaveSelectionsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get selected values from request
        String selectedStartId = request.getParameter("selectedStartId");
        String selectedEndId = request.getParameter("selectedEndId");
        
        // Store in session
        HttpSession session = request.getSession();
        session.setAttribute("selectedStartId", selectedStartId);
        session.setAttribute("selectedEndId", selectedEndId);
        
        // No redirect needed for AJAX call
        response.setStatus(HttpServletResponse.SC_OK);
    }
}