(function () {
  "use strict";

  var codeBlockCache,
      createDiffBlock,
      diffCodeBlock,
      findAdjacentTab,
      originalLayout,
      restoreCodeBlocks,
      restoreOriginalLayout,
      setTwoColumnLayout,
      toggleDiffView,
      updateDiffBlock,
      $activeTab,
      $codeBlocks,
      $codeWindows,
      $iterationsNavItems,
      $iterationsNavItemsInactive,
      $submission;

  diffCodeBlock = function (file, index) {
    var fragmentLeft, fragmentRight;

    fragmentLeft = document.createDocumentFragment();
    fragmentRight = document.createDocumentFragment();
    JsDiff.diffWordsWithSpace(file[1], $activeTab.data('solution')[index][1])
      .forEach(function (part) {
        var diffClass, span;

        diffClass = part.added ? 'diff-added' : part.removed ? 'diff-removed' : '';
        if (!part.added) {
          span = document.createElement('span');
          span.className = diffClass;
          span.appendChild(document.createTextNode(part.value));
          fragmentLeft.appendChild(span);
        }
        if (!part.removed) {
          span = document.createElement('span');
          span.className = diffClass;
          span.appendChild(document.createTextNode(part.value));
          fragmentRight.appendChild(span);
        }
    });
    return [fragmentLeft, fragmentRight];
  };

  createDiffBlock = function (file, index) {
    var leftCode, rightCode, diffFragments;

    diffFragments = diffCodeBlock(file, index);
    leftCode = $('.submission-code-header').eq(index).next('.submission-code-body');
    rightCode = leftCode.clone();
    leftCode.addClass('col-md-6 diff-left');
    rightCode.addClass('col-md-6 diff-right');
    leftCode.wrap('<div class="row diff-row" />').parent().append(rightCode);
    leftCode.find('td.code > pre').empty().append(diffFragments[0]);
    rightCode.find('td.code > pre').empty().append(diffFragments[1]);
  };

  updateDiffBlock = function (file, index) {
    var $diffRow, diffFragments;

    diffFragments = diffCodeBlock(file, index);
    $diffRow = $('.diff-row').eq(index);
    $('.diff-left td.code > pre', $diffRow).empty().append(diffFragments[0]);
    $('.diff-right td.code > pre', $diffRow).empty().append(diffFragments[1]);
  };

  toggleDiffView = function () {
    if ($submission.hasClass('diff-view')) {
      $iterationsNavItemsInactive.removeClass('diff-view-old');
      $('.submission-code-body.diff-right').remove();
      $('.submission-code-body').removeClass('col-md-6', 'diff-left').unwrap();
      $codeWindows = $('.submission-code-body .highlight');
      $codeBlocks = $codeWindows.find('td.code > pre');
      restoreCodeBlocks();
      restoreOriginalLayout();
    } else {
      setTwoColumnLayout();
      findAdjacentTab().addClass('diff-view-old')
        .data('solution').forEach(createDiffBlock);
    }
    $submission.toggleClass('diff-view');
  };

  setTwoColumnLayout = function () {
    originalLayout = submissionViewLayout;
    $('.submission-code-actions').find('[data-action="enlarge"]')
      .eq(0).trigger('click');
    $('.submission-code-actions a:not(.btn-show-diff)').addClass('disabled');
  };

  restoreOriginalLayout = function () {
    $('.submission-code-actions a:not(.btn-show-diff)').removeClass('disabled');
    if (originalLayout !== 1) {
      $('.submission-code-actions').find('[data-action="shrink"]')
        .eq(0).trigger('click');
    }
  };

  // When the diff button is clicked, try to diff the active tab against
  // the previous iteration. If the active tab is the first iteration, then
  // diff against the second iteration.
  findAdjacentTab = function () {
    var otherTab = $activeTab.prev('.iterations-nav-item');
    if (otherTab.length < 1) {
      otherTab = $activeTab.next('.iterations-nav-item');
    }
    return otherTab;
  };

  restoreCodeBlocks = function () {
      $codeBlocks.each(function (index) {
        $(this).html(codeBlockCache[index]);
      });
  };

  $(function () {
    codeBlockCache = [];
    $codeWindows = $('.submission-code-body .highlight');
    $codeBlocks = $codeWindows.find('td.code > pre');
    $iterationsNavItems = $('.iterations-nav-item');
    $iterationsNavItemsInactive = $iterationsNavItems.not('.active');
    $activeTab = $iterationsNavItems.filter('.active');
    $submission = $('#submission');

    $codeBlocks.each(function () {
      codeBlockCache.push($(this).html());
    });

    // Only enable diff button when there is more than 1 iteration
    if ($iterationsNavItemsInactive.length > 0) {
      $iterationsNavItemsInactive.mouseenter(function () {
        if ($submission.hasClass('diff-view')) {
          // When there are more two iterations, allow selecting which iteration
          // to diff against by hovering over the not-diffed tabs
          if (!$(this).is('.diff-view-old')) {
            $iterationsNavItemsInactive.removeClass('diff-view-old');
            $(this).data('solution').forEach(updateDiffBlock);
            $(this).addClass('diff-view-old');
          }
        }
      });

      $('.btn-show-diff').show().removeClass('disabled').on('click', function (e) {
        e.preventDefault();
        toggleDiffView();
      });
    } else {
      $('.btn-show-diff').hide();
    }
  });
})();
