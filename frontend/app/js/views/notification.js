exercism.views.Notification = Backbone.View.extend({
  template: JST["app/templates/notification.us"],

  events: {
    "click .unread-true": "read"
  },

  initialize: function(options) {
    this.listenTo(this.model, 'change', this.render);
    this.listenTo(this.model, 'destroy', this.remove);
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

  read: function() {
    this.model.save("unread", false);
  },
});
