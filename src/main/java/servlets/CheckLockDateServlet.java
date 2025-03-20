package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.ReservationDAO;

@WebServlet("/CheckLockDateServlet") // for visitor
public class CheckLockDateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String dateStr = request.getParameter("date");
        boolean isLocked = false;
        
        if (dateStr != null && !dateStr.isEmpty()) {
            ReservationDAO dao = new ReservationDAO();
            isLocked = dao.isDateLocked(dateStr);
        }
        
        // Send JSON response
        out.print("{\"locked\":" + isLocked + "}");
        out.flush();
    }
}
