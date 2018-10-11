consts = %i[Subject SideEffect]

puts "====> basic (call)"
require_relative "./basic_call.rb"
Subject.new.call
consts.each { |const| Object.send(:remove_const, const) }
puts

puts "====> basic (pubsub)"
require_relative "./basic_pubsub.rb"
Subject.new.call
consts.each { |const| Object.send(:remove_const, const) }
puts

puts "====> basic (observer)"
require_relative "./basic_observer.rb"
Subject.new.call
consts.each { |const| Object.send(:remove_const, const) }
puts
