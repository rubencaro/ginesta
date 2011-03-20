require('./test_helper');

browser = new zombie.Browser({ debug: true })

// test '/'
check.visit("/", browser, function (err, browser, status) {
  check.status_ok(status);
  check.pend('Esto está pendiente');
});
