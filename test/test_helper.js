zombie = require("zombie");

// namespace para los datos globales
// --- the dead play with zombies ---
dead = {

  tests: 0,
  failed: 0,
  pended: 0,
  omitted: 0,
  assertions: 0,
  errors: 0,

  //test-unit format
  log: function(){
    console.log(dead.tests+' tests, '
        +dead.assertions+' assertions, '
        +dead.failed+' failures, '
        +dead.errors+' errors, '
        +dead.pended+' pendings, '
        +dead.omitted+' omissions, '
        +'0 notifications');
  },

  clear: function(){
    dead.passed = 0;
    dead.failed = 0;
    dead.pended = 0;
    dead.omitted = 0;
    dead.assertions = 0;
  },

  //capturar excepciones y mostrar los errores por consola
  visit: function(url, callback){
    dead.tests++;
    var test = new Test();
    zombie.visit(test.server + url, {debug:true}, function (err, browser, status) {
      try{
        if(err)
          throw err;
        test.browser = browser;
        callback(test);
        console.log("Test ended URL:" + url );
      }
      catch(err2){
        dead.failed++;
        console.log("\n++++++ Test error URL:" + url );
//         browser.dump();
        console.log(err2.stack);
      }
    });
  },

  error: function(err){
    dead.errors++;
    console.log("++++++ Nodejs error:" + err.stack);
  },
}

// capturar todo a nivel de sistema y contarlo como fallo
process.on('uncaughtException',dead.error);

// mostrar el log al salir
process.on('exit',dead.log);


// clase Test para mantener datos individuales de cada test
Test = function(){
  this.server = "http://ginesta";
  this.browser = null;
  this.url = null;

  this.ok = function(tested, message){
    dead.assertions++;
    if(tested!=true){
      if(typeof(message)=='undefined')
        message = 'Not true.';
      throw new Error(message);
    }
  };

  this.status_ok = function(){
    var status = this.browser.statusCode;
    this.ok(status == 200 || status == 304, 'status debe ser 200 o 304, pero es status='+status);
  };

  this.pend = function(message){
    dead.pended++;
    if(typeof(message)=='undefined')
      message = new Error('Pended.').stack;
    console.log(message);
  };

  this.omit = function(message){
    dead.omitted++;
    if(typeof(message)=='undefined')
      message = new Error('Omitted.').stack;
    console.log(message);
  };

  // comprueba que el css tiene resultados y los devuelve
  this.css = function(selector){
    var elems = this.browser.css(selector);
    this.ok(elems.length > 0, "Debería existir. selector:'" + selector + "'");
    return elems;
  };

  // hace this.css y devuelve el html de todos los elementos seleccionados
  this.html = function(selector){
    this.css(selector);
    return this.browser.html(selector);
  };

  // hace this.html(selector) y comprueba que contiene el texto dado
  this.contains = function(selector,text){
    var content = this.html(selector);
    var patt = new RegExp(text);
    this.ok(patt.test(content),"Debería contener el texto:'" + text + "', selector:'" + selector + "', html: '" + content + "'");
  };

  // comprueba que existe
  // y que la primera coincidencia del selector tiene num nodos hijos
  // si num < 0 o no se define, entonces se comprueba que tenga al menos un hijo
  this.has_children = function(selector,num){
    var elem = this.css(selector)[0];
    var total = elem.childNodes.length;
    if(typeof(num)=='undefined' || num == null) // por defecto -1
      num = -1;
    if(num < 0){  //comprobar si tiene alguno
      this.ok(total > 0,"Debería contener nodos. selector:'" + selector + "'");
    }
    else{
      this.ok(total == num,"Debería contener '" + num + "' nodos, pero contiene '" + total + "'. selector:'" + selector + "'");
    }
  };

  this.click_link = function(selector,callback){
    this.browser.clickLink(selector,callback);
  };

}



