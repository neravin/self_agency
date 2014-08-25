$(document).on "page:change", ->
  $(".head").click -> 
    fade_element = $(this).parents('.category-flower').children("#list-awesome")
    if fade_element.length == 1
      $("#fade").show()
      fade_element.show()

  $("#fade").click ->
    $("#list-awesome").hide()
    $(this).hide()
