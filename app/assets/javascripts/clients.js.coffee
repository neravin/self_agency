ready = ->
  $(".link-offers .arrow").click ->
    post = $(this).parent().parent()
    # change size up-post
    h = post.innerHeight()
    w = post.innerWidth()
    up_post = post.children(".up-post")
    up_post.css "height", "#{h}px"
    up_post.css "width", "#{w}px"
    # visible  offers
    up_post.slideDown 1000, ->
      up_post.find(".foto").show()

  $(".link-offers-hide").click ->
    up_post = $(this).parent()
    up_post.slideUp(1000)


  # change offer's height
  # and overflow auto
  $(".open-offer").click ->
    # -- 1 part --
    # change offer's height
    # ------------
    post = $(this).parent().parent()
    upPost = post.children(".up-post")
    offers = upPost.children(".offers")
    # height upPost without padding
    hPost = post.height()
    # height arrow
    hArrow = 50
    # margin top/bottom
    hMargin = 20
    # height offers block
    hOffers = hPost - hArrow - 2*hMargin
    # change offer's height
    offers.css "height", "#{hOffers}px" 
    # -- 2 part --
    # overflow auto
    # ------------
    # count offer's blocks in #offers
    numOffer = offers.children(".offer").length
    hOffer = offers.children(".offer").height()
    hSumOffer = numOffer * hOffer;
    # delta hSumOffer
    hDeltaSumOffer = 6
    hSumOffer -= hDeltaSumOffer
    #alert "hOffers = " + hOffers + "  hSumOffer = " + hSumOffer
    if hOffers < hSumOffer
      # add scrolling
      offers.css "overflow-y", "scroll"
      offers.children(".offer").css "margin-right", "10px"
    else
      offers.css "overflow-y", "none"


$(document).ready(ready)
$(document).on('page:load', ready)