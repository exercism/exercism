exercism.views.CountNotifications = Backbone.View.extend({
  template: JST["app/templates/count_notifications.us"],

  tag: "span",

  initialize: function() {
    this.listenTo(this.collection, "notification", this.render);
  },

  render: function() {
    console.log(this.collection);
    this.$el.html(this.template({ count: this.collection.countUnread() }));
  },
});
