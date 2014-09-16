$(document).on "page:change", ->
  $("#signin-button").click -> 
    $("#fade").show()
    $("#signin-form").show()

  $("#fade").click ->
    $("#signin-form").hide()
    $("#signup-form").hide()
    $("#passreset-form").hide()
    $("#success-message").hide()
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
  ).on "ajax:error", (e, xhr, status, error) ->
    clear_errors()
    errors = xhr.responseJSON.error
    for message of errors
      switch message
        when "name" then                    add_error(errors[message], "#client_name", "#signup-name")
        when "email" then                   add_error(errors[message], "#client_email", "#signup-email")
        when "password" then                add_error(errors[message], "#client_password", "#signup-password")
        when "password_confirmation" then   add_error(errors[message], "#client_password_confirmation", "#signup-password-conf")

  $("#new_client").on "click", "input.error-input", ->
    $(this).removeClass("error-input")
    error_message = $(this).next()
    error_message.fadeOut ->
      error_message.remove()


add_error = (message, id_input, id_text_error) ->
  $(id_text_error).append '<div class = "error-form"><p>' + message + '</p></div>'
  $(id_input).addClass("error-input")

clear_errors = () ->
  num_errors = $('.error-input').length
  if num_errors > 0
    $('.error-form').remove()
    $('.error-input').removeClass('.error-input')