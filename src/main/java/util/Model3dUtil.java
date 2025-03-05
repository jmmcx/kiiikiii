package util;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import model.LocationData;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class Model3dUtil {
    
    /**
     * Retrieves location data from a specific sheet in the Excel file.
     * 
     * @param filePath Path to the Excel file
     * @param sheetName Name of the sheet to read
     * @return List of LocationData objects
     * @throws IOException if file reading fails
     */
    public static List<LocationData> getLocationDataFromSheet(String filePath, String sheetName) throws IOException {
        List<LocationData> locations = new ArrayList<>();
        
        try (FileInputStream fis = new FileInputStream(filePath);
             Workbook workbook = new XSSFWorkbook(fis)) {
            
            // Find the sheet by name
            Sheet sheet = workbook.getSheet(sheetName);
            if (sheet == null) {
                throw new IllegalArgumentException("Sheet not found: " + sheetName);
            }
            
            // Verify sheet name in A1 cell
            String expectedSheetName = getCellValueAsString(sheet.getRow(0).getCell(0));
            if (!sheetName.equals(expectedSheetName)) {
                throw new IllegalArgumentException("Sheet name mismatch: expected " + sheetName + ", found " + expectedSheetName);
            }
            
            // Read column names from 3rd row (index 2)
            @SuppressWarnings("unused")
            Row headerRow = sheet.getRow(2);
            
            // Start reading data from 4th row (index 3)
            for (int i = 3; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;
                
                LocationData location = new LocationData();
                
                // Set values based on column positions
                location.setNo(getCellValueAsString(row.getCell(0)));
                location.setThaiLink(getCellValueAsString(row.getCell(1)));
                location.setEnglishLink(getCellValueAsString(row.getCell(2)));
                location.setFacultyDepartment(getCellValueAsString(row.getCell(3)));
                
                locations.add(location);
            }
        }
        
        return locations;
    }
    
    /**
     * Safely retrieves cell value as a string, handling different cell types.
     * 
     * @param cell Excel cell to extract value from
     * @return String representation of cell value
     */
    private static String getCellValueAsString(Cell cell) {
        if (cell == null) return "";
        
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                // Check if it's a date or number
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getDateCellValue().toString();
                } else {
                    return String.valueOf(cell.getNumericCellValue());
                }
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                return cell.getCellFormula();
            default:
                return "";
        }
    }
    
    /**
     * Retrieves data from all sheets in the Excel file.
     * 
     * @param filePath Path to the Excel file
     * @return List of LocationData from all sheets
     * @throws IOException if file reading fails
     */
    public static List<LocationData> getAllLocationsData(String filePath) throws IOException {
        List<LocationData> allLocations = new ArrayList<>();
        
        try (FileInputStream fis = new FileInputStream(filePath);
             Workbook workbook = new XSSFWorkbook(fis)) {
            
            for (int i = 0; i < workbook.getNumberOfSheets(); i++) {
                Sheet sheet = workbook.getSheetAt(i);
                String sheetName = getCellValueAsString(sheet.getRow(0).getCell(0));
                allLocations.addAll(getLocationDataFromSheet(filePath, sheetName));
            }
        }
        
        return allLocations;
    }

    /**
     * Retrieves sheet names from A1 cells in the Excel file
     * 
     * @param filePath Path to the Excel file
     * @return List of sheet names
     * @throws IOException if file reading fails
     */
    public static List<String> getSheetNamesFromExcel(String filePath) throws IOException {
        List<String> sheetNames = new ArrayList<>();
        
        try (FileInputStream fis = new FileInputStream(filePath);
             Workbook workbook = new XSSFWorkbook(fis)) {
            
            // Iterate through all sheets
            for (int i = 0; i < workbook.getNumberOfSheets(); i++) {
                Sheet sheet = workbook.getSheetAt(i);
                
                // Get A1 cell value and trim
                Cell a1Cell = sheet.getRow(0).getCell(0);
                String sheetName = a1Cell.getStringCellValue().trim();
                
                sheetNames.add(sheetName);
            }
        }
        
        return sheetNames;
    }
}