exercism.views.SelectFilter = Backbone.View.extend({
  el: $('body'),
  events: {
    "click a[data-action=set-filter]": "filterClick",
    "click input[data-action=set-filter]": "checkClick"
  },
  filter: function (filter, value) {
    $('div[data-' + filter + '][' + 'data-' + filter + '!=' + value + ']').hide();
    $('a#all-' + filter).show();
  },
  showAll: function () {
    $('.pending-submission').show();
  },
  unfilter: function (filter) {
    var label = $('button[data-filter=' + filter + ']').attr('data-label');
    $('button[data-filter=' + filter + ']>span').first().html(label);
    $('div[data-' + filter + ']').show();
    $('a#all-' + filter).hide();
  },
  filters: function (element, index, list) {
    if (element === "All") {
      this.unfilter(element);
    } else {
      this.filter(index, element);
    }
  },
  renderFilters: function () {
    this.showAll();
    _.each(this.model.attributes, this.filters, this);
  },
  filterClick: function (event) {
    var value = $(event.currentTarget).html().trim();
    var target = $(event.currentTarget).attr('data-target');
    var filter = $(target).attr('data-filter');
    this.model.set(filter, value);
    $(target + '>span').first().html(value);
    this.renderFilters();
  },
  checkClick: function (event) {
    var filter = $(event.currentTarget).attr('data-filter');
    this.model.setCheck(filter, $(event.currentTarget).is(':checked'));
    this.renderFilters();
  }
});

