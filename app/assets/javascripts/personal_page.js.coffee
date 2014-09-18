$(document).on "page:change", ->
  $(".a-personal").hover (->
    $(this).parent().addClass "border-none"
  ), ->
    $(this).parent().removeClass "border-none"