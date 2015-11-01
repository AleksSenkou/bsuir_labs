class App.Views.ChartsIndex extends Backbone.View
  el: '#charts'

  render: ->
    new App.Views.BaseChart().render()
    new App.Views.FastFourierAmplitudeChart().render()
    @
