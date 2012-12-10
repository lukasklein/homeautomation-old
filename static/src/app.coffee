roomManager = (rm, spc) ->
    room = null
    spec = []
    lampStati = {}
    init = (rm, spc) ->
        room = document.getElementById(rm)
        spec = spc
    init(rm, spc)

    draw = (svg) ->
        for object in spec
            swidth = 1
            color = 'black'
            fill = 'none'
            id = ''
            lid = ''
            if object.islamp
                id = 'lamp_' + object.lampid
                lid = object.lampid
                swidth = 3
                fill = color = 'gray'
                if lampStati[object.lampid]
                    color = fill = 'yellow'

            if object.type == 'rect'
                obj = svg.rect(object.x, object.y, object.width, object.height, {fill: fill, stroke: color, strokeWidth: swidth, id: id, 'data-lid': lid})
            if object.type == 'circle'
                obj = svg.circle(object.x, object.y, object.radius, {fill: fill, stroke: color, strokeWidth: swidth, id: id, 'data-lid': lid})

            if object.islamp
                $(obj).click ->
                    toggleLamp($(@).attr('data-lid'))

    toggleLamp = (lid) ->
        if lampStati[lid] == undefined
            lampStati[lid] = 0
        lampStati[lid] = (lampStati[lid] + 1) % 2

        color = 'gray'
        if lampStati[lid]
            color = 'yellow'

        obj = $('#lamp_' + lid)
        obj.attr({
            fill: color
            stroke: color
        })

    $(room).svg({onLoad: draw})

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
    myRoom = [
        type: 'rect' # shelf over couch
        x: 0
        y: 0
        width: 40
        height: 160
    ,
        type: 'rect' # couch shelf lamp
        x: 0
        y: 0
        width: 5
        height: 160
        islamp: true
        lampid: 1
    ,
        type: 'rect' # shelf in front of bed
        x: 0
        y: 170
        width: 130
        height: 40
    ,
        type: 'rect' # bed
        x: 0
        y: 210
        width: 130
        height: 200
    ,
        type: 'rect' # bed-shelf
        x: 0
        y: 410
        width: 130
        height: 35
    ,
        type: 'rect' # bed-shelf lamp
        x: 0
        y: 440
        width: 130
        height: 5
        islamp: true
        lampid: 2
    ,
        type: 'rect' # closet
        x: 350
        y: 0
        width: 60
        height: 60
    ,
        type: 'rect' # desk
        x: 320
        y: 60
        width: 90
        height: 180
    ,
        type: 'rect' # commode
        x: 300
        y: 385
        width: 110
        height: 60
    ,
        type: 'circle' # commode lamp
        x: 260
        y: 410
        radius: 25
        islamp: true
        lampid: 3
    ]

    room = roomManager('room', myRoom)
    testw = timeselectWidget('main_light', 20)
    testw.draw()