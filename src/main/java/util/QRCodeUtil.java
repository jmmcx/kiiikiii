package util;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class QRCodeUtil {
    private static final Logger logger = LogManager.getLogger(QRCodeUtil.class);
    
    public static String generateQRCode(String content, int width, int height) {
        if (content == null || content.trim().isEmpty()) {
            logger.warn("Content cannot be empty");
            throw new IllegalArgumentException("Content cannot be empty");
        }

        try {
            // debug
            //logger.debug("Link generated to QR Code: " + content);
            // Configure QR code parameters
            Map<EncodeHintType, Object> hints = new HashMap<>();
            hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
            hints.put(EncodeHintType.MARGIN, 1);
            hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");

            // Create QR code
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrCodeWriter.encode(
                content.trim(),
                BarcodeFormat.QR_CODE,
                width,
                height,
                hints
            );
            
            // Convert to image
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            MatrixToImageWriter.writeToStream(bitMatrix, "PNG", outputStream);
            
            // Convert to Base64
            byte[] imageBytes = outputStream.toByteArray();
            return Base64.getEncoder().encodeToString(imageBytes);
            
        } catch (WriterException | IOException e) {
            e.printStackTrace();
            logger.error("Failed to generate QR code", e.getMessage());
            throw new RuntimeException("Failed to generate QR code: " + e.getMessage());
        }
    }
}