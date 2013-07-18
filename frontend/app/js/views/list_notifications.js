exercism.views.ListNotifications = Backbone.View.extend({
  template: JST["app/templates/notifications.us"],

  id: "notifications-list",

  render: function() {
    this.$el.html(this.template()).toggle();
    return this;
  }

});
