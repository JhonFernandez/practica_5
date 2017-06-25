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

    <script>

        $(document).ready(function () {
            //console.log('Inicio');
            //setInterval(consultarFechaServidor, 1000); //Cada un segundo..
        });

        /**
         * Busca la fecha del servidor y la visualiza en el ID indicado.
         */
        function consultarArticulo(href) {
            $.get(href, function (data) {
                var init = data.indexOf("<div id=\"articles\">");
                var text = data.substring(init);
                var fin = text.indexOf("</div>");

                fin = init + fin + 6;
                $('#ajax').html(data.substring(init, fin));
            });

        }

    </script>


</head>
<body>

<!-- Navigation -->

<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="navbar-collapse collapse container">
        <ul class="nav navbar-nav navbar-left">
            <li class="active"><a href="/article/all/0"><span class="lyphicon glyphicon glyphicon-home"></span> Home</a>
            </li>
            <li class=""><a href="/article/create"><span class="lyphicon glyphicon glyphicon-plus"></span> New
                Article</a></li>
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
                        <li><a onclick="consultarArticulo('/article/all/${page}')">${page}</a></li>
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
            <div id="ajax">
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

<div class="panel panel-primary cuadro-chat">

    <#--header del chat-->
    <div class="panel-heading">
        <span class="glyphicon glyphicon-comment"></span> Chat
        <div class="btn-group pull-right">
            <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown">
                <span class="glyphicon glyphicon-chevron-down"></span>
            </button>
            <ul class="dropdown-menu slidedown">
                <li><a href="#"><span class="glyphicon glyphicon-refresh">
                            </span>Actualizar Nombre</a></li>
            </ul>
        </div>
    </div>

    <#--Body del panel-->
    <div class="panel-body">
        <ul class="chat">
            <li class="left clearfix"><span class="chat-img pull-left">
                            <img src="http://placehold.it/50/55C1E7/fff&text=U" alt="User Avatar" class="img-circle"/>
                        </span>
                <div class="chat-body clearfix">
                    <div class="header">
                        <strong class="primary-font">Jack Sparrow</strong>
                        <small class="pull-right text-muted">
                            <span class="glyphicon glyphicon-time"></span>14 mins ago
                        </small>
                    </div>
                    <p>
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur bibendum ornare
                        dolor, quis ullamcorper ligula sodales.
                    </p>
                </div>
            </li>
            <li class="right clearfix"><span class="chat-img pull-right">
                            <img src="http://placehold.it/50/FA6F57/fff&text=ME" alt="User Avatar" class="img-circle"/>
                        </span>
                <div class="chat-body clearfix">
                    <div class="header">
                        <small class=" text-muted"><span class="glyphicon glyphicon-time"></span>15 mins ago</small>
                        <strong class="pull-right primary-font">Bhaumik Patel</strong>
                    </div>
                    <p>
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur bibendum ornare
                        dolor, quis ullamcorper ligula sodales.
                    </p>
                </div>
            </li>
        </ul>
    </div>

    <#--footer del chat-->
    <div class="panel-footer">
        <div class="input-group">
            <input id="btn-input" type="text" class="form-control input-sm" placeholder="Type your message here..."/>
            <span class="input-group-btn">
                            <button class="btn btn-warning btn-sm" id="btn-chat">
                                Send</button>
                        </span>
        </div>
    </div>

</div>



<script src="/js/vendor/jquery.min.js"></script>
<script src="/js/bootstrap.js"></script>
</body>
</html>