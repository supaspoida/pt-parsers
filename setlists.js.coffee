jsdom   = require("jsdom")
request = require("request")
fs      = require("fs")

getPage = (pageNum) ->
  url = "http://phantasytour.com/shows?band_id=4&page=#{pageNum}&tour_id=-1"
  request url, (error, response, body) =>
    segueRegExp = new RegExp(' > ', 'g')
    segueElement = '<span class="segue"/>'

    html = body.replace(segueRegExp, segueElement)

    jsdom.env html, ["http://code.jquery.com/jquery-1.8.0.min.js"], (errors, window) ->
      $ = window.$
      toString = (element) -> element.outerHTML
      $shows = $('#ajax_content .show_summary')
      shows = $.map($shows, toString).join "\n"
      fs.writeFile "setlists/shows-#{pageNum}.html", shows, 'utf8'

getPage page for page in [1..88]
