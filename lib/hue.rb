require 'rubygems'
require 'json'
require 'rest-client'
require 'uri'

module Hue
	class Hue
	attr_accessor :url, :ip, :user, :id	
	def initialize
		@user = "benthemathwhiz"
		#grabs the ip address from the meethue website
		#requires hub to be connected to the meethue website
		ipcheck = JSON.parse(RestClient.get("http://www.meethue.com/api/nupnp"))
		#only one element array so the index is 0
		@ip = ipcheck[0]["internalipaddress"]
		#bridge id
		@id = ipcheck[0]["id"]
		#creates a common url for most functions
		@url = "#{ip}/api/#{user}"
	end
	
	def test
		abc = user
	end
	
	def selection(time)
		if time == 0
			puts "1. Turn light on or off"
			puts "2. Alert"
			puts "3. Give status of light" 
			puts "4. Schedules"
			puts "5. Exit"
		else
			puts "1. Turn light on or off"
			puts "2. Alert"
		end
		print "Choice: "
		choice = gets.chomp.to_i

		case choice
		when 1
			puts "Enter light number"
			light = gets.chomp
			puts "On or off (1 or 0)"
			choice = !gets.chomp.to_i.zero?
			state(light, choice, time)
		when 2
			puts "Enter light number"
			light = gets.chomp
			puts "Short or long (1 or 0)"
			type = gets.chomp.to_i
			alert(light, type, time)
		when 3
			puts "Enter light number"
			light = gets.chomp
			status(light)
		when 4
			puts "1. for schedule status", "2. to create a schedule", "3. to delete one"
			choice = gets.chomp.to_i
			schedule(choice)
		when 5
			exit
		end
	end
	
	def status(light)
		request("GET", "/lights/#{light}", 0)
	end
	
	def state(light, light_state, time)
		request("PUT", "/lights/#{light}/state", {"on" => light_state}, time)
	end
	
	def alert(light, type, time)
		if type == 1
			alert_type = "select"
		elsif type == 0
			alert_type = "lselect"
		else
			puts "Invalid choice"
		end
		request("PUT", "/lights/#{light}/state", {"on" => true, "alert" => "#{alert_type}"}, time)
	end
	
	def schedule_status(number)
		puts request("GET", "/schedules/#{number}", 0)
	end	
	
	def schedule_set()
		#for a reoccurring schedule I would have to split up the time into the separate integers and then add to the the day integer and setup a schedule to set a schedule
		print "Enter time: "
		time = gets.chomp
		selection(time)
	end
	
	def schedule_delete(light)
		a = 1
		
	end
	
	def schedule(choice)
		if choice == 1
			print "Enter schedule number: "
			number = gets.chomp
			schedule_status(number)
		elsif choice == 2
			schedule_set()
		elsif choice == 3
			puts "Enter light number"
			light = gets.chomp
			schedule_delete(light)
		else
			puts "Invalid selection"
		end
	end
	
	
	def request(type, path, body = {}, time)
		if time != 0
			RestClient.post "#{url}/schedules", { "command" => { "address" => "/api/benthemathwhiz#{path}", "method" => "#{type}", "body" => body}, "time" => "#{time}"}.to_json
		else	
			if type == "PUT"
				RestClient.put "#{url}#{path}", body.to_json
			elsif type == "POST"
				RestClient.post "#{url}#{path}", body.to_json
			elsif type == "GET"
				RestClient.get "#{url}#{path}"
			elsif type == "DELETE"
				RestClient.delete "#{url}#{path}", body.to_json
			else
				puts "Invalid type"
				exit
			end
		end
	end
	
	def meethue
#		meethue = "https://www.meethue.com/de-US/user/sendMessageToBridge?clipmessage="
#		command = [{"bridgeId" => "#{id}","clipCommand" => {"url" => "/api/0/lights/1/state","method" => "PUT","body" => {"bri" => 253,"on" => true,"xy" => [0.62576,0.31895]}}}]
#		RestClient.get 'https://www.meethue.com/en-US/user/sendMessageToBridge?clipmessage=[{"bridgeId":"001788fffe09742e","clipCommand":{"url":"/api/0/lights/1/state","method":"PUT","body":{"on":true}}}]'
#		RestClient.get 'https://www.meethue.com/en-US/user/sendMessageToBridge?clipmessage=%5B%7B"bridgeId":"001788fffe09742e"%2C"clipCommand":%7B"url":"/api/0/lights/1/state"%2C"method":"PUT"%2C"body":%7B"on":true%7D%7D%7D%5D'
#		abc = URI.escape 'https://www.meethue.com/en-US/user/sendMessageToBridge?clipmessage=[{"bridgeId":"001788fffe09742e","clipCommand":{"url":"/api/0/lights/1/state","method":"PUT","body":{"on":true}}}]'
#		RestClient.get URI.escape 'https://www.meethue.com/en-US/user/sendMessageToBridge?clipmessage=[{"bridgeId":"001788fffe09742e","clipCommand":{"url":"/api/0/lights/1/state","method":"PUT","body":{"on":true}}}]'
#		body = [{"bridgeId" => "001788fffe09742e","clipCommand" => {"url" => "/api/0/lights/1/state","method" => "PUT","body" => {"on" => false}}}]
#		RestClient.post "https://www.meethue.com/en-US/user/sendMessageToBridge%3Fclipmessage=", body.to_json	
	end
	
end
end
#controller = Hue.new
#controller.meethue
#loop do
#	controller.selection(0)
#end