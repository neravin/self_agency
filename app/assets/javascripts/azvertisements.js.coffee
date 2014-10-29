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
        block = parent.parent()
        
        if result == 'Ожидайте звонок от заказчика'
          num_offers = block.children(".link-offers").find(".num-offers").text()
          num_offers++
          block.children(".link-offers").find(".num-offers").text(num_offers)

        addMessage(block, result, 'Ожидайте звонок от заказчика')
    })

  $(".cancel-worker").click -> 
    id_ad = $(this).parents(".post").attr('data-ad')
    current_el = $(this)

    if confirm("Вы уверены?") 
      $.ajax({
      type: "POST"
      url: "/worker_cancel?ad=" + id_ad
      data: { _method: 'get' }
      success: (result) ->
        parent = current_el.parent()
        block = parent.parent()
        addMessage(block, result, 'Исполнитель отменен')
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

  $(".link-agree").click ->
    upPost     = $(this).parents(".up-post")
    linkClient = $(this).parent().children(".name")
    idBuilder  = linkClient.attr("href").match(/clients\/([0-9]+)/)[1]
    idAdv      = $(this).parents(".post").attr "data-ad"
    if confirm("Вы уверены?") 
      $.ajax({
        type: 'POST'
        url: "/advertisements/agree_order"
        data: { client_id: idBuilder, adv_id: idAdv }
        success: (result) ->
          addMessage(upPost, result, 'Спасибо, исполнитель определен')
      })

  #  hide/show services select
  if( $(".filters .category-select span.cs-placeholder").text() == "Категория" )
    $(".filters div.services-select").hide()
  else
    $(".filters div.services-select").show()


addMessage = (block, message, successMessage) ->
  #  block - where to place advertisements
  #  successMessage - text
  #  message - received text
  messageDiv = $ "<div>"
  if message == successMessage
    messageDiv.addClass "success-message"

  messageDiv.addClass "flash"
  messageDiv.html(message)
  block.append messageDiv
  messageDiv.addClass("opacity1")
  messageDiv.slideDown(1000)
  messageDiv.delay( 3000 ).slideDown 1000, ->
    $(this).remove()

$(document).ready(ready)
$(document).on('page:load', ready)