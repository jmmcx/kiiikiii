package util;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.InputStream;
import java.util.*;

public class ExcelReader {

    private static final String FILE_NAME = "/KMITL_Locations.xlsx"; // Make sure this is correct

    public static Map<String, List<String[]>> readExcelData() {
        Map<String, List<String[]>> zoneData = new HashMap<>();

        try {
            // Get resource as stream
            InputStream inputStream = ExcelReader.class.getResourceAsStream(FILE_NAME);
            
            if (inputStream == null) {
                System.err.println("ERROR: Could not find Excel file: " + FILE_NAME);
                return zoneData; // Return empty map
            }
            
            Workbook workbook = new XSSFWorkbook(inputStream);
            int sheetCount = workbook.getNumberOfSheets();
            System.out.println("Found " + sheetCount + " sheets in Excel file");
            
            for (int i = 0; i < sheetCount; i++) {
                Sheet sheet = workbook.getSheetAt(i);
                String sheetName = sheet.getSheetName();
                System.out.println("Processing sheet: " + sheetName);
                
                List<String[]> locations = new ArrayList<>();
                int rowCount = 0;
                
                for (Row row : sheet) {
                    if (row.getRowNum() < 3) continue; // Skip header rows
                    
                    String[] data = new String[3];
                    data[0] = getCellValue(row.getCell(0)); // Location number
                    data[1] = getCellValue(row.getCell(1)); // Thai name
                    data[2] = getCellValue(row.getCell(2)); // English name
                    
                    // Skip rows with empty data
                    if (data[0].isEmpty() && data[1].isEmpty() && data[2].isEmpty()) {
                        continue;
                    }
                    
                    locations.add(data);
                    rowCount++;
                }
                
                System.out.println("Added " + rowCount + " locations from sheet: " + sheetName);
                zoneData.put(sheetName, locations); // Store data per sheet
            }
            
            workbook.close();
            inputStream.close();

        } catch (Exception e) {
            System.err.println("ERROR reading Excel file: " + e.getMessage());
            e.printStackTrace();
        }

        return zoneData;
    }

    private static String getCellValue(Cell cell) {
        if (cell == null) return "";
        
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                // Handle numeric cells - convert to string
                return String.valueOf((int)cell.getNumericCellValue());
            default:
                return "";
        }
    }
}