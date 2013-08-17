exercism.views.Notification = Backbone.View.extend({
  defaultTemplate: JST["app/templates/notification.us"],
  attemptTemplate: JST["app/templates/attempt_notification.us"],
  unlockedTemplate: JST["app/templates/unlocked_notification.us"],

  tagName: "li",

  className: "notification message",

  events: {
    "click": "toggleRead"
  },

  initialize: function(options) {
    this.listenTo(this.model, 'change', this.render);
    this.listenTo(this.model, 'destroy', this.remove);
    this.markReadIfAtPath();
  },

  markReadIfAtPath: function() {
    if(this.isAtPath()) {
      this.toggleRead();
    }
  },

  notificationType: function() {
    return this.model.get("regarding");
  },

  render: function() {
    switch (this.notificationType()) {
      case "code":
        this.$el.html(this.attemptTemplate(this.model.toJSON()));
        break;
      case "done":
        this.$el.html(this.unlockedTemplate(this.model.toJSON()));
        break;
      default:
        this.$el.html(this.defaultTemplate(this.model.toJSON()));
        break;
    }
    this.readStatus();
    return this;
  },

  toggleRead: function() {
    if(!(this.model.get("read"))) {
      this.model.save("read", true);
    }
  },

  readStatus: function() {
    this.$el.toggleClass("new-notification", !(this.model.get("read")));
  },

  isAtPath: function() {
    return (this.model.get("link") === window.location.pathname);
  },
});
