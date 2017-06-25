<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Title</title>

    <link rel="stylesheet" type="text/css" href="/css/chat.css">
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

            $("#divChat").toggle();
            $("#divChatFooter").toggle();
            $("#mostrarEsconder").toggle();


            $("#mostrarEsconder").click(function () {
                $("#divChat").toggle();
                $("#divChatFooter").toggle();
            });


            $("#btn-chat").click(function () {
                webSocket.send(JSON.stringify({
                    funcionalidad: '0',
                    mensaje: $("#btn-input").val(),
                    userName: 'jhon',
                    chat: $("#chatHash").text()
                }));
                $("#btn-input").val('');
            });

            $("#btn-input").keypress(function(e) {
                if(e.which == 13) {
                    webSocket.send(JSON.stringify({
                        funcionalidad: '0',
                        mensaje: $("#btn-input").val(),
                        userName: 'jhon',
                        chat: $("#chatHash").text()
                    }));
                    $("#btn-input").val('');
                }
            });


            $("#cambiarNombre").click(function () {
                webSocket.send(JSON.stringify({
                    funcionalidad: '2',
                    userName: $("#userName").val()
                }));
            });

            $("#btn-iniciar").click(function () {
                webSocket.send(JSON.stringify({
                    funcionalidad: '1',
                    userName: $("#btn-iniciar-username").val()
                }));
                $("#divIniciar").toggle();
                $("#divChat").toggle();
                $("#divChatFooter").toggle();
                $("#mostrarEsconder").toggle();
            });

            $("#unirseChat").click(function () {
                webSocket.send(JSON.stringify({
                    funcionalidad: '3',
                    chat: $("#chat").val()
                }));
            });

            $("#salirChat").click(function () {
                webSocket.send(JSON.stringify({
                    funcionalidad: '4',
                    chat: ("#chat").val()
                }));
            });
        });

        function consultarArticulo(href) {
            $.get(href, function (data) {
                $('#articles').html(data);
            });
        }

        /**
         *
         * @param mensaje
         */
        function recibirInformacionServidor(mensaje) {
            var funcionalidad = mensaje.data.split(',')[0];
            var msg = mensaje.data.split(',')[1];
            var userName = mensaje.data.split(',')[2];
            var chat = mensaje.data.split(',')[3];

            if(funcionalidad === '0'){
                $("#ulChat").append(msg);
                $("#divChat").scrollTop($("#divChat")[0].scrollHeight);
            }else if (funcionalidad === '1'){
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

        setInterval(verificarConexion, tiempoReconectar); //para reconectar.

    </script>


</head>
<body>

<!-- Navigation -->

<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="navbar-collapse collapse container">
        <ul class="nav navbar-nav navbar-left">
            <li class="active"><a href="/article/all/0"><span class="lyphicon glyphicon glyphicon-home"></span> Home</a></li>
            <li class=""><a href="/article/create"><span class="lyphicon glyphicon glyphicon-plus"></span> New Article</a></li>
            <li class=""><a href="/chat"><span class="lyphicon glyphicon glyphicon-comment"></span> Chat</a></li>
        </ul>
        <ul class="nav navbar-nav navbar-right" style="margin-right: 10px">
            <li class=""><a href="/login" style="font-size: 1.25em">${user!"Login"}</a></li>
        </ul>
    </div>
</nav>


<!-- Page Content -->
<div class="container">
    <div class="row">

        <div class="col-md-3">
            <div class="navbar navbar-inverses  navbar-left" role="navigation">
                <ul class="nav">
                    <li class="nav-header">Sidebar</li>
                    <li class="active"><a href="#">Link</a></li>
                    <li><a href="#">Link</a></li>
                    <li><a href="#">Link</a></li>
                    <li><a href="#">Link</a></li>
                </ul>
            </div>
        </div>


        <div class="col-md-9">

            <nav aria-label="Page navigation">
            <#list pages>
                <ul class="pagination">
                    <li>
                        <a href="#" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <#items as page>
                    <#--<li><a href="/article/all/${page}">${page}</a></li>-->
                        <li><a onclick="consultarArticulo('/article/all/ajax/${page}')">${page}</a></li>
                    </#items>

                    <li>
                        <a href="#" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </#list>
            </nav>


            <h1 class="page-header">
                Articles
                <small>By Jhon</small>
            </h1>

            <div id="articles">
                <br>
                <#if articles??>
                    <#list articles as article >
                        <h2>${article.title}</h2>
                        <p class="lead">by ${article.author.userName}</p>
                        <p><span class="glyphicon glyphicon-time"></span> Posted on August ${article.releaseDate}</p>
                        <hr>
                        <#if article.body?length < 70 >
                            <p class="articleBody">${article.body}...</p>
                        <#else>
                            <p class="articleBody">${article.body?substring(0,70)}...</p>
                        </#if>
                        <a class="btn btn-primary" href="/article/view/${article.id}">Read More <span
                                class="glyphicon glyphicon-chevron-right"></span></a>

                        <#if article.tagList??>
                            <#list article.tagList>
                                <br>
                                <h5 style="display: inline;width: auto">tags: </h5>
                                <ul style="display: inline">
                                    <#items as tag>
                                        <a href="/article/all/tag/${tag.name}"><span
                                                class="label label-default">${tag.name}<#--<#sep>,</#sep>--></span></a></h3>
                                    </#items>
                                </ul>
                            </#list>
                        </#if >
                        <a href="/article/valoracion/1/${article.id}"><span
                                class="glyphicon glyphicon-thumbs-up">${article.CountValoracion(1)}</span></a>
                        <a href="/article/valoracion/0/${article.id}"><span
                                class="glyphicon glyphicon-thumbs-down">${article.CountValoracion(0)}</span></a>
                        <hr>
                    </#list>
                </#if>
            </div>
            <#--fin-->

            <!-- Pager -->
            <ul class="pager">
                <li class="previous">
                    <a href="#">&larr; Older</a>
                </li>
            </ul>


        </div>
        <!-- /.row -->

        <hr>

        <!-- Footer -->
        <footer>
            <div class="row">
                <div class="col-lg-12">
                    <p>Copyright &copy; Your Website 2014</p>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
        </footer>

    </div>
</div>
<!-- /.container -->


<#--Chat-->
<div class="panel panel-primary cuadro-chat" id="panel" >
    <div class="panel-heading">
        <span class="glyphicon glyphicon-comment"></span> Chat:<label id="chatHash"></label>

        <div class="input-group" id="divIniciar">
            <input id="btn-iniciar-username" type="text" class="form-control input-sm" placeholder="Coloque un nombre de usuario"/>
            <span class="input-group-btn">
                            <button class="btn btn-primary btn-sm" id="btn-iniciar">
                                Iniciar</button>
                        </span>
        </div>
        <div class="btn-group pull-right">
            <button id="mostrarEsconder" type="button" class="btn btn-primary btn-xs dropdown-toggle" data-toggle="dropdown">
                <span class="glyphicon glyphicon-chevron-down"></span>
            </button>
        </div>
    </div>
    <div class="panel-body" id="divChat">
        <ul class="chat" id="ulChat">




        </ul>
    </div>
    <div class="panel-footer" id="divChatFooter">
        <div class="input-group">
            <input id="btn-input" type="text" class="form-control input-sm" placeholder="Type your message here..."/>
            <span class="input-group-btn">
                            <button class="btn btn-warning btn-sm" id="btn-chat">
                                Send</button>
                        </span>
        </div>
    </div>
</div>


</body>
</html>