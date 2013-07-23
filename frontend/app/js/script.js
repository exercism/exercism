$(function() {
  $('.dropdown-toggle').dropdown();
  exercism.models.selectFilter = new exercism.models.SelectFilter();
  exercism.views.selectFilter = new exercism.views.SelectFilter({ model: exercism.models.selectFilter });
});

//TODO move all variable declaration to the tops of functions.
$(function() {
  $(".pending-submission").each(function(index,element) {
    var elem = $(element);

    elem.on("click",function() {
      var submissionURL = $(this).data('url');
      window.location = submissionURL;
    });

    var language = elem.data('language');
    $(".language",elem).tooltip({ title: language });

    var nitCount = elem.data('nits');
    $(".nits",elem).tooltip({ title: nitCount + " Nits" });

    var argumentCount = elem.data('arguments');
    $(".arguments",elem).tooltip({ title: argumentCount + " Responses" });
  });

  $(".code a[data-action='enlarge']").on("click",function() {
    var codeDiv = $(this).parents(".code");
    codeDiv.removeClass("span6");
    codeDiv.addClass("span12");
    $(this).hide();
    $("a[data-action='shrink']",codeDiv).show();
  });

  $(".code a[data-action='shrink']").on("click",function() {
    var codeDiv = $(this).parents(".code");
    codeDiv.removeClass("span12");
    codeDiv.addClass("span6");
    $(this).hide();
    $("a[data-action='enlarge']",codeDiv).show();
  });

  $("#code-timeline").on("click",function() {
    var revisionId = $(event.target).data("revision");
    $(event.target).toggleClass("selected");
    $('#revision-' + revisionId).toggle();
  });

  $('form input[type=submit], form button[type=submit]').on('click', function() {
    var $this = $(this);
    window.setTimeout(function() { $this.attr('disabled', true); }, 1);
  });


    $.organicTabs = function (el, options) {

        var base = this;
        base.$el = $(el);
        base.$nav = base.$el.find(".nav");

        base.init = function () {

            base.options = $.extend({}, $.organicTabs.defaultOptions, options);

            // Accessible hiding fix
            $(".hide").css({
                "position": "relative",
                "top": 0,
                "left": 0,
                "display": "none"
            });

            base.$nav.delegate("li > a", "click", function () {

                // Figure out current list via CSS class
                var curList = base.$el.find("a.current").attr("href").substring(1),

                // List moving to
                    $newList = $(this),

                // Figure out ID of new list
                    listID = $newList.attr("href").substring(1),

                // Set outer wrapper height to (static) height of current inner list
                    $allListWrap = base.$el.find(".list-wrap"),
                    curListHeight = $allListWrap.height();
                $allListWrap.height(curListHeight);

                if ((listID !== curList) && ( base.$el.find(":animated").length === 0)) {

                    // Fade out current list
                    var curListEl = base.$el.find("#" + curList);
                    curListEl.fadeOut(base.options.speed, function () {
                        var newListEl = base.$el.find("#" + listID);
                        var showNewTab = function (data) {
                            if(data){
                                // Replace new list element content with new data if specified
                                newListEl.find("li").html(data);
                            }

                            // Fade in new list on callback
                            newListEl.fadeIn(base.options.speed);

                            // Adjust outer wrapper to fit new list snuggly
                            var newHeight = newListEl.height();
                            $allListWrap.animate({
                                height: newHeight
                            });

                            // Remove highlighting - Add to just-clicked tab
                            base.$el.find(".nav li a").removeClass("current");
                            $newList.addClass("current");
                        };

                        if($(newListEl).hasClass("preview")){
                            base.options.loadPreview(curListEl, showNewTab);
                        }
                        else {
                            showNewTab(null);
                        }

                    });

                }

                // Don't behave like a regular link
                // Stop propagation and bubbling
                return false;
            });

        };
        base.init();
    };
    $.organicTabs.defaultOptions = {
        "speed": 300,
        loadPreview: function(el) {
            return $(el);
        }
    };

    $.fn.organicTabs = function (options) {
        return this.each(function () {
            (new $.organicTabs(this, options));
        });
    };

    $(".comment-form").organicTabs({
        loadPreview: function(curListEl, loadCallback) {
                var comment = $(curListEl).find(".js-comment-field").val();
                $.post("/preview", { 'comment': comment}, loadCallback);
        }
    })
});
