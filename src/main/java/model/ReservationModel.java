package model;

import java.util.ArrayList;
import java.util.List;

public class ReservationModel {
    private String bookingId;
    private String name;
    private String email;
    private String phone;
    private String organiztion;
    private String city;
    private String country;
    private int numVisitors;
    private List<String> visitorNames;
    private List<String> visitorAges;
    private String location;
    private String bookingDate;
    private String timeSlot;
    private String mergedTimeSlots;
    private String status;
    private String createdAt;
    private String updatedAt;

    public ReservationModel(){
        
    }

    public ReservationModel(String bookingId, String name, String email, String phone, String organization, String city, String country, int numVisitors, List<String> visitorNames, List<String> visitorAges, String location, String bookingDate, String timeSlot, String mergedTimeSlots, String status, String createdAt, String updatedAt) {
        this.bookingId = bookingId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.organiztion = organization;
        this.country = country;
        this.city = city;
        this.numVisitors = numVisitors;
        this.visitorNames = visitorNames;
        this.visitorAges = visitorAges;
        this.location = location;
        this.bookingDate = bookingDate;
        this.timeSlot = timeSlot;
        this.mergedTimeSlots = mergedTimeSlots;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public String getBookingId() { return bookingId; }
    public void setBookingId(String bookingId) { this.bookingId = bookingId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getOrganization() { return organiztion; }
    public void setOrganiztion(String organization) { this.organiztion = organization; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }

    public int getNumVisitors() { return numVisitors; }
    public void setNumVisitors(int numVisitors) { this.numVisitors = numVisitors; }

    public List<String> getVisitorNames() { return visitorNames; }
    public void setVisitorNames(List<String> visitorNames) { this.visitorNames = visitorNames; }

    public List<String> getVisitorAges() { return visitorAges; }
    public void setVisitorAges(List<String> visitorAges) { this.visitorAges = visitorAges; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }

    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public String getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(String updatedAt) { this.updatedAt = updatedAt; }

    public String getMergedTimeSlots() { return mergedTimeSlots; }
    public void setMergedTimeSlot(String mergedTimeSlots) { this.mergedTimeSlots = mergedTimeSlots; }

    public String getMergedTimeSlot() {
        if (timeSlot == null || timeSlot.isEmpty()) {
            return "";
        }

        String[] slots = timeSlot.split(",");
        if (slots.length == 0) {
            return "";
        }

        List<String> mergedSlots = new ArrayList<>();
        String startTime = null;
        String endTime = null;

        for (int i = 0; i < slots.length; i++) {
            String[] times = slots[i].split("-");
            if (startTime == null) {
                startTime = times[0];
                endTime = times[1];
            } else {
                // Check if current slot starts at previous slot's end time
                if (times[0].equals(endTime)) {
                    endTime = times[1];
                } else {
                    // Add the completed merged slot and start a new one
                    mergedSlots.add(startTime + "-" + endTime);
                    startTime = times[0];
                    endTime = times[1];
                }
            }
            
            // Add the last slot
            if (i == slots.length - 1) {
                mergedSlots.add(startTime + "-" + endTime);
            }
        }

        return String.join(", ", mergedSlots);
    }
}