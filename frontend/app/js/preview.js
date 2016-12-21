(function () {
  "use strict";

  var codeBlockCache,
      $codeBlocks,
      $codeWindows,
      $iterationsNavItem,
      $submission;

  $(function () {

    codeBlockCache = [];
    $codeWindows = $('.submission-code-body .highlight');
    $codeBlocks = $codeWindows.find('td.code > pre');
    $iterationsNavItem = $('.iterations-nav-item');
    $submission = $('#submission');

    $codeBlocks.each(function () {
      codeBlockCache.push($(this).html());
    });

    $iterationsNavItem.hover(function () {
      if (!$submission.hasClass('diff-view')) {
        $(this).data('solution').forEach(function (file, index) {
          $codeBlocks.eq(index).text(file[1]);
        });
        $codeWindows.addClass('preview');
      }
    }, function () {
      if (!$submission.hasClass('diff-view')) {
        $codeBlocks.each(function (index) {
          $(this).html(codeBlockCache[index]);
        });
        $codeWindows.removeClass('preview');
      }
    });

  });
})();
