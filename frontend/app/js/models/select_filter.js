exercism.models.SelectFilter = Backbone.Model.extend({
  defaults: {
    nits: $("#submission-filter-nits").attr("data-selected"),
    arguments: $("#submission-filter-arguments").attr("data-selected")
  },
  setCheck: function (attribute, value) {
    this.set(attribute, value ? "0" : "All" );
  }
});
