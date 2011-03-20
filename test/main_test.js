require('./test_helper');

browser = new zombie.Browser({ debug: true })

// test '/'
check.visit("/", browser, function (browser, status) {
  check.status_ok(status);
});
