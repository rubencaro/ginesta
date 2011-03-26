zombie = require("zombie");

// namespace para el test reporting
check = {
  server: "http://ginesta",

  passed: 0,
  failed: 0,
  pended: 0,
  omitted: 0,
  assertions: 0,

  ok: function(tested, message){
    check.assertions++;
    if(tested==true){
      check.passed++;
    }
    else {
      check.failed++;
      if(typeof(message)=='undefined')
        message = 'Not true.';
      throw new Error(message);
    }
  },

  status_ok: function(status){
    check.ok(status == 200 || status == 304, 'status debe ser 200 o 304, pero es status='+status);
  },

  pend: function(message){
    check.pended++;
    if(typeof(message)=='undefined')
      message = new Error('Pended.').stack;
    console.log(message);
  },

  omit: function(message){
    check.omitted++;
    if(typeof(message)=='undefined')
      message = new Error('Omitted.').stack;
    console.log(message);
  },

  //test-unit format
  log: function(){
    console.log(check.assertions+' tests, '
        +check.passed+' assertions, '
        +check.failed+' failures, '
        +'0 errors, '
        +check.pended+' pendings, '
        +check.omitted+' omissions, '
        +'0 notifications');
  },

  clear: function(){
    check.passed = 0;
    check.failed = 0;
    check.pended = 0;
    check.omitted = 0;
    check.assertions = 0;
  },

  //capturar excepciones y mostrar los errores por consola
  visit: function(url, callback){
    zombie.visit(check.server + url,{debug:true}, function (err, browser, status) {
      try{
        if(err)
          throw err;
        callback(browser,status);
        console.log("Test ended URL:" + url );
      }
      catch(err2){
        check.failed++;
        console.log("++++++ Test error URL:" + url );
        browser.dump();
        console.log(err2.stack);
      }
    });
  },

  error: function(err){
    check.failed++;
    console.log("++++++ Nodejs error:" + err.stack);
  },

}

// capturar todo a nivel de sistema y contarlo como fallo
process.on('uncaughtException',check.error);

// mostrar el log al salir
process.on('exit',check.log);

// la clase Test
// function Test(url,browser,callback){
//   this.url = url;
//   this.browser = browser;
//   this.callback = callback;
//   this.run = function(){
//     check.visit(this.url,this.browser,this.callback);
//   }
// }

