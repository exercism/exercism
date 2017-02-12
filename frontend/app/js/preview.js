(function () {
  "use strict";

  var codeBlockCache,
      $codeBlocks,
      $codeWindows,
      $iterationsNavItem;

  $(function () {

    codeBlockCache = [];
    $codeWindows = $('.submission-code-body .highlight');
    $codeBlocks = $codeWindows.find('td.code > pre');
    $iterationsNavItem = $('.iterations-nav-item');

    $codeBlocks.each(function () {
      codeBlockCache.push($(this).html());
    });

    $iterationsNavItem.hover(function () {
      $(this).data('solution').forEach(function (file, index) {
        $codeBlocks.eq(index).text(file[1]);
      });
      $codeWindows.addClass('preview');
    }, function () {
      $codeBlocks.each(function (index) {
        $(this).html(codeBlockCache[index]);
      });
      $codeWindows.removeClass('preview');
    });

  });
})();
