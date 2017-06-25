package edu.pucmm.websocket;

import org.eclipse.jetty.websocket.api.Session;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import static j2html.TagCreator.*;

/**
 * Created by Jhon on 21/6/2017.
 */

public class Chat {
    private String chatHash;
    private Set<Usuario> usuarios;

    public Set<Usuario> getUsuarios() {
        return usuarios;
    }

    public void setUsuarios(Set<Usuario> usuarios) {
        this.usuarios = usuarios;
    }

    public Chat() {
        this.usuarios = new HashSet<Usuario>();
        this.chatHash = ""+this.hashCode();
    }

    public String getChatHash() {
        return chatHash;
    }

    public void setChatHash(String chatHash) {
        this.chatHash = chatHash;
    }

    public void enviarMensaje(Usuario sender, String mensaje) {
        usuarios.stream()
                .filter(usuarios -> !usuarios.getUserName().equalsIgnoreCase(sender.getUserName()))
                .forEach(usuarios -> {
                    try {
                        String msg = "0," + Chat.chatMessage(sender.getUserName(), "15 min ago", mensaje, false) + "," + this.hashCode();
                        usuarios.getSession().getRemote().sendString(msg);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                });

        try {
            String msg = "0," + Chat.chatMessage(sender.getUserName(), "15 ago", mensaje, true) + "," + this.hashCode();
            sender.getSession().getRemote().sendString(msg);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    public boolean entrarChat(Usuario usuario) {
        for (Usuario user :
                usuarios) {
            if (usuario.getUserName().equalsIgnoreCase(user.getUserName())) {
                return false;
            }
        }
        return usuarios.add(usuario);
    }

    public boolean salirChat(Usuario usuario) {
        return usuarios.remove(usuario);
    }

    public boolean salirChat(Session usuario) {
        for (Usuario user: usuarios) {
            if (user.getSession()==usuario){
                return usuarios.remove(user);
            }
        }
        return false;
    }

    public int candidadUsuarios() {
        return usuarios.size();
    }

    public Usuario getUsuario(String userName) {
        for (Usuario user :
                usuarios) {
            if (user.getUserName().equalsIgnoreCase(userName))
                return user;
        }
        return null;
    }

    public Usuario getUsuario(Session session) {
        for (Usuario user :
                usuarios) {
            if (user.getSession().hashCode() == session.hashCode())
                return user;
        }
        return null;
    }

    @Override
    public String toString() {
        return "Chat{" +
                "usuarios=" + usuarios +
                '}';
    }

    public static String chatMessage(String userName, String time, String message, boolean yourself) {
        if (!yourself) {

            return
                    li(

                            span(
                                    img()
                                            .withClass("img-circle")
                                            .attr("alt", "User Avatar")
                                            .attr("src", "http://placehold.it/50/55C1E7/fff&text=U")
                            ).withClass("chat-img pull-left"),
                            div(
                                    div(
                                            strong(userName).withClass("primary-font"),
                                            small(
                                                    span(time).withClass("glyphicon glyphicon-time")
                                            ).withClass("pull-right text-muted")
                                    ).withClass("header"),
                                    p(message)
                            ).withClass("chat-body clearfix")
                    ).withClass("left clearfix").render();

        } else {
            return li(

                    span(
                            img()
                                    .withClass("img-circle")
                                    .attr("alt", "User Avatar")
                                    .attr("src", "http://placehold.it/50/FA6F57/fff&text=ME")
                    ).withClass("chat-img pull-right"),
                    div(
                            div(
                                    small(
                                            span(time).withClass("glyphicon glyphicon-time")
                                    ).withClass("text-muted"),
                                    strong(userName).withClass("pull-right primary-font")
                            ).withClass("header"),
                            p(message)
                    ).withClass("chat-body clearfix")
            ).withClass("right clearfix").render();
        }

    }


}
