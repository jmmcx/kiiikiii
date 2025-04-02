package servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import dao.LocationsDAO;
import model.LocationsModel;

@WebServlet("/GetLocationCoordinatesServlet")
public class GetLocationCoordinatesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String startId = request.getParameter("startId");
        String endId = request.getParameter("endId");
        
        if (startId == null || startId.isEmpty() || endId == null || endId.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Both start and end location IDs are required\"}");
            return;
        }
        
        LocationsDAO locationsDAO = new LocationsDAO();
        try {
            LocationsModel startLocation = locationsDAO.getLocationById(Integer.parseInt(startId));
            LocationsModel endLocation = locationsDAO.getLocationById(Integer.parseInt(endId));
            
            if (startLocation == null || endLocation == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"One or both locations not found\"}");
                return;
            }
            
            // Create JSON response with coordinates
            JSONObject coordinates = new JSONObject();
            coordinates.put("startLat", startLocation.getPlace_lat());
            coordinates.put("startLon", startLocation.getPlace_long());
            coordinates.put("endLat", endLocation.getPlace_lat());
            coordinates.put("endLon", endLocation.getPlace_long());
            
            // Send response
            PrintWriter out = response.getWriter();
            out.print(coordinates.toString());
            out.flush();
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = response.getWriter();
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
            out.flush();
        }
    }
}