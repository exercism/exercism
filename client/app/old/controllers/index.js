!function() {
  module.exports = function(ngModule) {

    require('./comments_controller')(ngModule);
    require('./markdown_controller')(ngModule);
    require('./pagination_controller')(ngModule);
  };
}(this);
