package com.zyd.shiro.pdf;

import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Image;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfGState;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;
import org.springframework.util.ResourceUtils;
import org.apache.commons.io.IOUtils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.net.URL;

import static java.util.Objects.isNull;


public class PdfWaterMarker {

    private PdfWaterMarker() {
    }

    /**
     * <pre>
     * 为 pdf 文档添加水印图片, 如添加签章. 该方法需要一个 {@link WaterMarker} 对象. 可以设置图片的一些属性, 其中图片在 pdf 中显示的位置有如下的规则
     * 1、如果不设置, 默认图片显示在右下角；
     * 2、可以自定义设置图片距离左边线和上边线的百分比距离
     * 3、可以设置绝对位置
     * </pre>
     *
     * @param inPdfFile   需要添加水印的图片路径
     * @param outPdfFile  添加水印之后的文件路径
     * @param password    待添加水印图片的密码
     * @param waterMarker 水印图片对象
     * @throws Exception Exception
     */
    public static void markImgToPdf(String inPdfFile, File outPdfFile, String password, WaterMarker waterMarker) {
        try {
            markImgToPdf(ResourceUtils.getURL(inPdfFile), outPdfFile, password, waterMarker);
        } catch (FileNotFoundException e) {
            throw new IllegalStateException("can not convert.", e);
        }
    }

    public static void markImgToPdf(URL inPdfFile, File outPdfFile, String password, WaterMarker waterMarker) {
        try {
            PdfReader reader;
            if (isNull(password) || password.isEmpty()) {
                reader = new PdfReader(inPdfFile);
            } else {
                reader = new PdfReader(inPdfFile, password.getBytes());
            }
            // 获取 pdf 文档的高度宽度, 直接取第一页的高宽
            Rectangle pageSize = reader.getPageSize(1);
            // 考虑 PDF 的横竖方向
            float pdfWidth = reader.getPageRotation(1) == 90 ? pageSize.getHeight() : pageSize.getWidth();
            float pdfHeight = reader.getPageRotation(1) == 90 ? pageSize.getWidth() : pageSize.getHeight();
            PdfStamper pdfStamper = new PdfStamper(reader, new FileOutputStream(outPdfFile));
            PdfGState pdfState = new PdfGState();
            // 透明度
            pdfState.setFillOpacity(waterMarker.getOpacity());
            byte[] imgBytes;
            try (FileInputStream inputStream = new FileInputStream(waterMarker.getFile())) {
                imgBytes = IOUtils.toByteArray(inputStream);
            }
            Image img = Image.getInstance(imgBytes);
            setImage(waterMarker, pdfWidth, pdfHeight, img);
            // 对pdf页添加图片水印
            int pageNum = reader.getNumberOfPages();
            if (waterMarker.isEachPage()) {
                addTemplate1(waterMarker, pdfStamper, pdfState, img, pageNum);
            } else if (waterMarker.getAssignPage() != null && waterMarker.getAssignPage().length > 0) {
                addTemplate2(waterMarker, pdfStamper, pdfState, img, pageNum);
            } else {
                // 只在最后一页显示
                PdfContentByte template = waterMarker.isBelowContent() ? pdfStamper.getUnderContent(pageNum) : pdfStamper.getOverContent(pageNum);
                // 图片水印 透明度
                template.setGState(pdfState);
                // 图片水印
                template.addImage(img);
            }
            pdfStamper.close();
            reader.close();
        } catch (Exception e) {
            throw new IllegalStateException("can not convert.", e);
        }
    }

    private static void addTemplate2(WaterMarker waterMarker, PdfStamper pdfStamper, PdfGState pdfState, Image img, int pageNum) throws DocumentException {
        for (int index : waterMarker.getAssignPage()) {
            // 如果设置的页码大于pdf的页码了直接跳过
            if (index > pageNum || index <= 0) {
                continue;
            }
            PdfContentByte template = waterMarker.isBelowContent() ? pdfStamper.getUnderContent(index) : pdfStamper.getOverContent(index);
            // 图片水印 透明度
            template.setGState(pdfState);
            // 图片水印
            template.addImage(img);
        }
    }

    private static void addTemplate1(WaterMarker waterMarker, PdfStamper pdfStamper, PdfGState pdfState, Image img, int pageNum) throws DocumentException {
        for (int i = 1; i <= pageNum; i++) {
            PdfContentByte template = waterMarker.isBelowContent() ? pdfStamper.getUnderContent(i) : pdfStamper.getOverContent(i);
            // 图片水印 透明度
            template.setGState(pdfState);
            // 图片水印
            template.addImage(img);
        }
    }

    private static void setImage(WaterMarker waterMarker, float pdfWidth, float pdfHeight, Image img) {
        // 自定义高宽和缩放
        if (waterMarker.getCustomWidth() != 0 && waterMarker.getCustomHeight() != 0) {
            img.scaleAbsolute(waterMarker.getCustomWidth(), waterMarker.getCustomHeight());
        }
        if (waterMarker.getScale() != 100.0f) {
            img.scalePercent(waterMarker.getScale());
        }
        // 设置位置，不设置默认在右下角
        float positionX = pdfWidth - img.getScaledWidth();
        float positionY = 0.0f;
        // 如果采用百分比的形式，那么图片将以左上角为原点，两个百分比分别表示距离左边线和顶部边线的百分比值，并且是图片中心点距离边线的百分比
        // 即如果设置图片距离边线的百分比都为50，那么图片的中心刚好在文档的中心
        if (waterMarker.getAwayFromLeftPercent() != 0.0f && waterMarker.getAwayFromTopPercent() != 0.0f) {
            positionX = pdfWidth * (waterMarker.getAwayFromLeftPercent() / 100) - img.getScaledWidth() / 2;
            positionY = pdfHeight - (pdfHeight * (waterMarker.getAwayFromTopPercent() / 100)) - img.getScaledHeight() / 2;
        } else if (waterMarker.getPositionX() > 0.0f && waterMarker.getPositionY() > 0.0f) {
            // 将左下角当作坐标轴的原点
            positionX = waterMarker.getPositionX();
            positionY = waterMarker.getPositionY();
        }
        positionX = positionX > pdfWidth ? pdfWidth - img.getScaledWidth() : positionX;
        positionY = positionY > pdfHeight ? pdfHeight - img.getScaledHeight() : positionY;
        // 设置图片实例, 设置旋转, 反转角度等
        img.setAbsolutePosition(positionX, positionY);
        img.setRotation(waterMarker.getRotation());
        img.setRotationDegrees(waterMarker.getRotationDegrees());
    }

}
