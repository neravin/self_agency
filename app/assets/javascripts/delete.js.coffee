$(document).on "page:change", ->

	$(".delete-ad-link").click ->
		id = $(this).parent().attr("data-ad")
		if confirm("Точно удалить?")
			element = $(this).parent()
			$.ajax
				url: "/advertisements/" + id
				type: "POST"
				data:
					_method: "DELETE"

				success: (result) ->
					element.slideUp "slow", ->
	  				element.remove()

	$(".delete-ad-link-big-boobs").click ->
		id = $(this).parent().attr("data-worker")
		if confirm("Точно удалить?")
			element = $(this).parent()
			$.ajax
				url: "/workers/" + id
				type: "POST"
				data:
					_method: "DELETE"

				success: (result) ->
					element.slideUp "slow", ->
	  				element.remove()