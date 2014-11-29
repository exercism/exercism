/*!
 * Theia Sticky Sidebar v1.2.2
 * https://github.com/WeCodePixels/theia-sticky-sidebar
 *
 * Glues your website's sidebars, making them permanently visible while scrolling.
 *
 * Copyright 2013-2014 WeCodePixels and other contributors
 * Released under the MIT license
 */

(function($) {
  $.fn.theiaStickySidebar = function(options) {
    var defaults = {
      'containerSelector': '',
      'additionalMarginTop': 0,
      'additionalMarginBottom': 0,
      'updateSidebarHeight': true,
      'minWidth': 0
    };
    options = $.extend(defaults, options);

    // Validate options
    options.additionalMarginTop = parseInt(options.additionalMarginTop) || 0;
    options.additionalMarginBottom = parseInt(options.additionalMarginBottom) || 0;
    
    // Add CSS
    $('head').append($('<style>.theiaStickySidebar:after {content: ""; display: table; clear: both;}</style>'));

    this.each(function() {
      var o = {};
      o.sidebar = $(this);

      // Save options
      o.options = options || {};

      // Get container
      o.container = $(o.options.containerSelector);
      if (o.container.size() == 0) {
        o.container = o.sidebar.parent();
      }

      // Create sticky sidebar
      o.sidebar.parents().css('-webkit-transform', 'none'); // Fix for WebKit bug - https://code.google.com/p/chromium/issues/detail?id=20574
      o.sidebar.css({
        'position': 'relative',
        'overflow': 'visible',
        // The "box-sizing" must be set to "content-box" because we set a fixed height to this element when the sticky sidebar has a fixed position.
        '-webkit-box-sizing': 'border-box',
        '-moz-box-sizing': 'border-box',
        'box-sizing': 'border-box'
      });
      
      // Get the sticky sidebar element. If none has been found, then create one.
      o.stickySidebar = o.sidebar.find('.theiaStickySidebar');
      if (o.stickySidebar.length == 0) {        
        o.sidebar.find('script').remove(); // Remove <script> tags, otherwise they will be run again on the next line.
        o.stickySidebar = $('<div>').addClass('theiaStickySidebar').append(o.sidebar.children());       
        o.sidebar.append(o.stickySidebar);
      }

      // Get existing top and bottom margins and paddings
      o.marginTop = parseInt(o.sidebar.css('margin-top'));
      o.marginBottom = parseInt(o.sidebar.css('margin-bottom'));
      o.paddingTop = parseInt(o.sidebar.css('padding-top'));
      o.paddingBottom = parseInt(o.sidebar.css('padding-bottom'));

      // Add a temporary padding rule to check for collapsable margins.
      var collapsedTopHeight = o.stickySidebar.offset().top;
      var collapsedBottomHeight = o.stickySidebar.outerHeight();
      o.stickySidebar.css('padding-top', 1);
      o.stickySidebar.css('padding-bottom', 1);
      collapsedTopHeight -= o.stickySidebar.offset().top;
      collapsedBottomHeight = o.stickySidebar.outerHeight() - collapsedBottomHeight - collapsedTopHeight;
      if (collapsedTopHeight == 0) {
        o.stickySidebar.css('padding-top', 0);
        o.stickySidebarPaddingTop = 0;
      }
      else {
        o.stickySidebarPaddingTop = 1;
      }
      
      if (collapsedBottomHeight == 0) {
        o.stickySidebar.css('padding-bottom', 0);
        o.stickySidebarPaddingBottom = 0;
      }
      else {
        o.stickySidebarPaddingBottom = 1;
      }

      // We use this to know whether the user is scrolling up or down.
      o.previousScrollTop = null;

      // Scroll top (value) when the sidebar has fixed position.
      o.fixedScrollTop = 0;
      
      // Set sidebar to default values.
      resetSidebar();

      o.onScroll = function(o) {
        // Stop if the sidebar isn't visible.
        if (!o.stickySidebar.is(":visible")) {
          return;
        }       
        
        // Stop if the window is too small.
        if ($('body').width() < o.options.minWidth) {
          resetSidebar();
          return;         
        }

        // Stop if the sidebar width is larger than the container width (e.g. the theme is responsive and the sidebar is now below the content)
        if (o.sidebar.outerWidth(true) + 50 >  o.container.width()) {
          resetSidebar();
          return;
        }

        var scrollTop = $(document).scrollTop();
        var position = 'static';

        // If the user has scrolled down enough for the sidebar to be clipped at the top, then we can consider changing its position.
        if (scrollTop >= o.container.offset().top + (o.paddingTop + o.marginTop - o.options.additionalMarginTop)) {
          // The top and bottom offsets, used in various calculations.
          var offsetTop = o.paddingTop + o.marginTop + options.additionalMarginTop;
          var offsetBottom =  o.paddingBottom + o.marginBottom + options.additionalMarginBottom;
          
          // All top and bottom positions are relative to the window, not to the parent elemnts.
          var containerTop = o.container.offset().top;
          var containerBottom = o.container.offset().top + getClearedHeight(o.container);
          
          // The top and bottom offsets relative to the window screen top (zero) and bottom (window height).
          var windowOffsetTop = 0 + options.additionalMarginTop;
          var windowOffsetBottom;
          
          var sidebarSmallerThanWindow = (o.stickySidebar.outerHeight() + offsetTop + offsetBottom) < $(window).height();
          if (sidebarSmallerThanWindow) {
            windowOffsetBottom = windowOffsetTop + o.stickySidebar.outerHeight();
          }
          else {
            windowOffsetBottom = $(window).height() - o.marginBottom - o.paddingBottom - options.additionalMarginBottom;
          }
          
          var staticLimitTop = containerTop - scrollTop + o.paddingTop + o.marginTop;
          var staticLimitBottom = containerBottom - scrollTop - o.paddingBottom - o.marginBottom;

          var top = o.stickySidebar.offset().top - scrollTop;
          var scrollTopDiff = o.previousScrollTop - scrollTop;
          
          // If the sidebar position is fixed, then it won't move up or down by itself. So, we manually adjust the top coordinate.
          if (o.stickySidebar.css('position') == 'fixed') {
            top += scrollTopDiff;
          }
          
          if (scrollTopDiff > 0) { // If the user is scrolling up.
            top = Math.min(top, windowOffsetTop);
          }
          else { // If the user is scrolling down.
            top = Math.max(top, windowOffsetBottom - o.stickySidebar.outerHeight());
          }

          top = Math.max(top, staticLimitTop);

          top = Math.min(top, staticLimitBottom - o.stickySidebar.outerHeight());
          
          // If the sidebar is the same height as the container, we won't use fixed positioning.
          var sidebarSameHeightAsContainer = o.container.height() == o.stickySidebar.outerHeight();
          
          if (!sidebarSameHeightAsContainer && top == windowOffsetTop) {
            position = 'fixed';
          }
          else if (!sidebarSameHeightAsContainer && top == windowOffsetBottom - o.stickySidebar.outerHeight()) {
            position = 'fixed';
          }
          else if (scrollTop + top - o.sidebar.offset().top - o.paddingTop <= options.additionalMarginTop) {
            position = 'static';
          }
          else {
            position = 'absolute';
          }
        }

        /*
         * Performance notice: It's OK to set these CSS values at each resize/scroll, even if they don't change.
         * It's way slower to first check if the values have changed.
         */
        if (position == 'fixed') {
          o.stickySidebar.css({
            'position': 'fixed',
            'width': o.sidebar.width(),
            'top': top,
            'left': o.sidebar.offset().left + parseInt(o.sidebar.css('padding-left'))
          });
        }
        else if (position == 'absolute') {
          var css = {};

          if (o.stickySidebar.css('position') != 'absolute') {
            css.position = 'absolute';
            css.top = scrollTop + top - o.sidebar.offset().top - o.stickySidebarPaddingTop - o.stickySidebarPaddingBottom;
          }

          css.width = o.sidebar.width();
          css.left = '';

          o.stickySidebar.css(css);
        }
        else if (position == 'static') {
          resetSidebar();
        }

        if (position != 'static') {
          if (o.options.updateSidebarHeight == true) {
            o.sidebar.css({
              'min-height': o.stickySidebar.outerHeight() + o.stickySidebar.offset().top - o.sidebar.offset().top + o.paddingBottom
            });
          }
        }
        
        o.previousScrollTop = scrollTop;
      };

      // Initialize the sidebar's position.
      o.onScroll(o);

      // Recalculate the sidebar's position on every scroll and resize.
      $(document).scroll(function(o) {
        return function() {
          o.onScroll(o);
        };
      }(o));
      $(window).resize(function(o) {
        return function() {
          o.stickySidebar.css({'position': 'static'});
          o.onScroll(o);
        };
      }(o));

      // Reset the sidebar to its default state
      function resetSidebar() {
        o.fixedScrollTop = 0;
        o.sidebar.css({
          'min-height': '1px'
        });
        o.stickySidebar.css({
          'position': 'static',
          'width': ''
        });
      }

      // Get the height of a div as if its floated children were cleared. Note that this function fails if the floats are more than one level deep.
      function getClearedHeight(e) {
        var height = e.height();

        e.children().each(function() {
          height = Math.max(height, $(this).height());
        });

        return height;
      }
    });
  }
})(jQuery);