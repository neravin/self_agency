$(document).on "page:change", ->
  $("#signin-button").click -> 
    $("#fade").show()
    $("#signin-form").show()

  $("#fade").click ->
    $("#signin-form").hide()
    $("#signup-form").hide()
    $("#passreset-form").hide()
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
    $("#new_client").append xhr.responseText
  ).on "ajax:error", (e, xhr, status, error) ->
    errors = xhr.responseJSON.error
    for message of errors
      switch message
        when "name" then $('#signup-name').append '<div class = "error-form"><p>' + errors[message] + '</p></div>'
        when "email" then $('#signup-email').append '<div class = "error-form"><p>' + errors[message] + '</p></div>'
        when "password" then $('#signup-password').append '<div class = "error-form"><p>' + errors[message] + '</p></div>'
        when "password_confirmation" then $('#signup-password-conf').append '<div class = "error-form"><p>' + errors[message] + '</p></div>'