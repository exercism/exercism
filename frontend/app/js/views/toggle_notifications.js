exercism.views.ToggleNotifications = Backbone.View.extend({
  events: {
    "click": "toggle"
  },

  template: JST["app/templates/toggle_notifications.us"],

  initialize: function() {
    if(this.isAuthorizedUser()) {
      this.startNotificationCenter();
    }
    _.bindAll(this, 'close_on_esc');
    $(document).keyup(this.close_on_esc);
  },

  render: function() {
    this.$el.html(this.template({ style: this.buttonStyle() }));
    this.countNotifications.setElement(this.$('#count-notifications')).render();
    return this;
  },

  isAuthorizedUser: function() {
    return (this.el !== undefined);
  },

  startNotificationCenter: function() {
    this.listNotifications = new exercism.views.ListNotifications({
      collection: this.collection,
      el: $("#list-notifications")
    }).render();
    this.countNotifications = new exercism.views.CountNotifications({
      collection: this.collection
    });
    this.listenTo(this.collection, "notification", this.render);
    this.render();
    this.collection.fetch();
  },

  toggle: function() {
    this.listNotifications.toggle();
  },

  close_on_esc: function(event) {
    var notificationsAreVisible = this.listNotifications.$el.hasClass('reveal-notifications');
    var noInputHasFocus = $(':focus').length === 0;
    var keyIsEsc = event.keyCode === 27;

    if(notificationsAreVisible && noInputHasFocus && keyIsEsc) {
      this.toggle();
    }
  },

  buttonStyle: function() {
    if (this.collection.hasNew()) {
      return " new";
    } else {
      return "";
    }
  },

});
