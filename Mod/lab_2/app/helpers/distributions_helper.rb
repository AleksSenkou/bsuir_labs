module DistributionsHelper
  DIS = Distribution.find(1) if Distribution.any?

  def uniform
    DIS.a + (DIS.b - DIS.a) * Random.rand(0.0..1.0)    
  end

  def gauss
    DIS.mx + DIS.sigma * Math.sqrt(2) * (6.times.map { Random.rand(0.0..1.0) }.inject{ |sum, x| sum + x } - 3)
  end

  def exponential
    -Math.log(Random.rand(0.0..1.0)) / DIS.lambda 
  end

  def gamma
    -DIS.eta.times.map { Math.log(Random.rand(0.0..1.0)) }.inject{ |sum, x| sum + x } / DIS.lambda
  end

  def triangular
    DIS.a + (DIS.b - DIS.a) * 2.times.map { Random.rand(0.0..1.0) }.max    
  end

  def simpson
    2.times.map { Random.rand((DIS.a / 2)..(DIS.b / 2)) }.inject { |sum, x| sum + x }
  end
end
