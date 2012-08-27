var jsdom  = require("jsdom"),
    window = jsdom.jsdom().createWindow(),
    fs     = require("fs");

jsdom.jQueryify(window, 'http://code.jquery.com/jquery-1.8.0.min.js', function() {
  var $ = window.$;

  fs.readFile('shows.html', 'utf8', function(err,data) {
    $('body').append(data);

    shows = [];

    $('form > p').each(function(i, show) {
      var $show = $(show),
          id    = $show.find('input').attr('id');

      if (id) {
        var $link = $show.find('a');
        obj = {
          phantasyTourId: id.split('_').pop(),
          title: $link.text()
        };
        shows.push(obj);
      };
    });

    var json = JSON.stringify(shows);

    fs.writeFile('shows.json', json, 'utf8')
  });
});
