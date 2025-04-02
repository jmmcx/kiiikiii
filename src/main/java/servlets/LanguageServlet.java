package servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LanguageServlet")
public class LanguageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String lang = request.getParameter("lang");  // Get language from request
        
        if (lang == null || lang.isEmpty()) {
            lang = "en";  // Default language is English
        }

        HttpSession session = request.getSession();
        session.setAttribute("lang", lang);  // Store in session

        // Check for selection parameters
        String selectedStartId = request.getParameter("selectedStartId");
        String selectedEndId = request.getParameter("selectedEndId");
        
        // Store selection in session if provided
        if (selectedStartId != null) {
            session.setAttribute("selectedStartId", selectedStartId);
        }
        
        if (selectedEndId != null) {
            session.setAttribute("selectedEndId", selectedEndId);
        }
        
        response.sendRedirect(request.getContextPath() + "/pages/map.jsp");  // Redirect properly
    }
}
