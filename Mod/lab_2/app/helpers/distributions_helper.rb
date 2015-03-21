module DistributionsHelper
  DIS = Distribution.first if Distribution.any?

  def uniform
    5000.times.map { DIS.a + (DIS.b - DIS.a) * Random.rand(0.0..1.0) }   
  end

  def gauss
    5000.times.map { DIS.mx + DIS.sigma * Math.sqrt(2) * (6.times.map { Random.rand(0.0..1.0) }.inject{ |sum, x| sum + x } - 3) }
  end

  def exponential
    5000.times.map { -Math.log(Random.rand(0.0..1.0)) / DIS.lambda }
  end

  def gamma
    5000.times.map { -DIS.eta.times.map { Math.log(Random.rand(0.0..1.0)) }.inject{ |sum, x| sum + x } / DIS.lambda }
  end

  def triangular
    5000.times.map { DIS.a + (DIS.b - DIS.a) * 2.times.map { Random.rand(0.0..1.0) }.max }
  end

  def simpson
    5000.times.map { 2.times.map { Random.rand((DIS.a / 2)..(DIS.b / 2)) }.inject { |sum, x| sum + x } }
  end
end
