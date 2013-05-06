class HomeController < ApplicationController
	attr_accessor :a
	#include Hue
	require "hue"
  def index
	@a = Hue::Hue.new
  end
end
