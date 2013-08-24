window.exercism.collections.NotificationList = Backbone.Collection.extend({
  url: '/api/v1/notifications',

  parse: function(response){
    return response.notifications.map(function(e) {
      return e.notification;
    });
  },

  initialize: function(){
    this.newCount = 0;
    this.listenTo(this, "all", this.updateNewCount);
  },

  updateNewCount: function() {
    var previousNewCount = this.newCount;
    this.newCount = this.countNew();
    if (this.newCount !== previousNewCount) {
      this.trigger("notification");
    }
    return this;
  },

  countNew: function() {
    return this.reduce(function(memo, model) {
      if (model.attributes.read === false) {
        return memo + 1;
      } else {
        return memo + 0;
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
