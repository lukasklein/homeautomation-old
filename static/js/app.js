// Generated by CoffeeScript 1.4.0
(function() {
  var roomManager, timeselectWidget;

  roomManager = function(rm, spc) {
    var draw, init, lampStati, room, spec, toggleLamp;
    room = null;
    spec = [];
    lampStati = {};
    init = function(rm, spc) {
      room = document.getElementById(rm);
      return spec = spc;
    };
    init(rm, spc);
    draw = function(svg) {
      var color, fill, id, lid, obj, object, swidth, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = spec.length; _i < _len; _i++) {
        object = spec[_i];
        swidth = 1;
        color = 'black';
        fill = 'none';
        id = '';
        lid = '';
        if (object.islamp) {
          id = 'lamp_' + object.lampid;
          lid = object.lampid;
          swidth = 3;
          fill = color = 'gray';
          if (lampStati[object.lampid]) {
            color = fill = 'yellow';
          }
        }
        if (object.type === 'rect') {
          obj = svg.rect(object.x, object.y, object.width, object.height, {
            fill: fill,
            stroke: color,
            strokeWidth: swidth,
            id: id,
            'data-lid': lid
          });
        }
        if (object.type === 'circle') {
          obj = svg.circle(object.x, object.y, object.radius, {
            fill: fill,
            stroke: color,
            strokeWidth: swidth,
            id: id,
            'data-lid': lid
          });
        }
        if (object.islamp) {
          _results.push($(obj).click(function() {
            return toggleLamp($(this).attr('data-lid'));
          }));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };
    toggleLamp = function(lid) {
      var color, obj;
      if (lampStati[lid] === void 0) {
        lampStati[lid] = 0;
      }
      lampStati[lid] = (lampStati[lid] + 1) % 2;
      color = 'gray';
      if (lampStati[lid]) {
        color = 'yellow';
      }
      obj = $('#lamp_' + lid);
      return obj.attr({
        fill: color,
        stroke: color
      });
    };
    return $(room).svg({
      onLoad: draw
    });
  };

  timeselectWidget = function(cid, hght) {
    var boxwidth, canvas, context, doDrag, draw, height, i, init, isdragging, mouse, mousestart, selected, selected_temp, startDrag, stopDrag;
    selected = [
      (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 0; _i <= 48; i = ++_i) {
          _results.push(0);
        }
        return _results;
      })()
    ];
    selected = selected[0];
    selected_temp = [
      (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 0; _i <= 48; i = ++_i) {
          _results.push(0);
        }
        return _results;
      })()
    ];
    selected_temp = selected_temp[0];
    context = null;
    canvas = null;
    mousestart = {};
    mouse = {};
    isdragging = false;
    boxwidth = 0;
    height = 0;
    startDrag = function(e) {
      mousestart.x = e.pageX - this.offsetLeft;
      mousestart.y = e.pageY - this.offsetTop;
      return isdragging = true;
    };
    stopDrag = function(e) {
      var _i;
      for (i = _i = 0; _i <= 48; i = ++_i) {
        selected[i] = (selected[i] + selected_temp[i]) % 2;
      }
      return isdragging = false;
    };
    doDrag = function(e) {
      var _i, _j, _ref, _ref1, _ref2, _ref3;
      if (isdragging) {
        mouse.x = e.pageX - this.offsetLeft;
        mouse.y = e.pageY - this.offsetTop;
        selected_temp = [
          (function() {
            var _i, _results;
            _results = [];
            for (i = _i = 0; _i <= 48; i = ++_i) {
              _results.push(0);
            }
            return _results;
          })()
        ];
        selected_temp = selected_temp[0];
        if (mouse.x < mousestart.x) {
          for (i = _i = _ref = mouse.x - boxwidth, _ref1 = mousestart.x; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; i = _ref <= _ref1 ? ++_i : --_i) {
            selected_temp[i / boxwidth] = 1;
          }
        } else {
          for (i = _j = _ref2 = mousestart.x - boxwidth, _ref3 = mouse.x; _ref2 <= _ref3 ? _j <= _ref3 : _j >= _ref3; i = _ref2 <= _ref3 ? ++_j : --_j) {
            selected_temp[i / boxwidth] = 1;
          }
        }
        return draw();
      }
    };
    init = function(cvs, hght) {
      height = hght;
      canvas = document.getElementById(cvs);
      context = canvas.getContext('2d');
      boxwidth = canvas.width / 48;
      return $(canvas).mousedown(startDrag).mouseup(stopDrag).mousemove(doDrag);
    };
    init(cid, hght);
    draw = function() {
      var time, _i, _results;
      canvas.width = canvas.width;
      context.strokeStyle = 'rgb(0,0,0)';
      context.lineWidth = 1;
      context.font = '10px Helvetica';
      context.textAlign = 'center';
      _results = [];
      for (i = _i = 0; _i <= 48; i = ++_i) {
        context.strokeRect(i * boxwidth, 0, boxwidth, height);
        if ((selected[i] + selected_temp[i]) % 2) {
          context.fillStyle = 'rgba(255,0,0, 0.5)';
          context.fillRect(i * boxwidth, 0, boxwidth, height);
        }
        context.fillStyle = 'rgb(0,0,0)';
        time = i / 2;
        if (time >= 12) {
          time -= 12;
          if (time === 0) {
            time = 12;
          }
          time += 'pm';
        } else {
          if (time === 0) {
            time = 12;
          }
          time += 'am';
        }
        if ((i + 1) % 2) {
          _results.push(context.fillText(time, i * boxwidth + boxwidth, height + 10));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };
    return {
      draw: draw
    };
  };

  $(function() {
    var myRoom, room, testw;
    myRoom = [
      {
        type: 'rect',
        x: 0,
        y: 0,
        width: 40,
        height: 160
      }, {
        type: 'rect',
        x: 0,
        y: 0,
        width: 5,
        height: 160,
        islamp: true,
        lampid: 1
      }, {
        type: 'rect',
        x: 0,
        y: 170,
        width: 130,
        height: 40
      }, {
        type: 'rect',
        x: 0,
        y: 210,
        width: 130,
        height: 200
      }, {
        type: 'rect',
        x: 0,
        y: 410,
        width: 130,
        height: 35
      }, {
        type: 'rect',
        x: 0,
        y: 440,
        width: 130,
        height: 5,
        islamp: true,
        lampid: 2
      }, {
        type: 'rect',
        x: 350,
        y: 0,
        width: 60,
        height: 60
      }, {
        type: 'rect',
        x: 320,
        y: 60,
        width: 90,
        height: 180
      }, {
        type: 'rect',
        x: 300,
        y: 385,
        width: 110,
        height: 60
      }, {
        type: 'circle',
        x: 260,
        y: 410,
        radius: 25,
        islamp: true,
        lampid: 3
      }
    ];
    room = roomManager('room', myRoom);
    testw = timeselectWidget('main_light', 20);
    return testw.draw();
  });

}).call(this);
