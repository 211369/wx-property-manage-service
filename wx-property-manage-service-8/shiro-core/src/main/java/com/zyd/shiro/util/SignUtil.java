package com.zyd.shiro.util;

import static com.zyd.shiro.util.IPayUtil.base64Encode;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;

import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.Signature;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public class SignUtil {

    private static String publicKey = SDKConfig.getConfig().getIpayPublicKey();

    public static boolean checkSign(Map<String, String> map) throws Exception {
        String signStr = map.get("sign");
        //验签公钥
        String content = IPayUtil.getSignContent(map, "sign");
        //验签
        boolean result = IPayUtil.rsa256CheckContent(content, signStr, publicKey);
        return result;
    }

    /**
     * @param data
     * @param key
     * @return
     * @throws Exception
     */
    public static String generateSignature(Map<String, String> data, String key) throws Exception {
        String stringData = getSignContent(data, "sign");
        return rsa256Sign(stringData, key);
    }

    /**
     * @param sortedParams
     * @param values
     * @return
     */
    public static String getSignContent(Map<String, String> sortedParams, String... values) {
        for (String value : values) {
            sortedParams.remove(value);
        }
        StringBuffer content = new StringBuffer();
        List<String> keys = new ArrayList<String>(sortedParams.keySet());
        Collections.sort(keys);
        int index = 0;
        for (int i = 0; i < keys.size(); i++) {
            String key = keys.get(i);
            String value = sortedParams.get(key);
            if (StringUtils.isNotBlank(key)
                    && StringUtils.isNotBlank(value)) {
                content.append((index == 0 ? "" : "&") + key + "=" + value);
                ++index;
            }
        }
        String stringData = content.toString();
        IPayUtil.getLogger().info("待签名或验签内容 : " + stringData);
        return stringData;
    }

    /**
     * @param content
     * @param key
     * @return
     * @throws Exception
     */
    protected static String rsa256Sign(String content, String key) throws Exception {
        try {
            IPayUtil.getLogger().info("私钥字符串： " + key);
            PrivateKey priKey = restorePrivateKey(Base64.decodeBase64(key));
            Signature signature = Signature.getInstance(IPayConstants.SHA256withRSA);
            signature.initSign(priKey);
            signature.update(content.getBytes(IPayConstants.CHARSET_UTF_8));
            byte[] signed = signature.sign();
            String sign = new String(base64Encode(signed), IPayConstants.CHARSET_UTF_8);
            IPayUtil.getLogger().info("生成签名sign : " + sign);
            return sign;
        } catch (Exception e) {
            throw new RuntimeException("RSAcontent = " + content + "; charset = " + IPayConstants.CHARSET_UTF_8, e);
        }
    }

    /**
     * 还原私钥
     *
     * @param keyBytes
     * @return
     */
    public static PrivateKey restorePrivateKey(byte[] keyBytes) {
        PKCS8EncodedKeySpec pkcs8EncodedKeySpec = new PKCS8EncodedKeySpec(
                keyBytes);
        try {
            KeyFactory factory = KeyFactory.getInstance(IPayConstants.KEY_ALGORITHM);
            PrivateKey privateKey = factory
                    .generatePrivate(pkcs8EncodedKeySpec);
            return privateKey;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
