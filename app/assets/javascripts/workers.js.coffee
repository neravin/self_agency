$(document).on "page:change", ->
  $(".worker-ad").click -> 
    id_ad = $(this).attr('data-ad_id')
    current_el = $(this)
    $.ajax({
      type: "POST"
      url: "/worker_ad?id=" + id_ad
      data: { _method: 'get' }
      success: (result) ->
        parent = current_el.parent()
        current_el.remove()
        
        span = $ "<span>"
        span.addClass "button not-button white-green"
        span.html("Занят")
        parent.append span

        div = $ "<div>"
        div.addClass "flash"
        div.html(result)
        parent.parent().append div
        div.addClass("opacity1")
        div.slideDown(1000)
        div.delay( 5000 ).slideUp 1000, ->
          $(this).remove()
    })