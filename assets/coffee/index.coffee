$ ->
    $frame = $ ".feedback"
    $list = $frame.find "> ol"
    $block = $frame.find "> li.lineblock"
    $form = $frame.find "> form"

    feedback = (data) ->
        dfd = $.ajax
            url: "api/feedback.php"
            type: "post"
            data: data
            dataType: "json"

    $form.on "submit", (event) ->
        event.preventDefault()

        form = $ @

        # Forcefully lose focus on the button
        form
            .find "button"
            .trigger "blur"

        form.addClass "submitting"

        description = form.find "input[name=description]"
        name = form.find "input[name=name]"

        feedback
            description: description.val()
            name: name.val()
            mode: "add"
        .done (response) ->

            block = $block.clone()

            block.attr "data-id", response.id
            block
                .find ".description"
                .html description.val()
            block
                .find ".name"
                .html name.val()

            block.appendTo $list

            description.val ""
            name.val ""
            form.removeClass "submitting"

    $list.on "click", ".complete", (event) ->
        button = $ @
        block = button.parents ".lineblock"
        block.addClass "completed"

        id = block.data "id"

        feedback
            id: id
            mode: "complete"

    $list.on "click", ".uncomplete", (event) ->
        button = $ @
        block = button.parents ".lineblock"
        block.removeClass "completed"

        id = block.data "id"

        feedback
            id: id
            mode: "uncomplete"

    $list.on "click", ".delete", (event) ->
        button = $ @
        block = button.parents ".lineblock"
        block.removeClass "completed"

        id = block.data "id"

        feedback
            id: id
            mode: "delete"
        .done (response) ->
            console.log block
            block.remove()

    feedback
        mode: "load"
    .done (response) ->
        $frame.addClass "loaded"

        $.each response, (i, row) ->
            block = $block.clone()

            block.attr "data-id", row.id
            block
                .find ".description"
                .html row.description
            block
                .find ".name"
                .html row.name

            if row.state
                block.addClass "completed"

            block.appendTo $list