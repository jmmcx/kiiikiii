package util;

import java.util.Locale;
import java.util.ResourceBundle;
//<%@ page import="util.LanguageUtil" %>



public class LanguageUtil {
    public static String getMessage(String key, String lang) {
        Locale locale = Locale.forLanguageTag(lang);
        ResourceBundle bundle = ResourceBundle.getBundle("messages", locale);
        return bundle.getString(key);
    }
}

