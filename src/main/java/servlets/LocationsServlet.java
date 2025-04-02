package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import dao.LocationsDAO;
import model.LocationsModel;

@WebServlet("/LocationsServlet")
public class LocationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String locationId = request.getParameter("id");
        LocationsDAO locationsDAO = new LocationsDAO();
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        
        try {
            // If ID is provided, return a single location
            if (locationId != null && !locationId.isEmpty()) {
                LocationsModel location = locationsDAO.getLocationById(Integer.parseInt(locationId));
                
                if (location == null) {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print("{\"error\": \"Location not found\"}");
                    return;
                }
                
                String jsonLocation = gson.toJson(location);
                out.print(jsonLocation);
            } 
            // Otherwise, return all locations
            else {
                List<LocationsModel> locations = locationsDAO.getAllPendingLocations();
                String jsonLocations = gson.toJson(locations);
                out.print(jsonLocations);
            }
            
            out.flush();
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid location ID format\"}");
            out.flush();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
            out.flush();
        }
    }
}