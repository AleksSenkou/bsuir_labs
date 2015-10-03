class App.Routers.Charts extends Backbone.Router
  routes:
    '': 'chartsIndex'

  chartsIndex: ->
    model = App.Views.ChartsIndex
    new model().render()
