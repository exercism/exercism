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

class ExperimentStatsPlot
  constructor: (@selector, @statsProcessor, @stats = $('.review-data').data('stats')) ->

  render: ->
    $(@selector).each (_, container) => @renderPlot(container)

  renderPlot: (container) ->
    Plotly.newPlot(container, @datasets(), boxmode: 'group', legend: {orientation: 'h'})

  datasets: ->
    [] # override

  experimentGroups: ->
    'Control Group':      @stats.control
    'Experimental Group': @stats.experimental

  lineHeight: ->
    yValues = _.flatten(dataset.y for dataset in @datasets())
    Math.max(yValues...)

class ExperimentStatsBoxPlot extends ExperimentStatsPlot
  datasets: ->
    for groupLabel, data of @experimentGroups()
      groupStats = new @statsProcessor(data)
      plotlyOptions =
        x: groupStats.x
        y: groupStats.y
        type: 'box'
        name: groupLabel

class ReviewCountSummaryStats
  constructor: (@stats) ->
    @setX()
    @setY()

  setX: ->
    gamificationStartDate = new Date(@stats['gamification_start_date'])
    gamificationWithdrawalDate = new Date(@stats['gamification_withdrawal_date'])
    gamificationExperimentEndDate = new Date(@stats['gamification_experiment_end_date'])
    adjusted_dates = for date in @stats.dates
      datumDate = new Date(date)
      if datumDate < gamificationStartDate
        '2017-03-20'
      else if datumDate < gamificationWithdrawalDate
        '2017-04-04'
      else if datumDate < gamificationExperimentEndDate
        '2017-04-20'
    @x = adjusted_dates

  setY: ->
    @y = @stats.daily_review_count

class ReviewLengthSummaryStats
  constructor: (@stats) ->
    @setX()
    @setY()

  setX: ->
    gamificationStartDate = new Date(@stats.gamification_start_date)
    gamificationWithdrawalDate = new Date(@stats.gamification_withdrawal_date)
    gamificationExperimentEndDate = new Date(@stats.gamification_experiment_end_date)
    expandedDates = for i, dayLengths of @stats.daily_review_lengths
      @stats.dates[i] for length in dayLengths
    adjusted_dates = for date in _.flatten(expandedDates)
      datumDate = new Date(date)
      if datumDate < gamificationStartDate
        '2017-03-20'
      else if datumDate < gamificationWithdrawalDate
        '2017-04-04'
      else if datumDate < gamificationExperimentEndDate
        '2017-04-20'
    @x = adjusted_dates

  setY: ->
    @y = _.flatten(@stats.daily_review_lengths)

new ExperimentStatsBoxPlot('.review-quantity-summary-chart', ReviewCountSummaryStats).render()
new ExperimentStatsBoxPlot('.review-length-summary-chart', ReviewLengthSummaryStats).render()
