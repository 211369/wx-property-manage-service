package com.zyd.shiro.business.service.impl;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint("/websocket")
@Component
@Slf4j
public class WebsocketImpl {

    public static CopyOnWriteArraySet<Session> sessionSet = new CopyOnWriteArraySet<>();

    @OnOpen
    public void onOpen(Session session){
        log.info(session.getId() + "加入！当前在线人数为" + getOnlineCount());
        sessionSet.add(session);
//        groupMessage(session.getId() + "加入！当前在线人数为" + getOnlineCount());
    }

    /**
     * 在客户端与服务器端断开连接时触发
     */
    @OnClose
    public void onClose(Session session) {
        log.info(session.getId() + "连接关闭！当前在线人数为" + getOnlineCount());
        sessionSet.remove(session);
//        groupMessage(session.getId() + "连接关闭！当前在线人数为" + getOnlineCount());
    }

    /**
     * 收到客户端消息后调用的方法
     *
     * @param session
     * @param message
     */
    @OnMessage
    public void onMessage(Session session, String message) {
        log.info(session.getId() + "说" + message);
        groupMessage(session.getId() + "说" + message);
    }

    /**
     * 给某个会话发送消息
     *
     * @param session
     * @param message
     */
    public static void sendMessage(Session session, String message) {
        try {
            session.getBasicRemote().sendText(message);
        } catch (IOException e) {
            log.error(e.getMessage());
        }
    }

    /**
     * 给当前在线的人群发消息
     *
     * @param message
     */
    public void groupMessage(String message) {
        for (Session session : sessionSet) {
            sendMessage(session, message);
        }
    }

    /**
     * 获取当前连接数
     *
     * @return
     */
    public static synchronized int getOnlineCount() {
        return sessionSet.size();
    }
}
