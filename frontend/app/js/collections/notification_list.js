window.exercism.collections.NotificationList = Backbone.Collection.extend({
  url: '/api/v1/notifications',

  countUnread: function(){
    return this.reduce(function(memo, model) {
      if(model.attributes.unread) {
        return memo + 1;
      } else {
        return memo + 0;
      }
    }, 0);
  },
});
