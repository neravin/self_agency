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
    $("#edit_advertisement").parent().hide()
    $("#new_worker").parent().hide()
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


  $("#new_worker").on("ajax:success", (e, data, status, xhr) -> 
    $("#new-worker-form").hide()
    $("#fade").hide()
    clear_value_input("#new-worker-form")
    worker = xhr.responseJSON
    $("#worker-posts").prepend " 
      <div class='post' data-ad='#{worker.id}'>
        <a class='edit-advertisement' href='/workers/#{worker.id}/edit' title='Изменить'>
          <i class='fa fa-pencil'></i>
        </a>      
        <h2>#{worker.service.category.name}: #{worker.service.name}</h2>
        <p>#{worker.description}</p>
        <span class='price'>#{worker.price} <i class='fa fa-rub' style = 'font-size: 0.9em;'></i></span>
      </div>"
  ).on "ajax:error", (e, xhr, status, error) ->
    clear_errors()
    clear_vertical_errors("#new_worker")
    errors = xhr.responseJSON.error
    different_errors = get_different_errors(errors)
    output_dif_errors("#new_worker", different_errors)

    # change height form
    h = $("#new_worker").parent().height()
    $("#new_worker").parent().css "margin-top", "#{-h/2}px"

    for message of errors
      switch message
        when "description" then     add_error_without_message("#worker_description")
        when "city" then            add_error_without_message("#worker_city")
        when "address" then         add_error_without_message("#worker_address")
        when "price" then           add_error_without_message("#worker_price")
        when "service_id" then      add_error_without_message("#new_worker .services-select")

  $("#new_advertisement").on("ajax:success", (e, data, status, xhr) ->
    $("#new-ad-form").hide()
    $("#fade").hide()
    clear_value_input("#new-ad-form")
    advertisement = xhr.responseJSON
    #alert xhr.responseText
    $("#ad-posts").prepend " 
      <div class='post' data-ad='#{advertisement.id}'>
        <span  class = 'edit-ad-link edit-advertisement'>
          <i class='fa fa-pencil'></i>
        </span>
        <h2>
          <span class = 'category' data-cat = '#{advertisement.service.category.id}'>
            #{advertisement.service.category.name}</span>:
          <span class = 'service' data-service = '#{advertisement.service.id}'>
            #{advertisement.service.name}
          </span>
        </h2>

        <p>#{advertisement.description}</p>

        <div class = 'duration'>
          <span class = 'duration-ad' >#{advertisement.duration}</span><br/>дней
        </div>

        <div class='contact clearfix'> 
          <div>
            <span class = 'label'>Город:</span>
            <span class = 'city'>#{advertisement.city}</span>
          </div>
          <div>
            <span class = 'label'>Адрес:</span>
            <span class = 'address'>#{advertisement.address}</span>
          </div>
          <div class = 'date'>
            #{convert_date_rus(advertisement.date)}
          </div>
        </div><!--/contact-->

        <span class='price'>#{advertisement.price} <i class='fa fa-rub' style = 'font-size: 0.9em;'></i></span>
        <br>
      </div>"
  ).on "ajax:error", (e, xhr, status, error) ->
    clear_errors()
    clear_vertical_errors("#new_advertisement")
    errors = xhr.responseJSON.error
    different_errors = get_different_errors(errors)
    output_dif_errors("#new_advertisement", different_errors)
    #for i in [0...different_errors.length]
    #  alert different_errors[i]

    # change height form
    h = $("#new_advertisement").parent().height()
    $("#new_advertisement").parent().css "margin-top", "#{-h/2}px"

    for message of errors
      switch message
        when "description" then     add_error_without_message("#advertisement_description")
        when "city" then            add_error_without_message("#advertisement_city")
        when "address" then         add_error_without_message("#advertisement_address")
        when "date" then            add_error_without_message("#advertisement_date")
        when "price" then           add_error_without_message("#advertisement_price")
        when "service_id" then      add_error_without_message("#new_advertisement .services-select")
        when "duration" then        add_error_without_message("#advertisement_duration")


  $("#ad-posts").on "click", ".edit-ad-link", ->
    $("#fade").show()
    h = $("#edit_advertisement").parent().height()
    $("#edit_advertisement").parent().css "margin-top", "#{-h/2}px"
    parse_ad($(this).parent())
    output_in_form("#edit_advertisement")
    $("#edit_advertisement").parent().show()

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

  $(".edit-ad-link").click ->
    $("#fade").show()
    h = $("#edit_advertisement").parent().height()
    $("#edit_advertisement").parent().css "margin-top", "#{-h/2}px"
    parse_ad($(this).parent())
    output_in_form("#edit_advertisement")
    $("#edit_advertisement").parent().show()

  select_category_ajax("#new_advertisement")
  select_category_ajax("#new_worker")
  select_category_ajax("#edit_advertisement")

  $("#client-add-workers").click -> 
    $("#fade").show()
    h = $("#new_worker").parent().height()
    $('#new_worker').parent().css "margin-top", "#{-h/2}px"
    $("#new_worker").parent().show()

