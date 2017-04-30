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
        jitter: 0.4
        name: groupLabel

class ReviewCountSummaryStats
  constructor: (@stats) ->
    periodRepeated = for period, reviewCounts of @stats.avg_daily_reviews_per_user_by_period
      period for reviewCount in reviewCounts
    @x = _.flatten(periodRepeated)
    @y = [].concat(_.values(@stats.avg_daily_reviews_per_user_by_period)...)

class ReviewLengthSummaryStats
  constructor: (@stats) ->
    periodRepeated = for period, reviewCounts of @stats.review_lengths_by_period
      period for reviewCount in reviewCounts
    @x = _.flatten(periodRepeated)
    @y = [].concat(_.values(@stats.review_lengths_by_period)...)

new ExperimentStatsBoxPlot('.review-quantity-summary-chart', ReviewCountSummaryStats).render()
new ExperimentStatsBoxPlot('.review-length-summary-chart', ReviewLengthSummaryStats).render()
