package com.zyd.shiro.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.zyd.shiro.util.NumberToCNUtil;
import org.apache.commons.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.github.pagehelper.PageInfo;
import com.itextpdf.text.DocumentException;
//import com.zyd.shiro.QRcode.QRcodeUtil;
import com.zyd.shiro.business.entity.BillDetailDTO;
import com.zyd.shiro.business.entity.BillInfo;
import com.zyd.shiro.business.entity.BillItem;
import com.zyd.shiro.business.entity.PropertyQryBill;
import com.zyd.shiro.business.service.BillService;
import com.zyd.shiro.pdf.PdfWaterMarker;
import com.zyd.shiro.pdf.WaterMarker;
import com.zyd.shiro.pdf.WaterMarker.MarkerBuilder;
import com.zyd.shiro.pdf.kit.component.PDFKit;

import freemarker.template.TemplateException;

/**
 * 凭证预览（加印章）
 * @author 210343
 *
 */
@RestController
public class PdfController {
	
	 @Autowired
	 private BillService billService;
    
    /**
     * pdf文件预览
     * @param request
     * @param response
     * @return
     * @throws IOException
     */
    @GetMapping("/pdf/reviewPdf")
    public void reviewPdf(String orderId,HttpServletRequest request, HttpServletResponse response) throws Exception, TemplateException, DocumentException {
    	 // pdf数据
        /*Map<String, Object> pdfData = buildPdfData(orderId);
        
        String classpath=this.getClass().getClassLoader().getResource("").getPath();
        String path=classpath+"templates/pdftemps/";
        
        pdfData.put("path", path);
        // 模版位置
        PDFKit kit = new PDFKit();
        kit.exportToFile("temp.pdf",pdfData);
        
        
        File file = new File("d:/temp.pdf");
        
        QRcodeUtil.createQRcode(orderId, 60, 60, "jpg", path+"qrImg.jpg");
        
        PdfWaterMarker.markImgToPdf(file.getAbsolutePath(), file, null, new WaterMarker(new MarkerBuilder()
																			        		.file(new File(path+"1.jpg"))
																							.filePath(path+"1.jpg"))
        																	);
        PdfWaterMarker.markImgToPdf(file.getAbsolutePath(), file, null, new WaterMarker(new MarkerBuilder()
        																.file(new File(path+"qrImg.jpg"))
        																.filePath(path+"qrImg.jpg")
        																.awayFromLeftPercent(90)
        																.awayFromTopPercent(3)       															
        																));
    	
       // 获取pdf文件路径（包括文件名）
       String tempPrintPdfFile = "d:/temp.pdf";

       FileInputStream inStream = new FileInputStream(tempPrintPdfFile);

       // 设置输出的格式
       response.setContentType( "application/pdf");

       OutputStream outputStream= response.getOutputStream();
       int count = 0;
       byte[] buffer = new byte[1024 * 1024];
       while ((count =inStream.read(buffer)) != -1){
          outputStream.write(buffer, 0,count);
       }
       outputStream.flush();*/
    }


    /**
     * 构造pdf模板数据
     * @return
     */
    @GetMapping("/pdf/buildPdfData")
    private Map<String, Object> buildPdfData(String orderId) {
        Map<String, Object> pdfData = new HashMap<>();
        PropertyQryBill qry = new PropertyQryBill();
        qry.setOrderId(orderId);
        PageInfo<BillDetailDTO> result = billService.queryFinancial(qry);
        List<BillDetailDTO> list = result.getList();
        //生成二维码
        //String classpath=this.getClass().getClassLoader().getResource("").getPath();
        //String classpath = PdfController.class.getClassLoader().getResource("").getPath();
        //String path=classpath+"templates/pdftemps/";
        //QRcodeUtil.createQRcode(orderId, 80, 80, "jpg", classpath+"templates/pdftemps/qrImg.jpg");
        
        //pdfData.put("img", getImageStr("templates/pdftemps/qrImg.jpg"));
        
        if(list !=null && list.size()>0) {
        	BillDetailDTO data = list.get(0);
        	BillInfo info = data.getBillInfo();
        	pdfData.put("orderId", info.getOrderId());
        	pdfData.put("ownerName", info.getOwnerName());
        	pdfData.put("house", info.getHouse());
        	pdfData.put("payTime", info.getPayTime());
        	pdfData.put("paySum", info.getPaySum());
        	pdfData.put("payType", info.getPayType());
        	pdfData.put("receiveName", info.getReceiveName());
            pdfData.put("remark", info.getRemark());
            pdfData.put("paySumCn", NumberToCNUtil.number2CNMontrayUnit(info.getPaySum()));
        	
        	Map<String,List<BillItem>> map = data.getItems();
        	List<Map<String, Object>> dataList = new ArrayList<Map<String, Object>>();
        	//Double discountSum = 0.0;
        	BigDecimal discountSum = new BigDecimal(0);
        	for(String key : map.keySet()){
    	       List<BillItem> items = map.get(key);    	
    	       if(items != null && items.size() > 0) {
    	    	   for(BillItem item : items) {
    	    		   Map<String, Object> bill = new HashMap<String, Object>();
    	    		   if (null == item.getLicensePlateNo()){
                           bill.put("costName", item.getCostName());
                       }else {
                           bill.put("costName", item.getCostName()+"("+item.getLicensePlateNo()+")");
                       }
                       bill.put("costType", item.getCostType());
                       bill.put("costTypeClass", item.getCostTypeClass());
                       bill.put("costTypeSection", item.getCostTypeSection());
    	    		   bill.put("orderTime", item.getBeginTime()+"~"+item.getEndTime());
    	    		   bill.put("area", item.getArea()==null?0:item.getArea());
    	    		   if(item.getDiscount() !=null) {
    	    		       bill.put("discountRate",item.getDiscountRate());
    	    			   bill.put("discount", item.getDiscount());
    	    			   //discountSum +=item.getDiscount();
    	    			   discountSum = discountSum.add(new BigDecimal(Double.toString(item.getDiscount())));
    	    		   }
    	    		   bill.put("unit", item.getUnit());
    	    		   bill.put("pay", item.getPay());
    	    		   dataList.add(bill);
    	    	   }
    	    	   
    	       }
    	    }
        	
        	pdfData.put("data", dataList);
        	pdfData.put("time", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        	pdfData.put("amount", info.getPaySum().add(discountSum));
        	pdfData.put("discountSum", discountSum);
        	pdfData.put("payer", info.getOwnerName());
        }

        return pdfData;
    }

    /**
     * 图片转化成base64字符串,返回的string可以直接在src上显示
     * @param file   图片文件路径
     * @return
     */
    public static String getImageStr(String file) {
        String fileContentBase64 = null;
        String base64Str = "";
        String content = null;
        //将图片文件转化为字节数组字符串，并对其进行Base64编码处理
        InputStream in = null;
        byte[] data = null;
        //读取图片字节数组
        try {
            //in = new FileInputStream(file);
        	in = PdfController.class.getResourceAsStream(file);
            data = new byte[in.available()];
            in.read(data);
            in.close();
            //对字节数组Base64编码
            if (data == null || data.length == 0) {
                return null;
            }
            content = Base64.encodeBase64String(data);
            if (content == null || "".equals(content)) {
                return null;
            }
            fileContentBase64 = base64Str + content;
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (in != null) {
                try {
					in.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
            }
        }
        return fileContentBase64;
    }

}