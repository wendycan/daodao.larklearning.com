updateDrawings = ->
  $(".draw").each ->
    cur = $(this)
    lastV = cur.data("last-v")
    v = cur.attr("data-v")

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
        cur.data("last-v",v);
  requestAnimationFrame(updateDrawings);

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

  updateDrawings()
  skrollr.init
    smoothScrolling: true
    smoothScrollingDuration: 350
    mobileDeceleration: 0.005
