timeselectWidget = (cid, hght) ->
    selected = [0 for i in [0..48]]
    selected = selected[0]
    selected_temp = [0 for i in [0..48]]
    selected_temp = selected_temp[0]
    context = null
    canvas = null
    mousestart = {}
    mouse = {}
    isdragging = false
    boxwidth = 0
    height = 0

    startDrag = (e) ->
        mousestart.x = e.pageX - @offsetLeft
        mousestart.y = e.pageY - @offsetTop
        isdragging = true

    stopDrag = (e) ->
        for i in [0..48]
            selected[i] = (selected[i] + selected_temp[i]) % 2
        isdragging = false

    doDrag = (e) ->
        if isdragging
            mouse.x = e.pageX - @offsetLeft
            mouse.y = e.pageY - @offsetTop

            # Clear temp list
            selected_temp = [0 for i in [0..48]]
            selected_temp = selected_temp[0]

            if mouse.x < mousestart.x
                for i in [mouse.x-boxwidth..mousestart.x]
                    selected_temp[i / boxwidth] = 1
            else
                for i in [mousestart.x-boxwidth..mouse.x]
                    selected_temp[i / boxwidth] = 1
            draw()

    init = (cvs, hght) ->
        height = hght
        canvas = document.getElementById(cvs)
        context = canvas.getContext('2d')

        boxwidth = canvas.width / 48

        $(canvas).mousedown(startDrag)
        .mouseup(stopDrag)
        .mousemove(doDrag)
    init(cid, hght)

    draw = ->
        # Reset the canvas
        canvas.width = canvas.width
        context.strokeStyle = 'rgb(0,0,0)'
        context.lineWidth = 1
        context.font = '10px Helvetica'
        context.textAlign = 'center'
        for i in [0..48]
            context.strokeRect(i * boxwidth, 0, boxwidth, height)
            if (selected[i] + selected_temp[i]) % 2
                context.fillStyle = 'rgba(255,0,0, 0.5)'
                context.fillRect(i * boxwidth, 0, boxwidth, height)

            context.fillStyle = 'rgb(0,0,0)'

            time = i/2

            if time >= 12
                time -= 12
                if time == 0
                    time = 12
                time += 'pm'
            else
                if time == 0
                    time = 12
                time += 'am'
            if (i + 1) % 2
                context.fillText(time, i * boxwidth + boxwidth, height + 10)

    draw: draw

$ ->
    testw = timeselectWidget('main_light', 20)
    testw.draw()