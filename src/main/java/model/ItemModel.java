package model;

public class ItemModel {
    private int no;
    private String itemName;
    private String abbByLLM;
    private boolean duplicateFlag;
    private String duplicate;
    private String uniqueFlag;
    private String brand;
    private String location;
    private String quantity;
    private String quantity_available;
    private String subcatByLLM;
    private String field1;
    private String field2;
    private String field3;
    private String field4;
    private String field5;
    private String field6;
    private String field7;
    private String serialNumber;
    private String entrustedCommend;

    // Constructor for ItemModel
    public ItemModel(int no, String itemName, String abbByLLM, boolean duplicateFlag, String duplicate, 
                     String uniqueFlag, String brand, String location, String quantity, String quantity_available, 
                     String subcatByLLM, String field1, String field2, String field3, 
                     String field4, String field5, String field6, String field7, 
                     String serialNumber, String entrustedCommend) {
        this.no = no;
        this.itemName = itemName;
        this.abbByLLM = abbByLLM;
        this.duplicateFlag = duplicateFlag;
        this.duplicate = duplicate;
        this.uniqueFlag = uniqueFlag;
        this.brand = brand;
        this.location = location;
        this.quantity = quantity;
        this.quantity_available = quantity_available;
        this.subcatByLLM = subcatByLLM;
        this.field1 = field1;
        this.field2 = field2;
        this.field3 = field3;
        this.field4 = field4;
        this.field5 = field5;
        this.field6 = field6;
        this.field7 = field7;
        this.serialNumber = serialNumber;
        this.entrustedCommend = entrustedCommend;
    }

    // Getters and Setters
    public int getNo() {
        return no;
    }

    public String getItemName() {
        return itemName;
    }

    public String getAbbByLLM() {
        return abbByLLM;
    }

    public boolean isDuplicateFlag() {
        return duplicateFlag;
    }

    public String getDuplicate() {
        return duplicate;
    }

    public String getUniqueFlag() {
        return uniqueFlag;
    }

    public String getBrand() {
        return brand;
    }

    public String getLocation() {
        return location;
    }

    public String getQuantity() {
        return quantity;
    }

    public String getQuantityAvailable() {
        return quantity_available;
    }

    public String getSubcatByLLM() {
        return subcatByLLM;
    }

    public String getField1() {
        return field1;
    }

    public String getField2() {
        return field2;
    }

    public String getField3() {
        return field3;
    }

    public String getField4() {
        return field4;
    }

    public String getField5() {
        return field5;
    }

    public String getField6() {
        return field6;
    }

    public String getField7() {
        return field7;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public String getEntrustedCommend() {
        return entrustedCommend;
    }
}
