package edu.pucmm.websocket;

import org.eclipse.jetty.websocket.api.Session;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by Jhon on 21/6/2017.
 */

public class Chat {

    public Set<Usuario> usuarios;

    public Chat() {
        this.usuarios =  new HashSet<Usuario>();
    }

    public void enviarMensaje(Usuario sender,String mensaje){
        usuarios.stream()
                .filter(usuarios -> usuarios.getUserName().equalsIgnoreCase(sender.getUserName()))
                .forEach(usuarios -> {
                    try{
                        usuarios.getSession().getRemote().sendString(mensaje);
                    }catch (Exception e){
                        e.printStackTrace();
                    }
                });
    }

    public boolean entrarChat(Usuario usuario){
        for (Usuario user:
             usuarios) {
            if (usuario.getUserName().equalsIgnoreCase(user.getUserName())){
                return false;
            }
        }
        return usuarios.add(usuario);
    }

    public boolean salirChat(Usuario usuario){
        return usuarios.remove(usuario);
    }

    public int candidadUsuarios(){
        return usuarios.size();
    }

    public Usuario getUsuario(String userName){
        for (Usuario user:
             usuarios) {
            if (user.getUserName().equalsIgnoreCase(userName))
                return user;
        }
        return null;
    }

    public Usuario getUsuario(Session session){
        for (Usuario user:
                usuarios) {
            if (user.getSession().hashCode()==session.hashCode())
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
}
