#= require 'views/charts/base_chart'

class App.Views.ChartsIndex extends Backbone.View
  el: '#charts'

  render: ->
    new App.Views.BaseChart().render()
    @
