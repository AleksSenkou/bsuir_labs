#= require 'views/charts/base_chart'

class Lab2.Views.ChartsIndex extends Backbone.View
  el: '#charts'

  render: ->
    new Lab2.Views.BaseChart().render()
    @
