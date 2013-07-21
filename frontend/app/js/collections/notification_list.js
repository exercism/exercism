window.exercism.collections.NotificationList = Backbone.Collection.extend({
  url: '/api/v1/notifications',

  initialize: function(){
    this.listenTo(this, "all", this.updateUnread);
  },

  updateUnread: function() {
    var oldUnread = this.unread || 0;
    this.unread = this.countUnread();
    if (this.unread !== oldUnread) {
      this.trigger("notification");
    }
    return this;
  },

  countUnread: function() {
    return this.reduce(function(memo, model) {
      if (model.attributes.unread) {
        return memo + 1;
      } else {
        return memo + 0;
      }
    }, 0);
  },

  hasUnread: function() {
    if (this.countUnread() > 0) {
      return true;
    } else {
      return false;
    }
  },
});
