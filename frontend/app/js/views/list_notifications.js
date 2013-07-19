exercism.views.ListNotifications = Backbone.View.extend({
  template: JST["app/templates/notifications.us"],

  id: "list-notifications",

  render: function() {
    this.$el.html(this.template()).toggle();
    return this;
  }

});
