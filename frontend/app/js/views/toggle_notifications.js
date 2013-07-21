exercism.views.ToggleNotifications = Backbone.View.extend({
  events: {
    "click": "toggle"
  },

  template: JST["app/templates/toggle_notifications.us"],

  initialize: function() {
    this.listNotifications = new exercism.views.ListNotifications({
      collection: this.collection,
      el: $("#list-notifications")
    }).render();
    this.toggle();
    this.countNotifications = new exercism.views.CountNotifications({
      collection: this.collection
    });
  },

  toggle: function() {
    this.listNotifications.toggle();
  },

  render: function() {
    this.$el.html(this.template());
    this.countNotifications.setElement(this.$('#count-notifications')).render();
    return this;
  }
});
