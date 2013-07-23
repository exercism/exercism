exercism.routers.Application = Backbone.Router.extend({
  routes: {
    "*filters" : "applyFilters"
  },

  applyFilters: function(filters) {
    if (filters !== null) { exercism.views.selectFilter.model.setFromRoute(filters); }
    exercism.views.selectFilter.render();
  }
});
