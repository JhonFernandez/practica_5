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