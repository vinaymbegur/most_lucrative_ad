require File.dirname(__FILE__) + '/lib/lucrative_ad.rb'
require "rubygems"
require "csv"

puts "Most lucrative advertisement combination is - \n #{Lucrative::Ad.new.most_lucrative_combination}"