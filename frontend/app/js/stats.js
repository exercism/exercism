$(function () {
  if ($('#track-activity-chart').length !== 0) {
    var stats = $('#track-activity-chart').data('stats');
    var data = {
       labels : stats.labels,
       datasets : [
         {
           fillColor : "rgba(216, 29, 78, 0.5)",
           strokeColor : "rgba(216, 29, 78, 1)",
           pointColor : "rgba(216, 29, 78, 1)",
           pointStrokeColor : "#fff",
           data : stats.iterations
         },
         {
           fillColor : "rgba(33, 33, 33, 0.5)",
           strokeColor : "rgba(33, 33, 33, 1)",
           pointColor : "rgba(33, 33, 33, 1)",
           pointStrokeColor : "#fff",
           data : stats.reviews
         }
       ]
    };
    var ctx = $("#track-activity-chart").get(0).getContext("2d");
    new Chart(ctx).Bar(data, { /*options*/});
  }
});
