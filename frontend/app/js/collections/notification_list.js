window.exercism.collections.NotificationList = Backbone.Collection.extend({
  url: '/api/v1/notifications',

  initialize: function(){
    this.listenTo(this, "all", this.updateNewCount);
  },

  updateNewCount: function() {
    var previousNewCount = this.newCount || 0;
    this.newCount = this.countNew();
    if (this.newCount !== previousNewCount) {
      this.trigger("notification");
    }
    return this;
  },

  countNew: function() {
    return this.reduce(function(memo, model) {
      if (model.attributes.read) {
        return memo + 0;
      } else {
        return memo + 1;
      }
    }, 0);
  },

  hasNew: function() {
    if (this.countNew() > 0) {
      return true;
    } else {
      return false;
    }
  },
});
