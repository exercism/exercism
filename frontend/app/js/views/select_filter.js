exercism.views.SelectFilter = Backbone.View.extend({
  el: $('body'),
  events: {
    "click a[data-action=set-filter]": "filterClick",
    "click input[data-action=set-filter]": "checkClick"
  },
  initialize: function() {
    this.render();
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

  renderComponents: function() {
    $('button[data-filter=user]>span').first().html((this.model.get('user') === "All") ? "User" : this.model.get('user'));
    $('button[data-filter=exercise]>span').first().html((this.model.get('exercise') === "All") ? "Exercise" : this.model.get('exercise'));
    $('button[data-filter=language]>span').first().html((this.model.get('language') === "All") ? "Language" : this.model.get('language'));
    if (this.model.get('nits') !== 'All') {
      $('input[data-filter=nits]').prop('checked', true);
    }
    if (this.model.get('arguments') !== 'All') {
      $('input[data-filter=arguments]').prop('checked', true);
    }

  },

  render: function() {
    this.renderFilters();
    this.renderComponents();
  },
  filterClick: function (event) {
    event.preventDefault();
    var value = $(event.currentTarget).html().trim();
    var target = $(event.currentTarget).attr('data-target');
    var filter = $(target).attr('data-filter');
    this.model.set(filter, value);
    exercism.routers.application.navigate(this.model.getRoute(), {trigger: true} );
  },
  checkClick: function (event) {
    var filter = $(event.currentTarget).attr('data-filter');
    this.model.setCheck(filter, $(event.currentTarget).is(':checked'));
    exercism.routers.application.navigate(this.model.getRoute(), {trigger: true} );
  }
});

