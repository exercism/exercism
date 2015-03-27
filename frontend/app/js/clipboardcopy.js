$(document).ready(function() {
  $("a#copy-code").on('click', function (e) {
    e.preventDefault();
  }).each(function () {
    $(this).zclip({
      path: 'http://www.steamdev.com/zclip/js/ZeroClipboard.swf',
    copy: $("#submission-code").text(),
    afterCopy: function() {
      alert("The submission code was successfully copied to your clipboard!");
    }
    });
  });
  
  $("a.copy-command").on('click', function (e) {
    e.preventDefault();
  }).each(function () {
    $(this).zclip({
      path: 'http://www.steamdev.com/zclip/js/ZeroClipboard.swf',
    copy: $(this).siblings('p').text(),
    afterCopy: function() {
      alert("The submission code was successfully copied to your clipboard!");
    }
    });
  });
});
