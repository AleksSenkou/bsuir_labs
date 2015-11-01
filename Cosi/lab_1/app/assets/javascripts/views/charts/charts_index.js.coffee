class App.Views.ChartsIndex extends Backbone.View
  el: '#charts'

  initialize: ->
    @base = 'base-chart'
    @fastFourAmpl = 'fast-fourier-amplitude-chart'

  render: ->
    new App.Views.Chart(el: @base, points: gon.base_chart_points).render()
    new App.Views.Chart(el: @fastFourAmpl).render()
    @
