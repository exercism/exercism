exercism.views.Notification = Backbone.View.extend({
  template: JST["app/templates/notification.us"],

  tagName: "li",

  className: "notification message",

  events: {
    "click .check": "toggleRead"
  },

  initialize: function(options) {
    this.listenTo(this.model, 'change', this.render);
    this.listenTo(this.model, 'destroy', this.remove);
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    this.readStatus();
    return this;
  },

  toggleRead: function() {
    console.log("model marked read");
      this.model.save("read", !(this.model.get("read")));
  },

  readStatus: function() {
    this.$el.toggleClass("new-notification", !(this.model.get("read")));
  },
});
