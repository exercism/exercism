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
    this.$('div[data-nits][data-nits!=0]').toggle(!this.model.get("nits"));
  },

  filterOpinions: function () {
    this.$('div[data-opinions][data-opinions!=1]').toggle(!this.model.get("opinions"));
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

