$(".track-activity-chart").each(function(index, element) {
  var stats = $(element).data('stats');
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
  var ctx = element.getContext("2d");
  new Chart(ctx).Bar(data, { /*options*/});
});

