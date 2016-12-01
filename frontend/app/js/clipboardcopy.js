function fallbackMessage(action) {
  var actionKey = (action === 'cut' ? 'X' : 'C');

  if (navigator.userAgent.match(/iPhone|iPad/i)) {
    return 'No support :(';
  }

  if (navigator.userAgent.match(/Mac/i)) {
    return 'Press ⌘-' + actionKey + ' to ' + action;
  }

  return 'Press Ctrl-' + actionKey + ' to ' + action;
}

$(document).ready(function() {
  $('a.copy-code').on('click', function(e) {
    e.preventDefault();
  });

  var clipboard = new Clipboard('.copy-code', {
    text: function(trigger) {
      return $(trigger.getAttribute('data-target')).text();
    }
  });

  clipboard.on('success', function(e) {
    $(e.trigger).popover({
      content: 'The submission code was successfully copied to your clipboard!',
      placement: 'bottom',
      container: 'body'
    }).popover('show');
  });

  clipboard.on('error', function(e) {
    $(e.trigger).popover({
      content: fallbackMessage(e.action),
      placement: 'bottom',
      container: 'body'
    }).popover('show');
  });

  $('.copy-code').on('mouseleave', function(e) {
    $(this).popover('destroy');
  });
});
