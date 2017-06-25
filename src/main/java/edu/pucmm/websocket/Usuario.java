package edu.pucmm.websocket;

import org.eclipse.jetty.websocket.api.Session;

/**
 * Created by Jhon on 21/6/2017.
 */
public class Usuario {
    private Session session;
    private String userName;

    public Usuario(Session session, String userName) {
        this.session = session;
        this.userName = userName;
    }

    public Session getSession() {
        return session;
    }

    public void setSession(Session session) {
        this.session = session;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    @Override
    public String toString() {
        return "Usuario{" +
                "session=" + session.hashCode() +
                ", userName='" + userName + '\'' +
                '}';
    }
}
