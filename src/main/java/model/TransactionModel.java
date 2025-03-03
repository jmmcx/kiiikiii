package model;

import java.sql.Timestamp;
import java.util.Date;

public class TransactionModel {
    private String transactionId;
    private String serialNumber;
    private String fieldNumber;
    private String studentId;
    private String studentName;
    private String transactionType;
    private int quantity;
    private Timestamp borrowDate;
    private Date dueDate;
    private Timestamp returnDate;
    private String remarks;
    private String itemName;    // not in DB but for easy to use for return cases

    public TransactionModel() {
        // Default constructor
    }

    public TransactionModel(String transactionId, String serialNumber, String fieldNumber,
                            String studentId, String studentName, String transactionType,
                            int quantity, Timestamp borrowDate, Date dueDate, 
                            Timestamp returnDate, String remarks, String itemName) {
        this.transactionId = transactionId;
        this.serialNumber = serialNumber;
        this.fieldNumber = fieldNumber;
        this.studentId = studentId;
        this.studentName = studentName;
        this.transactionType = transactionType;
        this.quantity = quantity;
        this.borrowDate = borrowDate;
        this.dueDate = dueDate;
        this.returnDate = returnDate;
        this.remarks = remarks;
        this.itemName = itemName;
    }

    // Getters and setters
    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public String getFieldNumber() {
        return fieldNumber;
    }

    public void setFieldNumber(String fieldNumber) {
        this.fieldNumber = fieldNumber;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Timestamp getBorrowDate() {
        return borrowDate;
    }

    public void setBorrowDate(Timestamp borrowDate) {
        this.borrowDate = borrowDate;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public Timestamp getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(Timestamp returnDate) {
        this.returnDate = returnDate;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }
}