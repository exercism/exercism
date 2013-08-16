exercism.views.SelectFilter = Backbone.View.extend({
  el: $('#pending-submissions'),

  events: {
    "click #filter-nits": "nitHandler",
    "click #filter-opinions": "opinionHandler",
  },

  initialize: function(options) {
    this.listenTo(this.model, "change", this.render);
  },

  filterNits: function () {
    if (this.model.get('nits')) { this.$('div[data-nits][data-nits!=0]').hide(); }
  },

  filterOpinions: function () {
    if (this.model.get('opinions')) { this.$('div[data-opinions][data-opinions!=1]').hide(); }
  },

  showAll: function () {
    this.$('.pending-submission').show();
  },

  render: function () {
    this.showAll();
    this.filterNits();
    this.filterOpinions();
  },

  nitHandler: function (event) {
    this.model.set("nits", $(event.currentTarget).is(':checked'));
  },

  opinionHandler: function (event) {
    this.model.set("opinions", $(event.currentTarget).is(':checked'));
  },
});

