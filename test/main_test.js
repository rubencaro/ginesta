require('./test_helper');

check.visit("/", function (browser, status) {
  check.status_ok(status);
});

check.visit("/dummy", function (browser, status) {
  check.status_ok(status);
});

check.visit("/dummy/tree/master", function (browser, status) {
  check.status_ok(status);
});

check.visit("/dummy/commit/93501210aba004961d71606ca3a5d350dcfcdff5", function (browser, status) {
  check.status_ok(status);
});

check.visit("/dummy/tag/b7f05c5af257179b345365e6e0a446699096fa9e", function (browser, status) {
  check.status_ok(status);
});

check.visit("/dummy/branch/master", function (browser, status) {
  check.status_ok(status);
});

check.visit("/dummy/blob/2f1ae6c4e8d472f28a8216f76e08a5c8aebddae8", function (browser, status) {
  check.status_ok(status);
});
