var blade   = require('blade')
  , path    = require('path')
  , through = require('through');

module.exports = function bladeify (file) {

  var data = '';

  return through(write, end);

  function write (buf) { data += buf }

  function end   () {

    if (path.extname(file) === '.blade') {

      var options =
        { minify:  true
        , filters: { coffeescript: null }};

      blade.compile(data, options, function (err, tmpl) {

        if (err) throw err;
        this.queue("module.exports="+tmpl.toString());
        this.queue(null);
        
      }.bind(this));

    } else {

      this.queue(data);
      this.queue(null);

    }

  }

}
