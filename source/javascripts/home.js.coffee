drawingSvg = (value, el)->
  updateDrawings = ->
    el.each ->
      cur = $(this)
      lastV = cur.data("last-v")
      v = cur.attr(value)
      if lastV != v
        if cur.hasClass("line")
          cur.css({
            transform:"scale("+v+",1)"
          })
        if cur.data("loaded")
          snap = $(this).data("snap")

          if snap!=null
            path = snap.selectAll("path,line,polyline,polygon,ellipse")

            path.forEach (i)->
              l = i.attr("data-length")
              if l == null
                l = i.getTotalLength()
                i.attr("data-length",l)

              if typeof(l) == "undefined"
                l = 1000
              i.attr(
               strokeDasharray: (v*l)+","+l
              )
          cur.data("last-v",v)
    requestAnimationFrame(updateDrawings)
  updateDrawings()

$(document).ready ->
  $('.draw').each ->
    cur = $(this)
    cur.attr("data-"+cur.height()+"-bottom","@data-v:0")
    cur.attr("data-80-center","@data-v:1")
    cur.attr("data-v",0)

  $(".inline-svg").each ->
    cur = $(this)
    w = cur.width()
    h = cur.height()
    cur.css(
      width:w,
      height:h
    )

    svg = Snap(w,h)

    Snap.load cur.data("src"), (f)->
      svg.append(f)
      cur.data("loaded",true)

    svg.appendTo(cur.get(0))
    cur.data("snap",svg)

  drawingSvg("data-v", $('.scrollable.draw'))

  drawingSvg("data-timer-v", $('.timer.draw'))
  interval_id = setInterval ->
    v = $('.timer.draw').attr('data-timer-v')
    v = parseFloat(v)
    if v < 1
      $('.timer.draw').attr('data-timer-v', v + 0.02)
    else
      clearInterval(interval_id)
  , 30

  skrollr.init
    smoothScrolling: true
    smoothScrollingDuration: 350
    mobileDeceleration: 0.005
