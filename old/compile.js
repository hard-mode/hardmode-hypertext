var compileStyles = function () {

  // compiles master stylesheet

  console.log("Compiling stylesheets.");

  var styl = stylus('');
  styl.set('filename', 'style.css');
  //styl.import('modules/global');

  for (var i in this.modules) {
    var d = this.modules[i].dir
      , p = path.join(d, i + '.styl');
    if (fs.existsSync(p)) {
      styl.import(d + '/' + i);
    }
  }

  styl.render(function (err, css) {
    if (err) throw err;
    console.log(css);
    this.data.set('style', css);
    this.data.publish('updated', 'style');
  }.bind(this));

};


var compileScripts = function () {

  // compiles all client-side scripts
  // and bundles them together with browserify

  console.log("Compiling scripts.");

  var br = browserify();

  // add wisp runtime
  br.add(path.resolve(path.join('node_modules', 'wisp', 'engine', 'browser.js')));

  Object.keys(this.modules).map(function(module){

    var moduleDir = this.modules[module].dir;

    // add jade templates
    glob.sync(path.join(moduleDir, '**', '*.jade'))
        .map(function (template) { br.add(template); });

    // add main client script
    // TODO replace with package.json
    var wispPath = path.join(moduleDir, 'client.wisp')
      , jsPath   = path.join(moduleDir, 'client.js');
    if (fs.existsSync(wispPath)) { br.add(wispPath); } else
    if (fs.existsSync(jsPath))   { br.add(jsPath);   }

  }.bind(this));

  // transform, bundle, and store in redis
  br.transform(require('wispify'))
    .transform(require('jadeify'), { compiler: DynamicMixinsCompiler })
    .transform(require('./transform_jade.js'))
    //.transform({ global: true }, 'uglifyify' )
    .bundle(function (err, bundled) {
      if (err) throw err;
      this.data.set('script', bundled);
      this.data.publish('updated', 'scripts');
    }.bind(this));

};
