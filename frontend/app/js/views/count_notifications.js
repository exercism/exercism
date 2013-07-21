exercism.views.CountNotifications = Backbone.View.extend({
  events: {
    "click": "render"
  },

  initialize: function() {
    _.bindAll(this);
    this.listNotifications = new exercism.views.ListNotifications({
      collection: exercism.collections.notificationsList
    });
  },

  // TODO update notification badge

  render: function() {
    this.$el.append(this.listNotifications.render().el);
    return this;
  }
});
