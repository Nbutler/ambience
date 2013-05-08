module Hue
	class Hue
	attr_accessor :url, :ip, :user, :id, :array
	
	def initialize
		@user = "benthemathwhiz"
		#only one element array so the index is 0
		@ip = "192.168.1.133"
		#bridge id
		#@id = ipcheck[0]["id"]
		#creates a common url for most functions
		@url = "#{ip}/api/#{user}"
	end
	
	#this is the one that would typically get used at home
	def local_host_only
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
		lights = JSON.parse(request("GET", "/lights", 0))
		i = 1
		while !lights[i.to_s].nil?
			i += 1
		end
	end
	
	def status(light)
		request("GET", "/lights/#{light}", 0)
	end
	
	def all_lights
		lights = JSON.parse(request("GET", "/lights", 0))
		i = 1
		@array = []
		while !lights[i.to_s].nil?
			@array[i] = lights[i.to_s]["name"]
			i += 1
		end
	end

	def create_group(lights = [], group_number)
		body[:lights] = lights
		request("PUT", "/groups/#{}", body, 0)
	end
	
	def state(light, light_state, brightness, color, alert_type, transition_time, effects, time)
		body = {}
		
		if light_state.to_i == 0
			state = false
		elsif light_state.to_i == 1
			state = true
		else
			state = nil
		end
		
		
		if state != nil
			body[:on] = state
		end
		
		if brightness != 0
			body[:bri] = brightness
		end
		
		if effects != 0
			body[:effect] = effects
		end
		
		if transition_time != 0
			body[:transitiontime] = transition_time
		end
		
		if alert_type != 0
			body[:alert] = alert_type
		end

		if color != 0
			#r = 0, g = 1, b = 2
			#result = rgb_to_xy(color[0], color[1], color[2])
			#body[:xy] = result
			body[:hue] = color
		end
		
		request("PUT", "/lights/#{light}/state", body, time)
	end
	
	#converts rgb values to xy, which are used for color in the hub
	#color picker I was using didn't work with twitter bootstrap
	#so I had to take out functionality that used this
	def rgb_to_xy(r, g, b)
		x1 = (1.076450*r) - (0.237662*g) + (0.161212*b)
		y1 = (0.410964*r) + (0.554342*g) + (0.034694*b)
		z1 = (-0.010954*r) - (0.013389*g) + (1.024343*b)

		x2 = x1 / (x1 + y1 + z1)
		y2 = y1 / (x1 + y1 + z1)
		
		return x2, y2
	end
		
	def schedule_status(number)
		request("GET", "/schedules/#{number}", 0)
	end	
	
	def schedule_delete(light)
		request("DELETE", "/schedules#{light}", 0)
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
			result = RestClient.post "#{url}/schedules", { "command" => { "address" => "/api/benthemathwhiz#{path}", "method" => "#{type}", "body" => body}, "time" => "#{time}"}.to_json
		else	
			if type == "PUT"
				result = RestClient.put "#{url}#{path}", body.to_json
			elsif type == "POST"
				result = RestClient.post "#{url}#{path}", body.to_json
			elsif type == "GET"
				result = RestClient.get "#{url}#{path}"
				return result
			elsif type == "DELETE"
				result = RestClient.delete "#{url}#{path}", body.to_json
			else
				puts "Invalid type"
				exit
			end
		end
		result = JSON.parse(result)
		if !result[0]["error"].nil?
			return "An error has occurred"
		end
	end	
	
#	def meethue
#		meethue = "https://www.meethue.com/de-US/user/sendMessageToBridge?clipmessage="
#		command = [{"bridgeId" => "#{id}","clipCommand" => {"url" => "/api/0/lights/1/state","method" => "PUT","body" => {"bri" => 253,"on" => true,"xy" => [0.62576,0.31895]}}}]
#		RestClient.get 'https://www.meethue.com/en-US/user/sendMessageToBridge?clipmessage=[{"bridgeId":"001788fffe09742e","clipCommand":{"url":"/api/0/lights/1/state","method":"PUT","body":{"on":true}}}]'
#		RestClient.get 'https://www.meethue.com/en-US/user/sendMessageToBridge?clipmessage=%5B%7B"bridgeId":"001788fffe09742e"%2C"clipCommand":%7B"url":"/api/0/lights/1/state"%2C"method":"PUT"%2C"body":%7B"on":true%7D%7D%7D%5D'
#		abc = URI.escape 'https://www.meethue.com/en-US/user/sendMessageToBridge?clipmessage=[{"bridgeId":"001788fffe09742e","clipCommand":{"url":"/api/0/lights/1/state","method":"PUT","body":{"on":true}}}]'
#		RestClient.get URI.escape 'https://www.meethue.com/en-US/user/sendMessageToBridge?clipmessage=[{"bridgeId":"001788fffe09742e","clipCommand":{"url":"/api/0/lights/1/state","method":"PUT","body":{"on":true}}}]'
#		body = [{"bridgeId" => "001788fffe09742e","clipCommand" => {"url" => "/api/0/lights/1/state","method" => "PUT","body" => {"on" => false}}}]
#		RestClient.post "https://www.meethue.com/en-US/user/sendMessageToBridge%3Fclipmessage=", body.to_json	
#	end
	
end
end
#controller = Hue.new
#controller.meethue
#loop do
#	controller.selection(0)
#end