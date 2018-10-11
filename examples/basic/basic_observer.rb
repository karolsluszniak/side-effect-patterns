require_relative "../../lib/observer/main.rb"

class Subject
  def call
    num = rand(10)
    puts "Generated #{num}"
    SubjectSignal.new(num).emit
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

class SubjectSignal < Observer::Signal
  observed_by "SubjectObserver"

  attr_accessor :num

  def initialize(num)
    @num = num
  end
end

class SubjectObserver < Observer::Observer
  def handle
    SideEffect.new(payload.num).call
  end
end
