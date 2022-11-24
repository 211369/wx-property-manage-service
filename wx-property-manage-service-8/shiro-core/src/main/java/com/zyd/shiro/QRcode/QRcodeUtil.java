//package com.zyd.shiro.QRcode;
//
//import java.io.File;
//import java.io.IOException;
//import java.util.Hashtable;
//import com.google.zxing.BarcodeFormat;
//import com.google.zxing.EncodeHintType;
//import com.google.zxing.MultiFormatWriter;
//import com.google.zxing.WriterException;
//import com.google.zxing.client.j2se.MatrixToImageWriter;
//import com.google.zxing.common.BitMatrix;
//
//public class QRcodeUtil {
//	/**
//	 * @param content 二维码内容
//	 * @param width   二维码图片的宽度
//	 * @param height  二维码图片的高度
//	 * @param format  二维码图片的格式
//	 * @param path    二维码写入的路径
//	 */
//	public static void createQRcode(String content,int width,int height,String format,String file){
//
//		Hashtable<EncodeHintType, String> hints = new Hashtable<EncodeHintType, String>();
//		// 设置字符编码
//		hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
//		//创建二维码模型
//		try {
//			// 生成二维码
//			BitMatrix bitMatrix = new MultiFormatWriter().encode(content, BarcodeFormat.QR_CODE, width, height, hints);
//			bitMatrix = updateBit(bitMatrix,5);
//			MatrixToImageWriter.writeToPath(bitMatrix, format, new File(file).toPath());
//		} catch (IOException e) {
//			e.printStackTrace();
//		} catch (WriterException e) {
//			e.printStackTrace();
//		}
//	}
//
//	 public static BitMatrix updateBit(BitMatrix matrix, int margin){
//        int tempM = margin*2;
//        int[] rec = matrix.getEnclosingRectangle();   //获取二维码图案的属性
//        int resWidth = rec[2] + tempM;
//        int resHeight = rec[3] + tempM;
//        BitMatrix resMatrix = new BitMatrix(resWidth, resHeight); // 按照自定义边框生成新的BitMatrix
//        resMatrix.clear();
//        for(int i= margin; i < resWidth- margin; i++){   //循环，将二维码图案绘制到新的bitMatrix中
//            for(int j=margin; j < resHeight-margin; j++){
//                if(matrix.get(i-margin + rec[0], j-margin + rec[1])){
//                    resMatrix.set(i,j);
//                }
//            }
//        }
//         return resMatrix;
//    }
//
//	/**
//	 * @param content 二维码内容
//	 * @param format  二维码图片的格式
//	 * @param path    二维码写入的路径
//	 */
//	public static void createQRcodeDefaultSize(String content,String format,String file){
//		createQRcode(content, 300, 300, format, file);
//	}
//	/**
//	 * @param content 二维码内容
//	 * @param path    二维码写入的路径
//	 */
//	public static void createPngQRcodeDefaultSize(String content,String file){
//		createQRcodeDefaultSize(content, "png", file);
//	}
//	/**
//	 * @param content 二维码内容
//	 * @param path    二维码写入的路径
//	 * @param width   二维码图片的宽度
//	 * @param height  二维码图片的高度
//	 */
//	public static void createPngQRcode(String content,String file,int width,int height){
//		createQRcode(content, width, height, "png", file);
//	}
//}
