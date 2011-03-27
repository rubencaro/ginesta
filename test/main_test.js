require('./test_helper');

// --- the dead play with zombies ---

//podemos añadir helpers a la clase Test

Test.prototype.cabecera = function(){
  // la cabecera existe y dice el nombre del repo
  this.contains('h1 a','dummy');
};

Test.prototype.commits = function(num_children){
  // la sección existe
  this.contains('h2','Commits');
  // la lista también existe y tiene num nodos
  this.has_children('ul#commits',num_children);
  // la lista tiene enlaces
  this.css('ul#commits li a');
};

Test.prototype.tree = function(){
  // la sección existe
  this.contains('h2','Tree');
};


//empieza la fiesta

dead.visit("/", function (test) {
  test.status_ok();
});

dead.visit("/dummy", function (test) {
  test.status_ok();
  test.cabecera();
  test.commits();
  test.tree();

  // vamos a un commit
  test.click_link('Add README',function(){
    test.status_ok();
    // y volvemos
    test.click_link('h1 a',function(){
      test.status_ok();
    });
  });
});

dead.visit("/dummy/tree/master", function (test) {
  test.status_ok();
  test.cabecera();
  test.tree();
});

dead.visit("/dummy/commit/93501210aba004961d71606ca3a5d350dcfcdff5", function (test) {
  test.status_ok();
  test.cabecera();
});

dead.visit("/dummy/tag/b7f05c5af257179b345365e6e0a446699096fa9e", function (test) {
  test.status_ok();
  test.cabecera();
});

dead.visit("/dummy/branch/master", function (test) {
  test.status_ok();
  test.cabecera();
  test.commits();
});

dead.visit("/dummy/blob/2f1ae6c4e8d472f28a8216f76e08a5c8aebddae8", function (test) {
  test.status_ok();
  test.cabecera();
});
