$ ->
    $frame = $ "#feedback"

    if $frame.length is 0
        return

    # Initialise and generate the html

    html = ""

    html += '<div class="feedback">'
    html += '    <div class="loading">Loading feedbacks...</div>'
    html += '    <ol></ol>'
    html += '    <form>'
    html += '        <div class="wait">'
    html += '            <span>Please wait a while for me to submit your feedback.</span>'
    html += '        </div>'
    html += '        <div class="form">'
    html += '            <h3>Add Feedback</h3>'
    html += '            <div class="form-group">'
    html += '                <label>Description</label>'
    html += '                <input class="form-control" type="text" name="description" />'
    html += '            </div>'
    html += '            <div class="form-group">'
    html += '                <label>Name</label>'
    html += '                <input class="form-control" type="text" name="name" />'
    html += '            </div>'
    html += '            <div class="form-group text-right">'
    html += '                <button class="btn btn-success">Submit</button>'
    html += '            </div>'
    html += '        </div>'
    html += '    </form>'
    html += '    <li class="lineblock">'
    html += '        <span class="text description"></span>'
    html += '        <span class="text actions">'
    html += '            <button class="btn btn-link btn-xs complete">'
    html += '                <span class="glyphicon glyphicon-ok"></span>'
    html += '            </button>'
    html += '            <button class="btn btn-link btn-xs uncomplete">'
    html += '                <span class="glyphicon glyphicon-remove"></span>'
    html += '            </button>'
    html += '            <button class="btn btn-link btn-xs delete">'
    html += '                <span class="glyphicon glyphicon-trash"></span>'
    html += '            </button>'
    html += '        </span>'
    html += '        <span class="text name"></span>'
    html += '    </li>'
    html += '</div>'

    htmlBlock = $ html
    $frame.html htmlBlock.html()

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