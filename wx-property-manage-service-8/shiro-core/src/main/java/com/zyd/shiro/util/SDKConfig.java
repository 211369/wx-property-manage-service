package com.zyd.shiro.util;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import org.apache.commons.lang3.StringUtils;
/**
 *
 * @ClassName SDKConfig
 * @Description 配置文件tsdk.properties配置信息类
 *              声明：以下代码只是为了方便接入方测试而提供的样例代码，商户可以根据自己需要，按照技术文档编写。该代码仅供参考，不提供编码，性能，规范性等方面的保障
 */
public class SDKConfig {

    public static final String FILE_NAME = "ipay.properties";

    /**
     * 定义常量
     */
    /** 易收宝商户号 */
    public static final String IPAY_MCHNT_CD = "ipay.mchnt_cd";
    /** 商户私钥 */
    public static final String IPAY_PRIVATEKEY = "ipay.privateKey";
    /** 易收宝公钥 */
    public static final String IPAY_PUBLICKEY = "ipay.publicKey";
    /** 易收宝接口地址 */
    public static final String IPAY_URL = "ipay.url";
    /** 易收宝接口地址 */
    public static final String IPAY_NOTIFY_URL = "ipay.notify_url";

    /**
     * 定义属性
     */
    private static String ipayMchntCd;
    private static String ipayPrivateKey;
    private static String ipayPublicKey;
    private static String ipayUrl;
    private static String ipayNotifyUrl;

    public String getIpayMchntCd() {
        return ipayMchntCd;
    }
    public String getIpayPrivateKey() {
        return ipayPrivateKey;
    }
    public String getIpayPublicKey() {
        return ipayPublicKey;
    }
    public String getIpayUrl(){
        return ipayUrl;
    }
    public String getIpayNotifyUrl(){
        return ipayNotifyUrl;
    }


    /** 操作对象. */
    private static SDKConfig config = new SDKConfig();
    /** 属性文件对象. */
    private static Properties properties;

    private SDKConfig() {
        super();
    }

    /**
     * 获取config对象.
     *
     * @return
     */
    public static SDKConfig getConfig() {
        if (properties == null) {
            synchronized (SDKConfig.class) {
                if (properties == null) {
                    loadPropertiesFromSrc();
                }
            }
        }
        return config;
    }

    /**
     * 从classpath路径下加载配置参数
     */
    public static void loadPropertiesFromSrc() {
        InputStream in = null;
        try {
            IPayUtil.getLogger().info("从classpath: " + SDKConfig.class.getClassLoader().getResource("").getPath()
                    + " 获取属性文件" + FILE_NAME);
            in = SDKConfig.class.getClassLoader().getResourceAsStream(FILE_NAME);
            if (null != in) {
                properties = new Properties();
                try {
                    properties.load(in);
                } catch (IOException e) {
                    throw e;
                }
            } else {
                IPayUtil.getLogger().error(FILE_NAME + "属性文件未能在classpath指定的目录下 "
                        + SDKConfig.class.getClassLoader().getResource("").getPath() + " 找到!");
                return;
            }
            loadProperties(properties);
        } catch (IOException e) {
            IPayUtil.getLogger().error(e.getMessage(), e);
        } finally {
            if (null != in) {
                try {
                    in.close();
                } catch (IOException e) {
                    IPayUtil.getLogger().error(e.getMessage(), e);
                }
            }
        }
    }

    /**
     * 根据传入的 {@link #( Properties)}对象设置配置参数
     *
     * @param pro
     */
    public static void loadProperties(Properties pro) {
        IPayUtil.getLogger().info("开始从属性文件中加载配置项;");
        String value = null;

        value = pro.getProperty(IPAY_MCHNT_CD);
        if (StringUtils.isNotBlank(value)) {
            ipayMchntCd = value.trim();
        }
        IPayUtil.getLogger().info("配置项：易收宝商户号==>" + IPAY_MCHNT_CD + "==>" + value + " 已加载;");

        value = pro.getProperty(IPAY_PRIVATEKEY);
        if (StringUtils.isNotBlank(value)) {
            ipayPrivateKey = value.trim();
        }
        IPayUtil.getLogger().info("配置项：商户私钥==>" + IPAY_PRIVATEKEY + "==>" + value + " 已加载;");

        value = pro.getProperty(IPAY_PUBLICKEY);
        if (StringUtils.isNotBlank(value)) {
            ipayPublicKey = value.trim();
        }
        IPayUtil.getLogger().info("配置项：易收宝公钥==>" + IPAY_PUBLICKEY + "==>" + value + " 已加载");

        value = pro.getProperty(IPAY_URL);
        if (StringUtils.isNotBlank(value)) {
            ipayUrl = value.trim();
        }
        IPayUtil.getLogger().info("配置项：易收宝接口地址==>" + IPAY_URL + "==>" + value + " 已加载");

        value = pro.getProperty(IPAY_NOTIFY_URL);
        if (StringUtils.isNotBlank(value)) {
            ipayNotifyUrl = value.trim();
        }
        IPayUtil.getLogger().info("配置项：易收宝异步通知地址==>" + IPAY_NOTIFY_URL + "==>" + value + " 已加载");
    }
}
