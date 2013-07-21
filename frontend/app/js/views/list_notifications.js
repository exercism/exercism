exercism.views.ListNotifications = Backbone.View.extend({
  template: JST["app/templates/notifications.us"],

  id: "list-notifications",

  initialize: function(options) {
    this.listenTo(this.collection, 'add', this.addOne);
    this.collection.fetch();
  },

  render: function() {
    this.$el.html(this.template());
    this.addAll();
    return this;
  },

  toggle: function() {
    this.$el.toggle();
  },

  addAll: function() {
    this.collection.each(this.addOne, this);
  },

  addOne: function(model) {
    console.log(model);
    view = new exercism.views.Notification({model: model});
    view.render();
    this.$el.append(view.el);
    model.on('remove', view.remove, view);
  }

});
