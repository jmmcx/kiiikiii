package dao;
import bean.dBConnection;
import model.LocationsModel;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
// import java.util.Arrays;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class LocationsDAO {
    private static final Logger logger = LogManager.getLogger(LocationsDAO.class);
    private static final String SELECT_ALL_LOCATIONS = "SELECT * FROM test_loc ";


    public List<LocationsModel> getAllPendingLocations() throws Exception {
        List<LocationsModel> pendingLocations = new ArrayList<>();

        try (Connection conn = dBConnection.getConnection(); 
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_ALL_LOCATIONS)) {

            while (rs.next()) {
                    pendingLocations.add(convertResultSetToLocationsModel(rs));
            }
            logger.info("Found {} pending locations", pendingLocations.size());
        } catch (SQLException e) {
            logger.error("Error fetching pending locations", e);
            throw new Exception("Error fetching pending locations", e);
        } finally {
            dBConnection.shutdown();
        }

        return pendingLocations;
    }

    private LocationsModel convertResultSetToLocationsModel(ResultSet rs) throws SQLException {
        return new LocationsModel(
            rs.getInt("place_id"),
            rs.getString("place_thai"),
            rs.getString("place_english"),
            rs.getFloat("place_lat"),
            rs.getFloat("place_long"),
            rs.getString("place_zone")
        );
    }

    public LocationsModel getLocationById(int locationId) throws Exception {
        LocationsModel location = null;
        String query = "SELECT * FROM test_loc WHERE place_id = " + locationId;
    
        try (Connection conn = dBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
    
            if (rs.next()) {
                location = convertResultSetToLocationsModel(rs);
            }
            logger.info("Retrieved location with ID: {}", locationId);
        } catch (SQLException e) {
            logger.error("Error fetching location by ID: {}", locationId, e);
            throw new Exception("Error fetching location by ID: " + locationId, e);
        } finally {
            dBConnection.shutdown();
        }
    
        return location;
    }
}
  