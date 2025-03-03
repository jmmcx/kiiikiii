package model;

import java.util.ArrayList;
import java.util.List;

public class SelectedItemsModel {
    private static List<TransactionModel> selectedItems = new ArrayList<>();
    
    public static void addItem(TransactionModel item) {
        selectedItems.add(item);
    }
    
    public static void removeItem(TransactionModel item) {
        selectedItems.removeIf(i -> i.getSerialNumber().equals(item.getSerialNumber()));
    }
    
    public static List<TransactionModel> getSelectedItems() {
        return selectedItems;
    }
    
    public static void clearItems() {
        selectedItems.clear();
    }
}