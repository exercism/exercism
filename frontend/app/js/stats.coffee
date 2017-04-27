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

class ExperimentStatsLinePlot
  constructor: (@selector, @statsProcessor, @stats = $('.review-data').data('stats')) ->

  render: ->
    $(@selector).each (_, container) => @renderPlot(container)

  renderPlot: (container) ->
    experimentalReviewLengthStats = new @statsProcessor(@stats.experimental)
    experimental = {
      x: experimentalReviewLengthStats.x
      y: experimentalReviewLengthStats.y
      mode: 'lines+markers'
      line: {shape: 'spline'}
      hoverinfo: 'name+y'
      name: 'Experimental Group'
    }

    controlReviewLengthStats = new @statsProcessor(@stats.control)
    control = {
      x: controlReviewLengthStats.x
      y: controlReviewLengthStats.y
      mode: 'lines+markers'
      line: {shape: 'spline'}
      hoverinfo: 'name+y'
      name: 'Control Group'
    }

    lineHeight = Math.max(
      @stats.experimental.daily_review_count.concat(
        @stats.control.daily_review_count
      )...
    )

    gamificationBeginDate = @stats.experimental.gamification_start_date
    gamificationBegins = {
      x: [gamificationBeginDate, gamificationBeginDate]
      y: [0, lineHeight]
      mode: 'lines'
      name: 'Gamification Begins'
      hoverinfo: 'none'
    }

    gamificationWithdrawalDate = @stats.experimental.gamification_withdrawal_date
    gamificationWithdrawal = {
      x: [gamificationWithdrawalDate, gamificationWithdrawalDate]
      y: [0, lineHeight]
      mode: 'lines'
      name: 'Gamification Withdrawal'
      hoverinfo: 'none'
    }

    Plotly.newPlot(
      container,
      [control, experimental, gamificationBegins, gamificationWithdrawal],
      {legend: {orientation: 'h'}}
    )

class ExperimentStatsBoxPlot
  constructor: (@selector, @statsProcessor, @stats = $('.review-data').data('stats')) ->

  render: ->
    $(@selector).each (_, container) => @renderPlot(container)

  renderPlot: (container) ->
    experimentalReviewLengthStats = new @statsProcessor(@stats.experimental)
    experimental = {
      x: experimentalReviewLengthStats.x
      y: experimentalReviewLengthStats.y
      type: 'box'
      name: 'Experimental Group'
    }

    controlReviewLengthStats = new @statsProcessor(@stats.control)
    control = {
      x: controlReviewLengthStats.x
      y: controlReviewLengthStats.y
      type: 'box'
      name: 'Control Group'
    }

    lineHeight = Math.max(
      Math.max(controlReviewLengthStats.y...),
      Math.max(experimentalReviewLengthStats.y...)
    )

    gamificationBeginDate = @stats.experimental.gamification_start_date
    gamificationBegins = {
      x: [gamificationBeginDate, gamificationBeginDate]
      y: [0, lineHeight]
      mode: 'lines'
      name: 'Gamification Begins'
      hoverinfo: 'none'
    }

    gamificationWithdrawalDate = @stats.experimental.gamification_withdrawal_date
    gamificationWithdrawal = {
      x: [gamificationWithdrawalDate, gamificationWithdrawalDate]
      y: [0, lineHeight]
      mode: 'lines'
      name: 'Gamification Withdrawal'
      hoverinfo: 'none'
    }

    Plotly.newPlot(
      container,
      [control, experimental, gamificationBegins, gamificationWithdrawal],
      {legend: {orientation: 'h'}, boxmode: 'group'}
    )

class ReviewCountStats
  constructor: (@stats) ->
    @x = @stats.dates
    @y = @stats.daily_review_count

class ReviewLengthStats
  constructor: (@stats) ->
    @setX()
    @setY()

  setX: ->
    dailyLengths = @stats.daily_review_lengths
    expandedDates = for i, dayLengths of dailyLengths
      @stats.dates[i] for length in dayLengths
    @x = _.flatten(expandedDates)

  setY: ->
    @y = _.flatten(@stats.daily_review_lengths)

class ReviewCountSummaryStats
  constructor: (@stats) ->
    @setX()
    @setY()

  setX: ->
    daily_count = @stats.daily_review_count
    gamificationStartDate = new Date(@stats['gamification_start_date'])
    gamificationWithdrawalDate = new Date(@stats['gamification_withdrawal_date'])
    gamificationExperimentEndDate = new Date(@stats['gamification_experiment_end_date'])
    adjusted_dates = for i, day_count of daily_count
      datumDate = new Date(@stats.dates[i])
      if datumDate < gamificationStartDate
        '2017-03-20'
      else if datumDate < gamificationWithdrawalDate
        '2017-04-04'
      else if datumDate < gamificationExperimentEndDate
        '2017-04-20'
    @x = adjusted_dates

  setY: ->
    @y = @stats.daily_review_count

new ExperimentStatsLinePlot('.review-quantity-chart', ReviewCountStats).render()
new ExperimentStatsBoxPlot('.review-quantity-summary-chart', ReviewCountSummaryStats).render()
new ExperimentStatsBoxPlot('.review-length-chart', ReviewLengthStats).render()
