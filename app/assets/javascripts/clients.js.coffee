$(document).on "page:change", ->
  $(".cancel-worker").click -> 
    id_ad = $(this).parent().parent().attr('data-ad')
    current_el = $(this)

    if confirm("Вы уверены?") 
      $.ajax({
      type: "POST"
      url: "/worker_cancel?ad=" + id_ad
      data: { _method: 'get' }
      success: (result) ->
        parent = current_el.parent()

        if result == 'Исполнитель отменен'
          parent.remove()
        
        div = $ "<div>"
        div.addClass "flash"
        div.html(result)
        parent.parent().append div
        div.addClass("opacity1")
        div.slideDown(1000)
        div.delay( 5000 ).slideUp 1000, ->
          $(this).remove()
      })
  
  $(".link-offers .arrow").click ->
    post = $(this).parent().parent()
    # change size up-post
    h = post.innerHeight()
    w = post.innerWidth()
    up_post = post.children(".up-post")
    up_post.css "height", "#{h}px"
    up_post.css "width", "#{w}px"
    # visible  offers
    up_post.slideDown(1000)

  $(".link-offers-hide").click ->
    up_post = $(this).parent()
    up_post.slideUp(1000)