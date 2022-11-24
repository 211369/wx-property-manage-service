package com.zyd.shiro.util;

import com.alibaba.fastjson.JSONObject;
import org.apache.commons.codec.binary.Base64;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.AlgorithmParameters;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.Security;
import java.security.spec.InvalidParameterSpecException;
import java.util.Arrays;

public class SecretUtil {

    public static String decrypt(String data, String key, String iv, String encodingFormat){
        byte[] dataByte = Base64.decodeBase64(data);
        byte[] keyByte = Base64.decodeBase64(key);
        byte[] ivByte = Base64.decodeBase64(iv);
        int base = 16;
        if (keyByte.length % base != 0) {
            int groups = keyByte.length / base + (keyByte.length % base != 0 ? 1 : 0);
            byte[] temp = new byte[groups * base];
            Arrays.fill(temp, (byte)0);
            System.arraycopy(keyByte, 0, temp, 0, keyByte.length);
            keyByte = temp;
        }

        try {
            Security.addProvider(new BouncyCastleProvider());
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS7Padding", "BC");
            SecretKeySpec spec = new SecretKeySpec(keyByte, "AES");
            AlgorithmParameters parameters = AlgorithmParameters.getInstance("AES");
            parameters.init(new IvParameterSpec(ivByte));
            cipher.init(2, spec, parameters);
            byte[] resultByte = cipher.doFinal(dataByte);
            if (null != resultByte && resultByte.length > 0) {
                String result = new String(resultByte, encodingFormat);
                return result;
            }

            return null;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public static String decrypt2(String encryptData, String key, String iv, String encodingFormat){
        java.util.Base64.Decoder decoder=java.util.Base64.getDecoder();
        String telephone="";
        try{
            Cipher cipher=Cipher.getInstance("AES/CBC/PKCS5Padding");
            Key sKeySpec = new SecretKeySpec(decoder.decode(key),"AES");
            cipher.init(Cipher.DECRYPT_MODE,sKeySpec,generateIv(decoder.decode(iv)));
            byte[] data=cipher.doFinal(decoder.decode(encryptData));
            String dadaist=new String(data, StandardCharsets.UTF_8);
            JSONObject obj=JSONObject.parseObject(dadaist);
            telephone=obj.get("phoneNumber").toString();
            return telephone;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return telephone;
    }
    private static AlgorithmParameters generateIv(byte[] iv) throws NoSuchAlgorithmException, InvalidParameterSpecException{
        AlgorithmParameters params=AlgorithmParameters.getInstance("AES");
        params.init(new IvParameterSpec(iv));
        return  params;
    }
}
