exercism.models.Notification = Backbone.Model.extend({
  parse: function(response){
    return response.notification;
  },
});
