jsdom  = require("jsdom")
window = jsdom.jsdom().createWindow()
fs     = require("fs")

jsdom.jQueryify window, "http://code.jquery.com/jquery-1.8.0.min.js", ->
  $ = window.$
  fs.readFile "shows.html", "utf8", (err, data) ->
    $("body").append data
    shows = []
    $("form > p").map (i, show) ->
      $show = $(show)
      id = $show.find("input").attr "id"
      if id
        $link = $show.find "a"
        show =
          phantasyTourId: id.split("_").pop()
          title: $link.text()

        shows.push show

    json = JSON.stringify shows

    fs.writeFile "shows.json", json, "utf8"
