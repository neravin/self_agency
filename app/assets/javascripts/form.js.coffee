$(document).on "page:change", ->
  $("#signin-button").click -> 
    $("#fade").show()
    $("#signin-form").show()

  $("#fade").click ->
    $("#signin-form").hide()
    $("#signup-form").hide()
    $("#passreset-form").hide()
    $("#success-message").hide()
    $("#new_advertisement").parent().hide()
    $(this).hide()

  $(".signin-link").click ->
    $(this).parent().parent().parent().hide()
    $("#signin-form").show()

  $(".signup-link").click ->
    $(this).parent().parent().parent().hide()
    $("#signup-form").show()

  $(".reset-link").click ->
    $(this).parent().parent().hide()
    $("#passreset-form").show()


  $("#new_client").on("ajax:success", (e, data, status, xhr) ->
    #$("#new_client").append xhr.responseText
    $("#signup-form").hide()
    $("#success-message").fadeIn()
    clear_value_input("#signup-form")
  ).on "ajax:error", (e, xhr, status, error) ->
    clear_errors()
    errors = xhr.responseJSON.error
    for message of errors
      switch message
        when "name" then                    add_error(errors[message], "#client_name", "#signup-name")
        when "email" then                   add_error(errors[message], "#client_email", "#signup-email")
        when "password" then                add_error(errors[message], "#client_password", "#signup-password")
        when "password_confirmation" then   add_error(errors[message], "#client_password_confirmation", "#signup-password-conf")


  $("#new_session").on("ajax:success", (e, data, status, xhr) ->
    #alert xhr.responseText
    $("#signin-form").hide()
    $("#fade").hide()
    $("#signin-menu").remove()
    $("#menu-ul").prepend "<li><a class='fa fa-user' href='/clients/#{xhr.responseText}'></a></li>"
    $("#menu-ul").prepend '<li><a class="fa fa-sign-out" data-method="delete" href="/signout" rel="nofollow"></a></li>'
  ).on "ajax:error", (e, xhr, status, error) ->
    clear_vertical_errors("#new_session")
    errors = xhr.responseJSON.error
    #alert errors
    for message of errors
      add_error_vers_vertical(errors[message], "#new_session")


  $("#new_password").on("ajax:success", (e, data, status, xhr) ->
    $("#passreset-form").hide()
    $("#fade").hide()
  ).on "ajax:error", (e, xhr, status, error) ->
    clear_vertical_errors("#new_password")
    errors = xhr.responseJSON.error
    #alert errors
    for message of errors
      add_error_vers_vertical(errors[message], "#new_password")


  $("#new_advertisement").on("ajax:success", (e, data, status, xhr) ->
    $("#new-ad-form").hide()
    $("#fade").hide()
    clear_value_input("#new-ad-form")
    advertisement = xhr.responseJSON
    #alert xhr.responseText
    $("#ad-posts").prepend " 
      <div class='post' data-ad='#{advertisement.id}'>
        <a class='edit-advertisement' href='/advertisements/#{advertisement.id}/edit' title='Изменить'>
          <i class='fa fa-pencil'></i>
        </a>      
        <h2>#{advertisement.service.name}</h2>
        <p>#{advertisement.description}</p>
        <span class='price'>#{advertisement.price} <i class='fa fa-rub' style = 'font-size: 0.9em;'></i></span>
      </div>"

  ).on "ajax:error", (e, xhr, status, error) ->
    clear_errors()
    clear_vertical_errors("#new_advertisement")
    errors = xhr.responseJSON.error

    different_errors = []
    flag_repeat = false
    for message of errors
      for i in [0...errors[message].length]
        if different_errors.length > 0
          flag_repeat = false
          for j in [0...different_errors.length]
            if different_errors[j] == errors[message][i]
              flag_repeat = true
              break
          if !flag_repeat
            different_errors.push errors[message][i]
        else
          different_errors.push errors[message][i]

    #for i in [0...different_errors.length]
    #  alert different_errors[i]

    # rename messages errors
    for i in [0...different_errors.length]
      if different_errors[i] == 'не может быть пустым'
        different_errors[i] = 'Заполните обязательные поля'
      if different_errors[i] == 'не является числом'
        different_errors[i] = 'Цена имеет неверный формат'

    # output errors in DOM
    for i in [0...different_errors.length]
      add_error_vers_vertical(different_errors[i], "#new_advertisement")

    h = $("#new_advertisement").parent().height()
    $("#new_advertisement").parent().css "margin-top", "#{-h/2}px"

    for message of errors
      switch message
        when "description" then     add_error_without_message("#advertisement_description")
        when "city" then            add_error_without_message("#advertisement_city")
        when "address" then         add_error_without_message("#advertisement_address")
        when "date" then            add_error_without_message("#advertisement_date")
        when "price" then           add_error_without_message("#advertisement_price")
        when "service_id" then      add_error_without_message(".services-select")
        when "duration" then        add_error_without_message("#advertisement_duration")

  $("#new_client").on "click", "input.error-input", ->
    $(this).removeClass("error-input")
    error_message = $(this).next()
    error_message.fadeOut ->
      error_message.remove()

  $(".two-column").on "click", "input.error-input", ->
    $(this).removeClass("error-input")

  $(".one-column").on "click", "textarea.error-input", ->
    $(this).removeClass("error-input")

  $(".one-column").on "click", ".services-select", ->
    $(this).removeClass("error-input")

  $("#client-add-advertisements").click ->
    $("#fade").show()
    h = $("#new_advertisement").parent().height()
    $("#new_advertisement").parent().css "margin-top", "#{-h/2}px"
    $("#new_advertisement").parent().show()

  $(".category-select").children(".cs-options").children().children().click ->
    id = $(this).attr("data-value")
    if $.isNumeric(id)
      id = parseInt(id)
      $.ajax({
        type: "POST"
        url: "/select_category"
        data: { id: id },
        success: (result) ->
          $("#advertisement_service_id").children().remove()
          $(".services-select").find("li").remove()
          # ul <li data-option="" data-value=""><span>Тип объявления</span></li>
          # <option value="25">Капитальный ремонт</option>
          $(".services-select").find("ul").append '<li data-option="" data-value=""><span>Тип объявления</span></li>'
          $("#advertisement_service_id").append  '<option value="">Тип объявления</option>'
          for i in [0...result.length]
            $("#advertisement_service_id").append "<option value='#{result[i]["id"]}'>#{result[i]["name"]}</option>"
            $(".services-select").find("ul").append "<li data-option='' data-value='#{result[i]["id"]}'><span>#{result[i]["name"]}</span></li>"
          $(".services-select").children(".cs-placeholder").text("Тип объявления")
      })

  $(".services-select").find("ul").on "click", "li", ->
    $(this).parent().children().removeClass("cs-selected")
    $(this).addClass("cs-selected")
    $(".services-select").removeClass("cs-active")
    $(".services-select").children(".cs-placeholder").text($(this).children().text())
    id = $(this).attr "data-value"
    $(".services-select").val(id)

add_error = (message, id_input, id_text_error) ->
  $(id_text_error).append '<div class = "error-form"><p>' + message + '</p></div>'
  $(id_input).addClass("error-input")

add_error_without_message = (id_input) ->
  $(id_input).addClass("error-input")

add_error_vers_vertical = (message, id_form) ->
  element = $(id_form).find(".error_explanation")
  element.append '<p>' + message + '</p>'
  element.show()

clear_errors = () ->
  num_errors = $('.error-input').length
  if num_errors > 0
    $('.error-form').remove()
    $('.error-input').removeClass('.error-input')

clear_vertical_errors = (id_form) ->
  num_errors = $(id_form).find(".error_explanation").length
  if num_errors > 0
    $(id_form).find('.error_explanation').children().remove()
    $(id_form).find('.error_explanation').hide()

clear_value_input = (id_form) ->
  $(id_form).find("input").not(':input[type=button], :input[type=submit], :input[type=reset]').val('')
  $(id_form).find("textarea").val('')
