ready = ->
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
        div = $ "<div>"

        if result == 'Ожидайте звонок от заказчика'
          num_offers = parent.parent().children(".link-offers").find(".num-offers").text()
          num_offers++
          parent.parent().children(".link-offers").find(".num-offers").text(num_offers)
          div.addClass "success-message"

        div.addClass "flash"
        div.html(result)
        parent.parent().append div
        div.addClass("opacity1")
        div.slideDown(1000)
        div.delay( 5000 ).slideUp 1000, ->
          $(this).remove()
    })

  $(".hide-filter-link").click ->
    filters = $(this).parent()
    form = filters.children("form")
    $(this).hide()
    $(".show-filter-link").show()
    form.slideUp(1000)

  $(".show-filter-link").click ->
    filters = $(this).parent()
    form = filters.children("form")
    $(this).hide()
    $(".hide-filter-link").show()
    form.slideDown(1000)

  # hide/show services select
  if( $(".filters .category-select span.cs-placeholder").text() == "Категория" )
    $(".filters div.services-select").hide()
  else
    $(".filters div.services-select").show()


$(document).ready(ready)
$(document).on('page:load', ready)