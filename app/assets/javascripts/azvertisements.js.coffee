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

  #$(".cancel-worker").click -> 
  #  cancelWorker($(this))

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

  #$(".link-agree").click ->
  #  agreeWorker($(this))
  
  $(".offer").on "click", "span.cancel-worker", ->
    cancelWorker($(this))

  $(".offer").on "click", "span.link-agree", ->
    agreeWorker($(this))

  #  hide/show services select
  if( $(".filters .category-select span.cs-placeholder").text() == "Категория" )
    $(".filters div.services-select").hide()
  else
    $(".filters div.services-select").show()

cancelWorker = (el) ->
  id_ad = el.parents(".post").attr('data-ad')
  upPost = el.parents(".up-post")

  #if confirm("Вы уверены?") 
  $.ajax({
    type: "POST"
    url: "/worker_cancel?ad=" + id_ad
    data: { _method: 'get' }
    success: (result) ->
      alert "cancel"
      block = upPost
      block.find(".cancel-worker").remove()
      block.find(".offer").append "<span class = 'button blue-dashed link-agree'>Принять</span>"
      #block.find(".offer").on "click", "span.link-agree", ->
      #  agreeWorker($(this))
      addMessage(block, result, 'Исполнитель отменен')
  })

agreeWorker = (el) ->
  upPost     = el.parents(".up-post")
  linkClient = el.parent().children(".name")
  idBuilder  = linkClient.attr("href").match(/clients\/([0-9]+)/)[1]
  idAdv      = el.parents(".post").attr "data-ad"
  offer      = el.parent()
  #if confirm("Вы уверены?") 
  $.ajax({
    type: 'POST'
    url: "/agree_order"
    data: { client_id: idBuilder, adv_id: idAdv }
    success: (result) ->
      alert "agree"
      upPost.find(".link-agree").remove()

      offer.append "<span class = 'button blue-dashed cancel-worker'>Отменить</span>"
      #upPost.find(".offer").on "click", "span.cancel-worker", ->
      #  cancelWorker($(this))
      addMessage(upPost, result, 'Спасибо, исполнитель определен')
  })

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