select_category_ajax = (form_id) ->
  $("#{form_id} .category-select").children(".cs-options").children().children().click ->
    id = $(this).attr("data-value")
    if $.isNumeric(id)
      id = parseInt(id)
      $.ajax({
        type: "POST"
        url: "/select_category"
        data: { id: id },
        success: (result) ->
          $("#advertisement_service_id").children().remove()
          $("#{form_id} .services-select").find("li").remove()
          # ul <li data-option="" data-value=""><span>Тип объявления</span></li>
          # <option value="25">Капитальный ремонт</option>
          $("#{form_id} .services-select").find("ul").append '<li data-option="" data-value=""><span>Тип объявления</span></li>'
          $("#advertisement_service_id").append  '<option value="">Тип объявления</option>'
          for i in [0...result.length]
            $("#advertisement_service_id").append "<option value='#{result[i]["id"]}'>#{result[i]["name"]}</option>"
            $("#{form_id} .services-select").find("ul").append "<li data-option='' data-value='#{result[i]["id"]}'><span>#{result[i]["name"]}</span></li>"
          $("#{form_id} .services-select").children(".cs-placeholder").text("Тип объявления")
      })
  $("#{form_id} .services-select").find("ul").on "click", "li", ->
    $(this).parent().children().removeClass("cs-selected")
    $(this).addClass("cs-selected")
    $("#{form_id} .services-select").removeClass("cs-active")
    $("#{form_id} .services-select").children(".cs-placeholder").text($(this).children().text())
    id = $(this).attr "data-value"
    $("#{form_id} .services-select").val(id)

get_different_errors = (errors) ->
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
  return different_errors

output_dif_errors = (form_id, different_errors) ->
  # rename messages errors
  for i in [0...different_errors.length]
    if different_errors[i] == 'не может быть пустым'
      different_errors[i] = 'Заполните обязательные поля'
    if different_errors[i] == 'не является числом'
      different_errors[i] = 'Цена имеет неверный формат'
  # output errors in DOM
  for i in [0...different_errors.length]
    add_error_vers_vertical(different_errors[i], form_id)

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

parse_ad = (element) ->
  objAdvertisement.id = element.attr("data-ad")
  objAdvertisement.category_id = element.children("h2").text()
  objAdvertisement.description = element.children("p").text()
  objAdvertisement.price = parseInt(element.children("span").text())
  objAdvertisement.city = element.find(".city").text()
  objAdvertisement.address = element.find(".address").text()
  objAdvertisement.duration = element.find(".duration-ad").text()

objAdvertisement = 
  id: 1
  category_id: 1
  service_id: 1
  description: ""
  price: 100
  city: "Санкт-Петербург"
  address: "" 
  date: "" 
  duration: 10

output_in_form = (id_form) ->
  $(id_form).attr("action", "/advertisements/#{objAdvertisement.id}/edit")
  $(id_form).find("#advertisement_description").val("#{objAdvertisement.description}")
  $(id_form).find("#advertisement_price").val("#{objAdvertisement.price}")
  $(id_form).find("#advertisement_city").val("#{objAdvertisement.city}")
  $(id_form).find("#advertisement_address").val("#{objAdvertisement.address}")
  $(id_form).find("#advertisement_duration").val("#{objAdvertisement.duration}")

# convert yyyy-mm-dd to dd/mm/yyyy  
convert_date_rus = (yyyy_mm_dd) ->
  dateSplit = yyyy_mm_dd.split('-')
  currentDate = dateSplit[2] + '/' + dateSplit[1] + '/' +dateSplit[0]