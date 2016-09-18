#!/usr/bin/env ruby

libdir = File.join(File.dirname(__FILE__), "lib")

$: << libdir unless $:.include? libdir

require "y_tube"

olfactometer = Olfactometer.new_binary :name => "Y-Tube of DOOM!"

CONTROL = olfactometer.arms.find { |arm| arm.is_control? }
NEUTRAL = olfactometer.arms.find { |arm| arm.is_neutral? }
TEST    = olfactometer.arms.find { |arm| arm.is_test? }

subject = TestSubject.new :id => "blark"

subject.choices << Olfactometer::Choice.new( :olfactometer => olfactometer, :arm => NEUTRAL, :timestamp => "0:00", :subject => subject )
subject.choices << Olfactometer::Choice.new( :olfactometer => olfactometer, :arm => TEST, :timestamp => "0:32", :subject => subject )
subject.choices << Olfactometer::Choice.new( :olfactometer => olfactometer, :arm => NEUTRAL, :timestamp => "0:39", :subject => subject )
subject.choices << Olfactometer::Choice.new( :olfactometer => olfactometer, :arm => TEST, :timestamp => "1:01", :subject => subject )
subject.choices << Olfactometer::Choice.new( :olfactometer => olfactometer, :arm => NEUTRAL, :timestamp => "1:29", :subject => subject )
subject.choices << Olfactometer::Choice.new( :olfactometer => olfactometer, :arm => CONTROL, :timestamp => "1:33", :subject => subject )
subject.choices << Olfactometer::Choice.new( :olfactometer => olfactometer, :arm => CONTROL, :timestamp => "2:00", :subject => subject )

# Control: 27
# Neutral: 32 + 61-39 + 93-89 = 58
# Test:    7 + 28 = 35

puts "Control: " + subject.time_spent_in(CONTROL).to_s
puts "Neutral: " + subject.time_spent_in(NEUTRAL).to_s
puts "Test:    " + subject.time_spent_in(TEST).to_s
