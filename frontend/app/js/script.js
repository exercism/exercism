//TODO move all variable declaration to the tops of functions.
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
    $(this).hide();
    $("a[data-action='shrink']",codeDiv).show();
  });

  $(".code a[data-action='shrink']").on("click",function() {
    var codeDiv = $(this).parents(".code");
    var commentsDiv = codeDiv.siblings('.comments');
    codeDiv.removeClass($(this).data("old-class"));
    codeDiv.addClass($(this).data("new-class"));
    commentsDiv.removeClass($(this).data("old-class"));
    commentsDiv.addClass($(this).data("new-class"));
    $(this).hide();
    $("a[data-action='enlarge']",codeDiv).show();
  });

  $('form').on('submit', function() {
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

});
