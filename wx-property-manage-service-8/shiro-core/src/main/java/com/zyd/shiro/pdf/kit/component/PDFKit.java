package com.zyd.shiro.pdf.kit.component;

import com.itextpdf.text.Document;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.tool.xml.XMLWorkerHelper;
import com.zyd.shiro.pdf.STSongFont;
import com.zyd.shiro.pdf.kit.exception.PDFException;
import com.zyd.shiro.pdf.kit.util.FreeMarkerUtil;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.xhtmlrenderer.pdf.ITextRenderer;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.charset.Charset;

@Slf4j
public class PDFKit {

    private String saveFilePath;

    /**
     * @description     导出pdf到文件
     * @param fileName  输出PDF文件名
     * @param data      模板所需要的数据
     *
     */
    public String exportToFile(String fileName,Object data){

        String htmlData= FreeMarkerUtil.getContent(fileName, data);
        if(StringUtils.isEmpty(saveFilePath)){        	
            //saveFilePath=getDefaultSavePath(fileName);
            saveFilePath = "d:/temp.pdf";
        }
        File file=new File(saveFilePath);
        if(!file.getParentFile().exists()){
            file.getParentFile().mkdirs();
        }
        FileOutputStream outputStream=null;
        try{
            //设置输出路径
            outputStream=new FileOutputStream(saveFilePath);
            //设置文档大小
            Document document = new Document(PageSize.A4);
            PdfWriter writer = PdfWriter.getInstance(document, outputStream);
            
            //输出为PDF文件
            convertToPDF(writer,document,htmlData);
        }catch(Exception ex){
            throw new PDFException("PDF export to File fail",ex);
        }finally{
            IOUtils.closeQuietly(outputStream);
        }
        return saveFilePath;

    }

    /**
     * 生成PDF到输出流中（ServletOutputStream用于下载PDF）
     * @param ftlPath ftl模板文件的路径（不含文件名）
     * @param data 输入到FTL中的数据
     * @param response HttpServletResponse
     * @return
     */
    public  OutputStream exportToResponse(String ftlPath,Object data,
                                                     HttpServletResponse response){

        String html= FreeMarkerUtil.getContent(ftlPath,data);

        try{
            OutputStream out = null;
            ITextRenderer render = null;
            out = response.getOutputStream();
            //设置文档大小
            Document document = new Document(PageSize.A4);
            PdfWriter writer = PdfWriter.getInstance(document, out);

            //输出为PDF文件
            convertToPDF(writer,document,html);
            return out;
        }catch (Exception ex){
            throw  new PDFException("PDF export to response fail",ex);
        }

    }

    /**
     * @description PDF文件生成
     */
    private  void convertToPDF(PdfWriter writer,Document document,String htmlString){
        //获取字体路径
        document.open();
        try {
            XMLWorkerHelper.getInstance().parseXHtml(writer,document,
                    new ByteArrayInputStream(htmlString.getBytes()),                   
                    Charset.forName("UTF-8"),new STSongFont());
        } catch (IOException e) {
            e.printStackTrace();
            throw new PDFException("PDF文件生成异常",e);
        }finally {
            document.close();
        }

    }
    /**
     * @description 创建默认保存路径
     */
    private  String  getDefaultSavePath(String fileName){
        String classpath=PDFKit.class.getClassLoader().getResource("").getPath();
    	//String classpath=this.getClass().getResource("").getPath();
        String saveFilePath=classpath+"templates/pdftemps/"+fileName;
        File f=new File(saveFilePath);
        if(!f.getParentFile().exists()){
            f.mkdirs();
        }
        return saveFilePath;
    }


    public String getSaveFilePath() {
        return saveFilePath;
    }

    public void setSaveFilePath(String saveFilePath) {
        this.saveFilePath = saveFilePath;
    }

}