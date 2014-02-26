exercism.views.ListNotifications = Backbone.View.extend({
  template: JST["app/templates/list_notifications.us"],

  id: "list-notifications",

  initialize: function(options) {
    this.listenTo(this.collection, 'add', this.addOne);
  },

  render: function() {
    this.$el.html(this.template());
    return this;
  },

  canToggle: function() {
    this.collection.models.length === 0;
  },

  toggle: function() {
    if (!this.canToggle()) {
      return;
    }
    this.$el.toggleClass("reveal-notifications");
    $("body").toggleClass("reveal-notifications");
  },

  addAll: function() {
    this.collection.each(this.addOne, this);
  },

  addOne: function(model) {
    view = new exercism.views.Notification({model: model});
    view.render();
    this.$("#contains-notifications").append(view.el);
    model.on('remove', view.remove, view);
  }

});
