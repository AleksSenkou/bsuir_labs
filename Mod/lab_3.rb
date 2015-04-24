class Peaks
  def initialize(count = 10_000)
    @count = count
    @info = { ro: 0, p1: 0, queue: 0, p2: 0 }
    @tops = { t0000: 0.0, t0100: 0.0, t0001: 0.0,
              t0011: 0.0, t0101: 0.0, t0111: 0.0,
              t1101: 0.0, t1100: 0.0, t0121: 0.0,
              t1111: 0.0, t0021: 0.0, t0221: 0.0,
              t1121: 0.0, t1221: 0.0 }
    @ro = 0.75
    @p1 = 0.7
    @p2 = 0.65
  end

  def new_state
    p2_works
    p1_works
    ro_works

    return [@info[:ro], @info[:p1], @info[:queue], @info[:p2]]
  end

  def get_stat
    @count.times {
      state = new_state
      if    state == [0, 0, 0, 0] then @tops[:t0000] += 1
      elsif state == [0, 0, 0, 1] then @tops[:t0001] += 1
      elsif state == [0, 0, 1, 1] then @tops[:t0011] += 1
      elsif state == [0, 0, 2, 1] then @tops[:t0021] += 1
      elsif state == [0, 1, 0, 0] then @tops[:t0100] += 1
      elsif state == [0, 1, 0, 1] then @tops[:t0101] += 1
      elsif state == [0, 1, 1, 1] then @tops[:t0111] += 1
      elsif state == [0, 1, 2, 1] then @tops[:t0121] += 1
      elsif state == [1, 1, 0, 0] then @tops[:t1100] += 1
      elsif state == [1, 1, 0, 1] then @tops[:t1101] += 1
      elsif state == [1, 1, 1, 1] then @tops[:t1111] += 1
      elsif state == [1, 1, 2, 1] then @tops[:t1121] += 1
      elsif state == [0, 2, 2, 1] then @tops[:t0221] += 1
      elsif state == [1, 2, 2, 1] then @tops[:t1221] += 1 end
    }
    make_tops_useful
  end

  def make_tops_useful
    @tops.each_key { |key,| @tops[key] /= @count }
  end

  def sum
    @tops.each_value.inject { |sum, val| sum + val }.round
  end

  def probability_of_blocking
    (sum - (@tops[:t0000] + @tops[:t0001] + @tops[:t0011] +
            @tops[:t0100] + @tops[:t0101] + @tops[:t0111])).round 2
  end

  def time_in_system
    (sum - @tops[:t0000]).round 2
  end

  def print_result
    puts "P0000: #{@tops[:t0000]}"
    puts "P0001: #{@tops[:t0001]}"
    puts "P0011: #{@tops[:t0011]}"
    puts "P0021: #{@tops[:t0021]}"
    puts "P0100: #{@tops[:t0100]}"
    puts "P0101: #{@tops[:t0101]}"
    puts "P0111: #{@tops[:t0111]}"
    puts "P0121: #{@tops[:t0121]}"
    puts "P0221: #{@tops[:t0221]}"
    puts "P1100: #{@tops[:t1100]}"
    puts "P1101: #{@tops[:t1101]}"
    puts "P1111: #{@tops[:t1111]}"
    puts "P1121: #{@tops[:t1121]}"
    puts "P1221: #{@tops[:t1221]}"
    puts
    puts "sum: #{sum}"
    puts "the probability of blocking: #{probability_of_blocking}"
    puts "time in system: #{time_in_system}"
  end

  private
    def p2_works
      if rand(0..1.0) < (1 - @p2) && @info[:p2] == 1
        @info[:p2] = 0

        if @info[:queue] != 0
          @info[:queue] -= 1
          @info[:p2] = 1
          if @info[:p1] == 2
            @info[:p1] = 0
            @info[:queue] += 1
            if @info[:ro] == 1
              @info[:ro] = 0
              @info[:p1] = 1
            end
          end
        end
      end
    end

    def p1_works
      if rand(0..1.0) < (1 - @p1) && @info[:p1] == 1
        @info[:p1] = 0

        if @info[:queue] == 0
          @info[:queue] = 1
          if @info[:p2] == 0
            @info[:queue] = 0
            @info[:p2] = 1
          end
        elsif @info[:queue] == 1
          @info[:queue] = 2
        else @info[:p1] = 2 end

        if @info[:ro] == 1 && @info[:p1] == 0
          @info[:ro] = 0
          @info[:p1] = 1
        end
      end
    end

    def ro_works
      if rand(0..1.0) < (1 - @ro) && @info[:ro] == 0
        if @info[:p1] == 0
          @info[:p1] = 1
        else @info[:ro] = 1 end
      end
    end
end

peak = Peaks.new 100_000
peak.get_stat
peak.print_result
