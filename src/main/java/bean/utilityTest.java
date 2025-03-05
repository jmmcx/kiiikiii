package bean;

import util.Model3dUtil;
import model.LocationData;

import java.io.IOException;
import java.util.List;

public class utilityTest {
    public static void main(String[] args) {
        // Replace this with the actual path to your Excel file
        String filePath = "src/main/webapp/3dModel/KMITL_Locations.xlsx";
        
        try {
            // First, get the sheet names dynamically from A1 cells
            List<String> sheetNames = Model3dUtil.getSheetNamesFromExcel(filePath);
            
            // Iterate through each sheet and retrieve its data
            for (String sheetName : sheetNames) {
                System.out.println("\n--- Retrieving Data from Sheet: " + sheetName + " ---");
                try {
                    List<LocationData> locationsForSheet = Model3dUtil.getLocationDataFromSheet(filePath, sheetName);
                    
                    // Print out locations from this sheet
                    for (LocationData location : locationsForSheet) {
                        System.out.println(location);
                    }
                } catch (Exception e) {
                    System.err.println("Error processing sheet " + sheetName + ": " + e.getMessage());
                    e.printStackTrace();
                }
            }
            
        } catch (IOException e) {
            System.err.println("Error reading Excel file: " + e.getMessage());
            e.printStackTrace();
        }
    }
}