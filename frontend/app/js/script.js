//TODO move all variable declaration to the tops of functions.
var submissionViewLayout;

$(function() {
  $(".pending-submission, .work").each(function(index,element) {
    var elem = $(element);

    var language = elem.data('language');
    $(".language",elem).tooltip({ title: language });

    var nitCount = elem.data('nits');
    $(".nits",elem).tooltip({ title: nitCount + " Nits by Others" });

    var versionCount = elem.data('versions');
    $(".versions",elem).tooltip({ title: "Iteration " + versionCount });
  });

  $(".code a[data-action='enlarge']").on("click",function() {
    var codeDiv = $(this).parents(".code");
    var commentsDiv = codeDiv.siblings('.comments');
    codeDiv.removeClass($(this).data("old-class"));
    codeDiv.addClass($(this).data("new-class"));
    commentsDiv.removeClass($(this).data("old-class"));
    commentsDiv.addClass($(this).data("new-class"));
    $("a[data-action='enlarge']",codeDiv).hide();
    $("a[data-action='shrink']",codeDiv).show();
    window.scrollBy(0, $('.code').offset().top -
                       $('.theiaStickySidebar').offset().top);
    submissionViewLayout = 1; // One full-width column of code and comments
  });

  $(".code a[data-action='shrink']").on("click",function() {
    var codeDiv = $(this).parents(".code");
    var commentsDiv = codeDiv.siblings('.comments');
    codeDiv.removeClass($(this).data("old-class"));
    codeDiv.addClass($(this).data("new-class"));
    commentsDiv.removeClass($(this).data("old-class"));
    commentsDiv.addClass($(this).data("new-class"));
    $("a[data-action='shrink']",codeDiv).hide();
    $("a[data-action='enlarge']",codeDiv).show();
    submissionViewLayout = 2; // Two columns for code/comments
  });

  $('form').on('submit', function() {
    localStorage.clear(location.pathname);
    var $this = $(this).find(':submit');
    window.setTimeout(function() { $this.attr('disabled', true); }, 1);
  });

  $("form").submit(function() {
    $(this).submit(function() {
      return false;
    });
  });


  $('textarea').each(function () {
    var $this = $(this);
    var question_text = "You have unsaved changes on this page";
    var was_submitted = false;
    $this.parents("form").on('submit',function(e){
      was_submitted = true;
    });
    window.onbeforeunload = function (e) {
      var unsaved = $this.text() !== $this.val();
      if(!was_submitted && unsaved) {
        // see http://stackoverflow.com/questions/10311341/confirmation-before-closing-of-tab-browser
        e = e || window.event;

        if (e) {
            e.returnValue = question_text;
        }

        return question_text;
      }
    };
  });
  // Remove the window.onberofereload when deleting comments
  $("button[type='submit'][name='delete']").on('click', function(e){
    window.onbeforeunload = null;
  });

  // cmd + return submits nitpicks on mac ctrl + return submits on windows
  // from https://github.com/dewski/cmd-enter
  $(document).on('keydown', 'textarea', function(e) {
      if(e.keyCode === 13 && (e.metaKey || e.ctrlKey)) {
          $(this).parents('form').submit();
      }
  });

  $('.work-slug').popover({
    trigger: 'hover',
    placement: 'right',
    html: true,
    delay: {
      show: 600,
      hide: 100
    },
    content: 'use the command <code>exercism fetch</code> to add this assignment to your exercism directory'
  });



  $(".mute").each(function(index, element) {
    var elem = $(element);

    $(".mute-btn",elem).tooltip({ placement: "bottom", title: "Mute this submission until there is further activity." });
    $(".unmute-btn",elem).tooltip({ placement: "bottom", title: "Unmute this sumission." });
  });

  (function () {
    function localizeDateAndTime(input) {
      var date = input.replace(" at", "");
      var localizedTime = moment.utc(date, "D MMMM YYYY H:mm").local();

      var timeZone = moment.tz.guess();
      // America/Los_Angeles

      var timeZoneAbbrevation = moment.tz(localizedTime.format("YYYY-MM-DD"), timeZone).format('z');
      // PST or PDT

      var formattedTime = localizedTime.format("D MMMM YYYY [at] h:mm ");
      return formattedTime + timeZoneAbbrevation;
    }

    $.each( $("[data-title]"), function() {
      var localized = localizeDateAndTime(this.getAttribute("data-title"));
      this.setAttribute("data-title", localized);
    });

    $.each( $(".localize-time"), function() {
      var localized = localizeDateAndTime(this.innerHTML);
      this.innerHTML = localized;
    });
  }());

  $(".comment-meta a[data-action='reply']").click(function() {
    var commentBodyDiv = $(this).closest(".comment-body");
    var nitRaw = commentBodyDiv.data('nit-raw');
    var nitpicker = commentBodyDiv.data('nitpicker');

    // construct reply
    var nitQuoted = "@" + nitpicker + " commented:\n";
    nitQuoted += nitRaw.split('\n').map(function(x) { return "> " + x; }).join('\n');
    nitQuoted += '\n\n';

    // switch to 'Write' tab incase 'Preview' tab was selected
    $(".write_tab").find('a').trigger('click');

    // set reply
    var submissionCommentTextArea = $('#submission_comment');
    submissionCommentTextArea.val(nitQuoted);
    submissionCommentTextArea.trigger('input');
    submissionCommentTextArea.focus();
  });

});

// color change on hover for SVG logo in navbar
var hoverSVG = function(fill) {
  var svg = document.getElementById("logo-mark");
  var svgDoc = svg.contentDocument;
  var e = svgDoc.getElementById("shape");
  e.style.transition = "all 200ms ease-in-out";
  e.setAttribute("fill",fill);
};
var mouseoverSVG = function() {
  hoverSVG('#d81d4e');
};
var mouseoutSVG = function() {
  hoverSVG('#bbb');
};
$("#nav-brand").on('mouseover', mouseoverSVG);
$("#nav-brand").on('mouseout', mouseoutSVG);
