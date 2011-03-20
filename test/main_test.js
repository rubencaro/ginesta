require('./zombie_test_helper');

browser = new zombie.Browser({ debug: true })

// test '/'
check.visit(browser, server + "/", function (err, browser, status) {
  check.status_ok(status);
  check.pend('Esto está pendiente');
});
