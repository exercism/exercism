exercism.views.SelectFilter = Backbone.View.extend({
  el: $('#pending-submissions'),
  events: {
    "click a[data-action=set-filter]": "filterClick",
    "click input[data-action=set-filter]": "checkClick"
  },
  initialize: function() {
    this.render();
  },
  filter: function (filter, value) {
   this.$('div[data-' + filter + '][' + 'data-' + filter + '!=' + value + ']').hide();
   this.$('a#all-' + filter).show();
  },
  showAll: function () {
   this.$('.pending-submission').show();
  },
  unfilter: function (filter) {
    var label = this.$('button[data-filter=' + filter + ']').attr('data-label');
   this.$('button[data-filter=' + filter + ']>span').first().html(label);
   this.$('div[data-' + filter + ']').show();
   this.$('a#all-' + filter).hide();
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
   this.$('button[data-filter=user]>span').first().html((this.model.get('user') === "All") ? "User" : this.model.get('user'));
   this.$('button[data-filter=exercise]>span').first().html((this.model.get('exercise') === "All") ? "Exercise" : this.model.get('exercise'));
   this.$('button[data-filter=language]>span').first().html((this.model.get('language') === "All") ? "Language" : this.model.get('language'));
    if (this.model.get('nits') !== 'All') {
      this.$('input[data-filter=nits]').prop('checked', true);
    }
    if (this.model.get('arguments') !== 'All') {
      this.$('input[data-filter=arguments]').prop('checked', true);
    }

  },

  render: function() {
    this.renderFilters();
    this.renderComponents();
  },
  filterClick: function (event) {
    event.preventDefault();
    var value = this.$(event.currentTarget).html().trim();
    var target = this.$(event.currentTarget).attr('data-target');
    var filter = this.$(target).attr('data-filter');
    this.model.set(filter, value);
    exercism.routers.application.navigate(this.model.getRoute(), {trigger: true} );
  },
  checkClick: function (event) {
    var filter = this.$(event.currentTarget).attr('data-filter');
    this.model.setCheck(filter, this.$(event.currentTarget).is(':checked'));
    exercism.routers.application.navigate(this.model.getRoute(), {trigger: true} );
  }
});

