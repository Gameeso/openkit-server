$ ->
  $el = $ ".lastest_news_container"
  $list = $ "<ul></ul>"
  if $el?
    $.getJSON("http://gameeso.com/api/get_recent_posts/?callback=?", (data) ->
      try
        for post in data.posts
          $html = $ "<li></li>"
          $li = $ "<a href='#{ post.url }'></a>"

          $li.addClass "linkslist"

          $li.append("<div class='post_title'><b>" + post.title + "</b> <span>#{post.date}</span></div>")
          $li.append("<p>" + post.excerpt + "</p>")

          $html.append $li
          $list.append $html

        $el.html($list)

      catch e
        console.error e
    )
