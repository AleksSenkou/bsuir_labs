class Lab2.Routers.Charts extends Backbone.Router
  routes:
    '': 'chartsIndex'

  chartsIndex: ->
    model = Lab2.Views.ChartsIndex
    new model().render()
