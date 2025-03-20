package model;

import java.sql.Timestamp;
import java.util.ArrayList;
// import java.util.Date;
import java.util.List;

public class StudentBookingModel {
    private String bookingID;
    private String name;
    private String email;
    private String phone;
    private String location;
    private String bookingDate;
    private String timeSlot;
    @SuppressWarnings("unused")
    private String mergedTimeSlot;
    private String seatCode;
    private String status;
    private Timestamp createdAt;
    private Timestamp confirmedAt;
    private Timestamp canceledAt;
    private Timestamp checkedInAt;
    private Timestamp updatedAt;

    // Default constructor
    public StudentBookingModel() {
    }

    // Getters and Setters
    public String getBookingID() {
        return bookingID;
    }

    public void setBookingID(String bookingID) {
        this.bookingID = bookingID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(String bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(String timeSlot) {
        this.timeSlot = timeSlot;
    }

    // public String getMergedTimeSlot() {
    //     return mergedTimeSlot;
    // }

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

    public void setMergedTimeSlot(String mergedTimeSlot) {
        this.mergedTimeSlot = mergedTimeSlot;
    }

    public String getSeatCode() {
        return seatCode;
    }

    public void setSeatCode(String seatCode) {
        this.seatCode = seatCode;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getConfirmedAt() {
        return confirmedAt;
    }

    public void setConfirmedAt(Timestamp confirmedAt) {
        this.confirmedAt = confirmedAt;
    }

    public Timestamp getCanceledAt() {
        return canceledAt;
    }

    public void setCanceledAt(Timestamp canceledAt) {
        this.canceledAt = canceledAt;
    }

    public Timestamp getCheckedInAt() {
        return checkedInAt;
    }

    public void setCheckedInAt(Timestamp checkedInAt) {
        this.checkedInAt = checkedInAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}