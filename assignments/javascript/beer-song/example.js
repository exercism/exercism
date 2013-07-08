Beer = function() {
  this.sing = function(first, last) {
    if (typeof(first) === 'undefined') first = 99;
    if (typeof(last) === 'undefined') last = 0;

    var verses = [];
    for (i = first; i >= last; i--) {
      verses.push(this.verse(i));
    }

    return verses.join("\n");
  }

  this.verse = function(number) {
    var line1 = this.bottles(number).capitalize() + " of beer on the wall, ";
    var line2 = this.bottles(number) + " of beer.\n";
    var line3 = this.action(number);
    var line4 = this.next_bottle(number);

    return [line1, line2, line3, line4].join("");
  }

  this.bottles = function(number) {
    var str = ""

    if (number === 0) {
      str = "no more bottles";
    } else if (number === 1) {
      str = "1 bottle";
    } else {
      str = number + " bottles";
    }

    return str
  }

  this.action = function(current_verse) {
    var str = "";

    if (current_verse === 0) {
      str = "Go to the store and buy some more, ";
    } else {
      sbj = (current_verse === 1 ? "it" : "one")
      str = "Take " + sbj + " down and pass it around, ";
    }

    return str;
  }

  this.next_bottle = function(current_verse) {
    return this.bottles(next_verse(current_verse)) + " of beer on the wall.\n";
  }

  this.next_verse = function(current_verse) {
    return current_verse === 0 ? 99 : (current_verse - 1);
  }

  String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
  }

  return this;
}();
