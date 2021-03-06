<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Title</title>

    <link rel="stylesheet" type="text/css" href="/css/chat-room.css">
    <link rel="stylesheet" type="text/css" href="/css/bootstrap.css">
    <link rel="stylesheet" type="text/css" href="/css/blog-home.css">
    <script src="/js/bootstrap.js"></script>
    <script src="/js/jquery-3.2.1.min.js"></script>

    <script>
        //abriendo el objeto para el websocket
        var webSocket;
        var tiempoReconectar = 5000;

        $(document).ready(function () {
            console.info("Iniciando Jquery -  Ejemplo WebServices");
            conectar();

            /*$("#btn-chat").click(function () {
                webSocket.send(JSON.stringify({
                    funcionalidad: '0',
                    mensaje: $("#btn-input").val(),
                    userName: 'jhon',
                    chat: $("#chatHash").text()
                }));
                $("#btn-input").val('');
            });

            $("#btn-input").keypress(function (e) {
                if (e.which == 13) {
                    webSocket.send(JSON.stringify({
                        funcionalidad: '0',
                        mensaje: $("#btn-input").val(),
                        userName: 'jhon',
                        chat: $("#chatHash").text()
                    }));
                    $("#btn-input").val('');
                }
            });
*/


        });



        function consultarArticulo(href) {
            $.get(href, function (data) {
                $('#articles').html(data);
            });
        }

        function buscarChat(chatHash) {
            $('#panel-'+chatHash).toggle();
        }


        /**
         *
         * @param mensaje
         */
        function recibirInformacionServidor(mensaje) {
            var funcionalidad = mensaje.data.split(',')[0];
            var msg = mensaje.data.split(',')[1];
            var chat = mensaje.data.split(',')[2];

            if (funcionalidad === '0') {
                $('#ulChat-'+chat).append(msg);
                $("#divChat").scrollTop($("#divChat")[0].scrollHeight);
            } else if (funcionalidad === '1') {
                $("#chatHash").text(chat);
            }

        }

        function conectar() {
            webSocket = new WebSocket("ws://" + location.hostname + ":" + location.port + "/mensajeServidor");

            //indicando los eventos:
            webSocket.onmessage = function (data) {
                recibirInformacionServidor(data);
            };
            webSocket.onopen = function (e) {
                console.log("Conectado - status " + this.readyState);
            };
            webSocket.onclose = function (e) {
                console.log("Desconectado - status " + this.readyState);
            };
        }

        function verificarConexion() {
            if (!webSocket || webSocket.readyState == 3) {
                conectar();
            }
        }

        function enviar(chatHash){
            webSocket.send(JSON.stringify({
                funcionalidad: '0',
                mensaje: $("#btn-input-"+chatHash).val(),
                userName: 'jhon',
                chat: chatHash
            }));
            $("#btn-input-"+chatHash).val('');
        }

        function chat() {
            if (!(!webSocket || webSocket.readyState == 3)) {
                try {
                    webSocket.send(JSON.stringify({
                        funcionalidad: '2',
                        userName: '${userName}'
                    }));

                }
                catch(err) {
                    alert(err)
                }

                try {
                    webSocket.send(JSON.stringify({
                        funcionalidad: '4'
                    }));
                }
                catch(err) {
                    alert(err)
                }
            }
        }

        setInterval(verificarConexion, tiempoReconectar); //para reconectar.
        setTimeout(chat, 4000);

    </script>


</head>
<body>

<div class="list-group">
    <a class="list-group-item active">
        Usuarios en linea
    </a>
<#list chats as chat >
    <a onclick="buscarChat(${chat.chatHash})" class="list-group-item">chat: ${chat.chatHash}</a>
</#list>
</div>

<#list chats as chat >
<script>
    $("#panel-${chat.chatHash}").toggle();
</script>
<div class="panel panel-primary cuadro-chat" id="panel-${chat.chatHash}">
    <div class="panel-heading">
        <span class="glyphicon glyphicon-comment"></span> Chat:<label id="${chat.chatHash}">${chat.chatHash}</label>
    </div>
    <div class="panel-body" id="divChat">
        <ul class="chat" id="ulChat-${chat.chatHash}">

        </ul>
    </div>
    <div class="panel-footer" id="divChatFooter">
        <div class="input-group">
            <input id="btn-input-${chat.chatHash}" type="text" class="form-control input-sm" placeholder="Type your message here..."/>
            <span class="input-group-btn">
                            <button class="btn btn-warning btn-sm" id="btn-chat" onclick="enviar(${chat.chatHash})">
                                Send</button>
                        </span>
        </div>
    </div>
</div>

</#list>

</body>
</html>