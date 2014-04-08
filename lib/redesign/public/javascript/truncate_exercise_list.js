var truncate = function(div) {
  var excess = div.children('ul').children('li').slice(5);

  var toggle = function(target, replacement) {
    excess.toggle();
    target.detach();
    div.append(replacement);
  }

  if (excess.length > 0) {
    var less = $("<a href='#'>- less</a>");
    var more = $("<a href='#'>+ more</a>");

    less.on("click", function(e) {
      toggle(less, more);
      e.preventDefault();
    });

    more.on("click", function(e) {
      toggle(more, less);
      e.preventDefault();
    });

    less.click();
  }
};

$(".exercises.truncate").each(function() {
  truncate($(this));
});
