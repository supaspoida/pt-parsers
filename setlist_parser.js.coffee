jsdom  = require("jsdom")
window = jsdom.jsdom().createWindow()
fs     = require("fs")

jsdom.jQueryify window, "http://code.jquery.com/jquery-1.8.0.min.js", ->
  $ = window.$

  fs.readFile "setlists.html", "utf8", (err, data) ->
    $("body").append data
    shows = []
    $shows = $('.show_summary')

    $.map $shows, (element) ->
      $show = $(element)
      $title = $show.find('.show_header')
      $date = $title.find('a:first')
      $sets = $show.find('.setlist_partial')
      $footnotes = $show.find('.setlist_footnote')

      getSongs = (element) ->
        $set = $(element)
        $songs = $set.find('a')
        setName = $set.find('b').text()
        $.map $songs, ($song) ->
          buildSong $song, getSet(setName)

      buildSong = (element, setName) ->
        $song = $(element)
        name: $song.text()
        segue: $song.next('.segue').length == 1
        set: setName
        footnotes: $song.next('sup').text().split(/\s/)

      getSet = (setName) ->
        match = setName.match(/\d/)
        if match then match[0] else 'Encore'

      cleanTitle = (title) ->
        $.trim title.replace(/\s+/g, ' ').replace(' , ', ', ').replace(/•/g, '-')

      buildFootnote = (element) ->
        $footnote = $(element)
        text = $.trim($footnote.text()).replace(/\n/g, ' ')
        match = text.match(/(\d+) (.*)/)

        number: match[1]
        text: match[2]

      shows.push
        title: cleanTitle($title.text())
        phantasyTourId: $date.attr('href').split('/')[-1..][0]
        songs: $.map($sets, getSongs)
        footnotes: $.map($footnotes, buildFootnote)

    json = JSON.stringify shows

    fs.writeFile "setlists.json", json, "utf8"
