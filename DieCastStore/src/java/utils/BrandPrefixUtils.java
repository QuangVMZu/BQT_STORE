
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author hqthi
 */
public class BrandPrefixUtils {

    private static final Map<String, String> BRAND_PREFIX_MAP = new HashMap<>();

    static {
        BRAND_PREFIX_MAP.put("MiniGT", "MGT");
        BRAND_PREFIX_MAP.put("Hot Wheels", "HW");
        BRAND_PREFIX_MAP.put("Bburago", "BBR");
        BRAND_PREFIX_MAP.put("Maisto", "MST");
        BRAND_PREFIX_MAP.put("Tomica", "TMC");
        BRAND_PREFIX_MAP.put("AutoArt", "AAT");
        BRAND_PREFIX_MAP.put("GreenLight", "GL");
        BRAND_PREFIX_MAP.put("Kyosho", "KYO");
        BRAND_PREFIX_MAP.put("Matchbox", "MTB");
        BRAND_PREFIX_MAP.put("Welly", "WLY");

    }

    public static String getPrefix(String brandName) {
        return BRAND_PREFIX_MAP.getOrDefault(brandName, "NB");
    }
}
