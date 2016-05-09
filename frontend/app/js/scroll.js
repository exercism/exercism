$(function () {
  var shiftWindow = function() { scrollBy(0, -100); };
  if (location.hash) { shiftWindow(); }
  window.addEventListener("hashchange", shiftWindow);
});
