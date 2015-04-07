!function() {
  $("a#copy-code").on('click', function (e) {
    e.preventDefault();
    $(this).zclip({
      path: 'http://www.steamdev.com/zclip/js/ZeroClipboard.swf',
      copy: $("#submission-code").text(),
      afterCopy: function() {
        alert("The submission code was successfully copied to your clipboard!");
      }
    });
  });
}(this);
