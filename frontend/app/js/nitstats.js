$(function () {
  if ($('#nitstat-chart').length !== 0) {

    var stats = $('#nitstat-chart').data('stats');

    var data = {
       labels : stats.labels,
       datasets : [
         {
           fillColor : "rgba(151,187,205,0.5)",
           strokeColor : "rgba(151,187,205,1)",
           pointColor : "rgba(151,187,205,1)",
           pointStrokeColor : "#fff",
           data : stats.given
         },
         {
           fillColor : "rgba(220,220,220,0.5)",
           strokeColor : "rgba(220,220,220,1)",
           pointColor : "rgba(220,220,220,1)",
           pointStrokeColor : "#fff",
           data : stats.received
         }
       ]
    };
    var ctx = $("#nitstat-chart").get(0).getContext("2d");
    new Chart(ctx).Line(data, {
      scaleOverride : true,
      scaleSteps : stats.steps,
      scaleStepWidth : stats.step,
      scaleStartValue : 0,
      responsive: true,
      bezierCurve: false 
    });
  }
});