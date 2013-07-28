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
    this.countNotifications = new exercism.views.CountNotifications({
      collection: this.collection
    });
    this.listenTo(this.collection, "notification", this.render);
  },

  render: function() {
    this.$el.html(this.template({ style: this.buttonStyle() }));
    this.countNotifications.setElement(this.$('#count-notifications')).render();
    return this;
  },

  toggle: function() {
    this.listNotifications.toggle();
  },

  buttonStyle: function() {
    if (this.collection.hasNew()) {
      return " new";
    } else {
      return "";
    }
  },

});
