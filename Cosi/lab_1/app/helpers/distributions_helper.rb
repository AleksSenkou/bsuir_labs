# Methods for distribution
module DistributionsHelper
  DIS = Distribution.first if Distribution.any?
  NUM = 1_000_0

  def uniform
    NUM.times.map { DIS.a + (DIS.b - DIS.a) * Random.rand(0.0..1.0) }
  end

  def gauss
    NUM.times.map do
      DIS.mx + DIS.sigma * Math.sqrt(2) * (6.times.map {
        Random.rand(0.0..1.0) }.inject { |a, e| a + e } - 3)
    end
  end

  def exponential
    NUM.times.map { -Math.log(Random.rand(0.0..1.0)) / DIS.lambda }
  end

  def gamma
    NUM.times.map { -DIS.eta.times.map { Math.log(Random.rand(0.0..1.0)) }.inject{ |a, e| a + e } / DIS.lambda }
  end

  def triangular
    NUM.times.map { DIS.a + (DIS.b - DIS.a) * 2.times.map { Random.rand(0.0..1.0) }.max }
  end

  def simpson
    NUM.times.map { 2.times.map { DIS.a + (DIS.b - DIS.a) *
      Random.rand(0.0..1.0) }.inject { |a, e| a + e } }
  end
end
