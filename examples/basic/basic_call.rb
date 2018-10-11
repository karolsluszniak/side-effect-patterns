class Service
  def call
    num = rand(10)
    puts "Generated #{num}"
    SideEffect.new(num).call
    puts "Completed"
  end
end

class SideEffect
  def initialize(num)
    @num = num
  end

  def call
    puts "Acted on #{@num}"
  end
end
