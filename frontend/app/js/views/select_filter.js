exercism.views.SelectFilter = Backbone.View.extend({
  el: $('#pending-submissions'),
  events: {
    "click .submission-filter-check": "checkClick"
  },
  filter: function (filter, value) {
    this.$('div[data-' + filter + '][' + 'data-' + filter + '!=' + value + ']').hide();
  },
  showAll: function () {
    this.$('.pending-submission').show();
  },
  filters: function (element, index, list) {
    if (element !== "All") {
      this.filter(index, element);
    }
  },
  renderFilters: function () {
    this.showAll();
    _.each(this.model.attributes, this.filters, this);
  },
  checkClick: function (event) {
    var filter = this.$(event.currentTarget).attr('data-filter');
    var checked = this.$(event.currentTarget).is(':checked');
    this.model.setCheck(filter, checked);
    this.renderFilters();
  }
});

