package com.zyd.shiro.pdf;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactoryImp;
import com.itextpdf.text.pdf.BaseFont;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * itext字体工具类.
 */
public class STSongFont extends FontFactoryImp {

    private static final Logger logger = LoggerFactory.getLogger(STSongFont.class);

    protected BaseFont baseFont = null;

    public STSongFont() {
        try {
            baseFont = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
    }


    @Override
    public Font getFont(String fontName, String encoding, boolean embedded, float size, int style, BaseColor color, boolean cached) {
        return new Font(baseFont, size, style, color);
    }
}