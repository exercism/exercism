$(".track-activity-chart").each (index, element) ->
  stats = $(element).data('stats')
  data =
     labels: stats.labels
     datasets: [
       {
         fillColor: "rgba(216, 29, 78, 0.5)"
         strokeColor: "rgba(216, 29, 78, 1)"
         pointColor: "rgba(216, 29, 78, 1)"
         pointStrokeColor: "#fff"
         data: stats.iterations
       }, {
         fillColor: "rgba(33, 33, 33, 0.5)"
         strokeColor: "rgba(33, 33, 33, 1)"
         pointColor: "rgba(33, 33, 33, 1)"
         pointStrokeColor: "#fff"
         data: stats.reviews
       }
     ]
  ctx = element.getContext("2d")
  new Chart(ctx).Bar(data)

$('.review-quantity-chart').each (index, container) ->
  stats = $('.review-data').data('stats')
  experimental = {
    x: stats.experimental.dates
    y: stats.experimental.daily_review_count
    mode: 'lines+markers'
    line: {shape: 'spline'}
    hoverinfo: 'name+y'
    name: 'Experimental Group'
  }

  control = {
    x: stats.control.dates
    y: stats.control.daily_review_count
    mode: 'lines+markers'
    line: {shape: 'spline'}
    hoverinfo: 'name+y'
    name: 'Control Group'
  }

  lineHeight = Math.max(
    stats.experimental.daily_review_count.concat(
      stats.control.daily_review_count
    )...
  )

  gamificationBeginDate = stats.experimental.gamification_start_date
  gamificationBegins = {
    x: [gamificationBeginDate, gamificationBeginDate]
    y: [0, lineHeight]
    mode: 'lines'
    name: 'Gamification Begins'
    hoverinfo: 'none'
  }

  gamificationWithdrawalDate = stats.experimental.gamification_withdrawal_date
  gamificationWithdrawal = {
    x: [gamificationWithdrawalDate, gamificationWithdrawalDate]
    y: [0, lineHeight]
    mode: 'lines'
    name: 'Gamification Withdrawal'
    hoverinfo: 'none'
  }

  Plotly.newPlot(
    container,
    [experimental, control, gamificationBegins, gamificationWithdrawal],
    {legend: {orientation: 'h'}}
  )
