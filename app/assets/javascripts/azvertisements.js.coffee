$(document).on "page:change", ->
  $(".perform-ad").click -> 
    id_ad = $(this).attr('data-ad_id')
    current_el = $(this)
    $.ajax({
      type: "POST"
      url: "/perform_ad?id=" + id_ad
      data: { _method: 'get' }
      success: (result) ->
        parent = current_el.parent()

        #if result == 'Объявление забронировано. Ожидайте звонок от заказчика'
        #  current_el.remove()
        #  span = $ "<span>"
        #  span.addClass "button not-button"
        #  span.html("Занят")
        #  parent.append span

        if result == 'Ожидайте звонок от заказчика'
          num_offers = parseInt(parent.children(".num_offers").text())
          num_offers++
          parent.children(".num_offers").text(num_offers)

        div = $ "<div>"
        div.addClass "flash"
        div.html(result)
        parent.parent().append div
        div.addClass("opacity1")
        div.slideDown(1000)
        div.delay( 5000 ).slideUp 1000, ->
          $(this).remove()
    })