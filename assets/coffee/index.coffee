$ ->
    $frame = $ ".feedback"
    $block = $frame.find "> li.lineblock"

    $frame.on "click", ".addfeedback", ->
        $.ajax
            url: "/feedback.php"
            type: "post"
            data:
                mode: "load"
        .done (response) ->
