consts = %i[Service SideEffect]

puts "====> basic (call)"
require_relative "./basic_call.rb"
Service.new.call
consts.each { |const| Object.send(:remove_const, const) }
puts

puts "====> basic (pubsub)"
require_relative "./basic_pubsub.rb"
Service.new.call
consts.each { |const| Object.send(:remove_const, const) }
puts

puts "====> basic (observer)"
require_relative "./basic_observer.rb"
Service.new.call
consts.each { |const| Object.send(:remove_const, const) }
puts
