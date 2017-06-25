package edu.pucmm.websocket;

import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import edu.pucmm.main.Main;
import org.eclipse.jetty.websocket.api.Session;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketClose;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketConnect;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketMessage;
import org.eclipse.jetty.websocket.api.annotations.WebSocket;

import java.io.IOException;


/**
 * Representa la clase para enviar información desde el servidor al cliente.
 * Created by vacax on 06/06/16.
 */
@WebSocket
public class ServidorMensajesWebSocketHandler {

    /**
     * Una vez conectado el cliente se activa este metodo.
     * @param usuario
     */
    @OnWebSocketConnect
    public void conectando(Session usuario){
        System.out.println("Conectando Usuario: "+usuario.getLocalAddress().getAddress().toString());
        Main.usuariosConectados.add(usuario);
        Usuario user = new Usuario(usuario,"");
        Main.usuariosLibres.add(user);
        Main.usuarios.add(user);
    }

    /**
     * Una vez cerrado la conexión, es ejecutado el metodo anotado
     * @param usuario
     * @param statusCode
     * @param reason
     */
    @OnWebSocketClose
    public void cerrandoConexion(Session usuario, int statusCode, String reason) {
        System.out.println("Desconectando el usuario: "+usuario.getLocalAddress().getAddress().toString());
        Main.usuariosConectados.remove(usuario);
        Main.usuariosLibres.remove(usuario);
        Main.usuarios.remove(usuario);
        int size = Main.chats.size();
        for (int i=0;i<size;i++){
            Main.chats.get(i).salirChat(usuario);
        }
        for (int i=0;i<size;i++){
            if (Main.chats.get(i).getUsuarios().size() == 0){
                Main.chats.remove(Main.chats.get(i));
                return;
            }
        }



        System.out.println(Main.chats);
    }

    /**
     * Una vez recibido un mensaje es llamado el metodo anotado.
     * @param session
     * @param message
     */
    @OnWebSocketMessage
    public void recibiendoMensaje(Session session, String message) {
        JsonElement jelement = new JsonParser().parse(message);
        int funcionalidad = jelement.getAsJsonObject().get("funcionalidad").getAsInt();
        Usuario usuario =null;
        String mensaje="";
        int chatHastCode;
        String userName ="";
        System.out.println("Mensaje full: "+message);
        System.out.println("funcionalidad :"+funcionalidad);
        switch (funcionalidad){
            case 0://Enviar Mensaje
                System.out.println("Case 0");
                mensaje = jelement.getAsJsonObject().get("mensaje").getAsString();
                chatHastCode = jelement.getAsJsonObject().get("chat").getAsInt();
                usuario = obtenerUsuario(session);
                System.out.println("chatHastCode:"+chatHastCode);
                if (usuario !=null){
                    enviarMensaje(usuario,mensaje,chatHastCode);
                }else{
                    System.err.println("El usuario no esta creado");
                }
            break;
            case 1://Iniciar Chat
                System.out.println("Case 1");
                userName = jelement.getAsJsonObject().get("userName").getAsString();
                cambiarUserName(session,userName);

                usuario = obtenerUsuario(session);
                if (usuario !=null){
                    iniciarChat(usuario);
                }else{
                    System.err.println("El usuario no esta creado");
                }
            break;
            case 2://Cambiar Nombre
                System.out.println("Case 2");
                userName = jelement.getAsJsonObject().get("userName").getAsString();
                cambiarUserName(session,userName);
            break;
            case 3://Unirse a un Chat
                System.out.println("Case 3");
                usuario = obtenerUsuario(session);
                chatHastCode = jelement.getAsJsonObject().get("chat").getAsInt();
                unirseChat(usuario,chatHastCode);
            break;
            case 4:// unirse a todos los chat
                System.out.println("Case 4");
                usuario = obtenerUsuario(session);
                for (Chat chat: Main.chats ) {
                    unirseChat(usuario,chat.hashCode());
                }
            break;
        }

        /*try {
            //Enviar un simple mensaje al cliente que mando al servidor..
            usuario.getRemote().sendString("Mensaje enviado al Servidor: "+message);
            //mostrando a todos los clientes
            Main.enviarMensajeAClientesConectados(message, "azul");
            System.out.println(usuario.hashCode());
        } catch (IOException e) {
            e.printStackTrace();
        }*/
    }


    public boolean cambiarUserName(Session usuario,String userName){

        Usuario user = obtenerUsuario(usuario);
        if (user !=null){
            user.setUserName(userName);
            System.out.println("usuario cambiado"+user);
            System.out.println(Main.usuariosLibres.size());
            System.out.println(Main.usuarios.size());
            return true;
        }
        System.out.println("No se encontro el usuario");
        return false;

    }

    public boolean iniciarChat(Usuario usuario){
        Chat chat = new Chat();
        boolean entro = chat.entrarChat(usuario);
        if (entro){
            entro = Main.chats.add(chat);
            try {
                usuario.getSession().getRemote().sendString("1,,,"+chat.hashCode());
            } catch (IOException e) {
                e.printStackTrace();
            }


            return entro;
        }else{
            return false;
        }

    }

    public boolean unirseChat(Usuario usuario,int chatHastCode){
        Chat chat = obtenerChat(chatHastCode);
        if (chat != null){
            chat.entrarChat(usuario);
            return true;
        }
        return false;
    }

    public boolean salirChat(int chatHastCode){
        return true;
    }

    public boolean enviarMensaje(Usuario user,String mensaje, int chatHastCode){
        if (obtenerChat(chatHastCode) !=null){
            obtenerChat(chatHastCode).enviarMensaje(user,mensaje);
            System.out.println("se envio");
            return true;
        }
        System.out.println("no se envio");
        return false;
    }

    public Usuario obtenerUsuario(Session session){
        for (Usuario user:Main.usuarios) {
            if (user.getSession().hashCode()==session.hashCode()){
                return user;
            }
        }
        return null;
    }


    public Chat obtenerChat(int chatHashCode){
        for (Chat chat:Main.chats) {
            if (chat.hashCode()==chatHashCode){
                return chat;
            }
        }
        return null;
    }

}
