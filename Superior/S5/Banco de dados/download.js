var http = require('http');
var fs = require('fs');

var download = function(url, dest, cb) {
  var file = fs.createWriteStream(dest);
  var request = http.get(url, function(response) {
    response.pipe(file);
    file.on('finish', function() {
      file.close(cb);
    });
  });
}

download('http://api.moddevices.com/lv2/plugins', 'plugins.json', () => console.log("Downloaded"));