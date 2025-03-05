package model;

public class LocationData {
    private String no;
    private String thaiLink;
    private String englishLink;
    private String facultyDepartment;

    // Default constructor
    public LocationData() {}

    // Getters and setters
    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getThaiLink() {
        return thaiLink;
    }

    public void setThaiLink(String thaiLink) {
        this.thaiLink = thaiLink;
    }

    public String getEnglishLink() {
        return englishLink;
    }

    public void setEnglishLink(String englishLink) {
        this.englishLink = englishLink;
    }

    public String getFacultyDepartment() {
        return facultyDepartment;
    }

    public void setFacultyDepartment(String facultyDepartment) {
        this.facultyDepartment = facultyDepartment;
    }

    // Optional: toString method for easy debugging
    @Override
    public String toString() {
        return "LocationData{" +
                "no='" + no + '\'' +
                ", thaiLink='" + thaiLink + '\'' +
                ", englishLink='" + englishLink + '\'' +
                ", facultyDepartment='" + facultyDepartment + '\'' +
                '}';
    }
}