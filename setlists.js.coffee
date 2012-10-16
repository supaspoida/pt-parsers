jsdom = require("jsdom")
fs    = require("fs")

getPage = (pageNum) ->
  url = "http://phantasytour.com/shows?band_id=4&page=#{pageNum}&tour_id=-1"
  jsdom.env url, ["http://code.jquery.com/jquery-1.8.0.min.js"], (errors, window) ->
    $ = window.$

    $shows = $('#ajax_content .show_summary')
    toString = (element) -> element.outerHTML

    shows = $.map($shows, toString).join "\n"

    fs.writeFile "shows-#{pageNum}.html", shows, 'utf8'

getPage page for page in [1..88]
