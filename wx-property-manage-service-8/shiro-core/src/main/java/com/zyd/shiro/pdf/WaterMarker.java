package com.zyd.shiro.pdf;

import java.io.File;

/**
 * 
 * 水印图片
 *
 */
public class WaterMarker {

    /**
     * 文件路径
     */
    private final String filePath;

    /**
     * 水印图片的 File 对象
     */
    private final File file;

    /**
     * 水印图片在 pdf 每页的横坐标, 不设置默认在右下角
     */
    private final float positionX;

    /**
     * 水印图片在 pdf 每页的纵坐标
     */
    private final float positionY;

    /**
     * 图片的透明度
     */
    private final float opacity;

    /**
     * 旋转角度
     */
    private final float rotation;

    /**
     * 翻转角度
     */
    private final float rotationDegrees;

    /**
     * 自定义缩放
     */
    private final float scale;

    /**
     * 自定义宽度
     */
    private final float customWidth;

    /**
     * 自定义高度
     */
    private final float customHeight;

    /**
     * 是否在每页显示. 如果不指定每页显示, 也不指定在哪些页面展示默认在最后一页展示
     */
    private final boolean eachPage;

    /**
     * 在指定页面显示
     */
    private final int[] assignPage;

    /**
     * 是否水印在内容下面, 默认 false
     */
    private final boolean belowContent;

    /**
     * 距离左边线的百分比
     */
    private final float awayFromLeftPercent;

    /**
     * 距离顶部边线的百分比
     */
    private final float awayFromTopPercent;

    public static MarkerBuilder builder() {
        return new MarkerBuilder();
    }

    public WaterMarker(MarkerBuilder builder) {
        this.positionX = builder.positionX;
        this.rotation = builder.rotation;
        this.customHeight = builder.customHeight;
        this.eachPage = builder.eachPage;
        this.file = builder.file;
        this.positionY = builder.positionY;
        this.rotationDegrees = builder.rotationDegrees;
        this.filePath = builder.filePath;
        this.assignPage = builder.assignPage;
        this.customWidth = builder.customWidth;
        this.opacity = builder.opacity;
        this.scale = builder.scale;
        this.belowContent = builder.belowContent;
        this.awayFromLeftPercent = builder.awayFromLeftPercent;
        this.awayFromTopPercent = builder.awayFromTopPercent;
    }

    public String getFilePath() {
        return filePath;
    }

    public File getFile() {
        return file;
    }

    public float getPositionX() {
        return positionX;
    }

    public float getPositionY() {
        return positionY;
    }

    public float getRotation() {
        return rotation;
    }

    public float getRotationDegrees() {
        return rotationDegrees;
    }

    public float getScale() {
        return scale;
    }

    public float getCustomWidth() {
        return customWidth;
    }

    public float getCustomHeight() {
        return customHeight;
    }

    public boolean isEachPage() {
        return eachPage;
    }

    public int[] getAssignPage() {
        return assignPage;
    }

    public float getOpacity() {
        return opacity;
    }

    public boolean isBelowContent() {
        return belowContent;
    }

    public float getAwayFromLeftPercent() {
        return awayFromLeftPercent;
    }

    public float getAwayFromTopPercent() {
        return awayFromTopPercent;
    }

    public static final class MarkerBuilder {
        private String filePath;
        private File file;
        private float positionX = 0.0f;
        private float positionY = 0.0f;
        private float opacity = 1.0f;
        private float rotation = 0.0f;
        private float rotationDegrees = 0.0f;
        private float customWidth;
        private float customHeight;
        private boolean eachPage = Boolean.FALSE;
        private int[] assignPage;
        private float scale = 100.0f;
        private boolean belowContent = Boolean.FALSE;
        private float awayFromLeftPercent;
        private float awayFromTopPercent;

        public MarkerBuilder() {
        }

        public MarkerBuilder awayFromLeftPercent(float awayFromLeftPercent) {
            this.awayFromLeftPercent = awayFromLeftPercent;
            return this;
        }

        public MarkerBuilder awayFromTopPercent(float awayFromTopPercent) {
            this.awayFromTopPercent = awayFromTopPercent;
            return this;
        }

        public MarkerBuilder filePath(String filePath) {
            this.filePath = filePath;
            return this;
        }

        public MarkerBuilder file(File file) {
            this.file = file;
            return this;
        }

        public MarkerBuilder positionX(float positionX) {
            this.positionX = positionX;
            return this;
        }

        public MarkerBuilder positionY(float positionY) {
            this.positionY = positionY;
            return this;
        }

        public MarkerBuilder opacity(float opacity) {
            this.opacity = opacity;
            return this;
        }


        public MarkerBuilder rotation(float rotation) {
            this.rotation = rotation;
            return this;
        }

        public MarkerBuilder rotationDegrees(float rotationDegrees) {
            this.rotationDegrees = rotationDegrees;
            return this;
        }

        public MarkerBuilder scale(float scale) {
            this.scale = scale;
            return this;
        }

        public MarkerBuilder customWidth(float customWidth) {
            this.customWidth = customWidth;
            return this;
        }

        public MarkerBuilder customHeight(float customHeight) {
            this.customHeight = customHeight;
            return this;
        }

        public MarkerBuilder eachPage(boolean eachPage) {
            this.eachPage = eachPage;
            return this;
        }

        public MarkerBuilder assignPage(int[] assignPage) {
            this.assignPage = assignPage;
            return this;
        }

        public MarkerBuilder belowContent(boolean belowContent) {
            this.belowContent = belowContent;
            return this;
        }

        public WaterMarker build() {
            if ((filePath == null || filePath.isEmpty()) && file == null) {
                throw new IllegalArgumentException("Must assign file path or file");
            }
            if (file == null) {
                file = new File(filePath);
                if (!file.exists() || file.isDirectory()) {
                    throw new IllegalStateException("The mark image file does not exists or its an directory");
                }
            }
            if (opacity < 0.0f || opacity > 1.0f) {
                throw new IllegalArgumentException("The opacity must between 0.0f and 1.0f");
            }
            if (scale <= 0) {
                throw new IllegalArgumentException("The scale must greater than zero");
            }
            return new WaterMarker(this);
        }

    }

}
