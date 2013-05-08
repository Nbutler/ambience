class HomeController < ApplicationController
	require "hue"
	
	def initial
		@a = Hue::Hue.new
		@a.all_lights
		
		@alerts = {}
		@alerts["Short alert"] = "select"
		@alerts["Long alert"] = "lselect"
		@alerts["Stop alert"] = "none"
		
	end
	
	def schedule
		initial
		if params[:date]
			#converts time to utc
			time = Time.new(params[:date]["year"], params[:date]["month"], params[:date]["day"], params[:date]["hour"], params[:date]["minute"]).getutc
			#creates the attribute time in the neccessary format
			@time = "#{time.year}-#{time.month}-#{time.day}T#{time.hour}:#{time.min}:00"
		end
	end
	
	def party
		initial
		@effects = {}
		@effects["Fade"] = "colorloop"
		@effects["End Fade"] = "none"
	end
	
	def login
		initial
		@address = params[:address]
		@name = params[:name]
		
	end
	
	def index
		initial
		
	end
end
