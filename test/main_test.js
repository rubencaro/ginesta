require('./test_helper');

// --- the dead play with zombies ---

//podemos añadir helpers a la clase Test

Test.prototype.cabecera = function(){
  // la cabecera existe y dice el nombre del repo
  this.contains('h1','dummy');
};


//empieza la fiesta

dead.visit("/", function (test) {
  test.status_ok();
});

dead.visit("/dummy", function (test) {
  test.status_ok();
  test.cabecera();
});

dead.visit("/dummy/tree/master", function (test) {
  test.status_ok();
  test.cabecera();
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
});

dead.visit("/dummy/blob/2f1ae6c4e8d472f28a8216f76e08a5c8aebddae8", function (test) {
  test.status_ok();
  test.cabecera();
});
