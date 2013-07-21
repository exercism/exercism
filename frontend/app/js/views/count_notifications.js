exercism.views.CountNotifications = Backbone.View.extend({
  template: JST["app/templates/count_notifications.us"],

  tag: "span",

  initialize: function() {
    console.log("am I real")
    this.listenTo(this.collection, "add", this.render);
  },

  render: function() {
    console.log(this.collection);
    this.$el.html(this.template({ count: this.collection.length }));
  },
});
