package model;

public class LocationsModel {
    private int place_id;
    private String place_thai;
    private String place_english;
    private Float place_lat;
    private Float place_long;
    private String place_zone;

    // boolean
    // Constructor for ItemModel
    public LocationsModel(int place_id, String place_thai, String place_english, Float place_lat, Float place_long, String place_zone) {
        this.place_id = place_id;
        this.place_thai = place_thai;
        this.place_english = place_english;
        this.place_lat = place_lat;
        this.place_long = place_long;
        this.place_zone = place_zone;

    }

    // Getters and Setters
    public int getPlace_id() {
        return place_id;
    }

    public String getPlace_thai() {
        return place_thai;
    }

    public String getPlace_english() {
        return place_english;
    }

    public float getPlace_lat() {
        return place_lat;
    }

    public float getPlace_long() {
        return place_long;
    }

    public String getPlace_zone() {
        return place_zone;
    }


    public void setPlace_id(int place_id) {
        this.place_id = place_id;
    }

    public void setPlace_thai(String place_thai) {
        this.place_thai = place_thai;
    }

    public void setPlace_english(String place_english) {
        this.place_english = place_english;
    }

    public void setPlace_lat(Float place_lat) {
        this.place_lat = place_lat;
    }

    public void setPlace_long(Float place_long) {
        this.place_long = place_long;
    }

    public void setPlace_zone(String place_zone) {
        this.place_zone = place_zone;
    }

}
