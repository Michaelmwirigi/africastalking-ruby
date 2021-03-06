require "AfricasTalking/version"
require 'httparty'
require 'httmultiparty'
require 'json'
require "AfricasTalking"
require 'pry'

module AfricasTalking
	
	class Token
		HTTP_CREATED     = 201
		HTTP_OK          = 200

		#Set debug flag to to true to view response body
		DEBUG            = true
		def initialize username, apikey, environment
			@username    = username
			@apikey      = apikey
			@environment = environment
		end

		def createAuthToken
			post_body = {
				'username' => @username
			}
			url = getApiHost() + "/auth-token/generate"
			response = sendJSONRequest(url, post_body)
			# binding.pry
			if(@response_code == HTTP_CREATED)
				r=JSON.parse(response, :quirky_mode => true)
				return AuthTokenResponse.new r["token"], r["lifetimeInSeconds"]
			else
				raise AfricasTalkingGatewayException, response
			end
		end

		def createCheckoutToken phoneNumber
			post_body = {
				'phoneNumber' => phoneNumber
			}
			url = getApiHost() + "/checkout/token/create"
			response = executePost(url, post_body)
			# binding.pry
			if(@response_code == HTTP_CREATED)
				r= JSON.parse(response, :quirky_mode => true)
				return CheckoutTokenResponse.new r['token'], r['description']
			else
				raise AfricasTalkingGatewayException, response
			end
		end

		private

			def executePost(url_, data_ = nil)
				uri		 	     = URI.parse(url_)
				http		     = Net::HTTP.new(uri.host, uri.port)
				http.use_ssl     = true
				headers = {
				   "apikey" => @apikey,
				   "Accept" => "application/json"
				}
				if(data_ != nil)
					request = Net::HTTP::Post.new(uri.request_uri)
					request.set_form_data(data_)
				else
				    request = Net::HTTP::Get.new(uri.request_uri)
				end
				request["apikey"] = @apikey
				request["Accept"] = "application/json"
				response          = http.request(request)

				if (DEBUG)
					puts "Full response #{response.body}"
				end

				@response_code = response.code.to_i
				return response.body
			end

			def sendJSONRequest(url_, data_)
				uri	       = URI.parse(url_)
				http         = Net::HTTP.new(uri.host, uri.port)
				http.use_ssl = true
				req          = Net::HTTP::Post.new(uri.request_uri, 'Content-Type'=>"application/json")
				
				req["apikey"] = @apikey
				req["Accept"] = "application/json"
				
				req.body = data_.to_json

				response  = http.request(req)
				# binding.pry
				if (DEBUG)
					puts "Full response #{response.body}"
				end

				@response_code = response.code.to_i
				return response.body
			end


			def getApiHost()
				if(@environment == "sandbox")
					return "https://api.sandbox.africastalking.com"
				else
					return "https://api.africastalking.com"
				end
			end
	end

	class AuthTokenResponse
		attr_accessor :token, :lifetimeInSeconds
		def initialize token_, lifetimeInSeconds_
			@token      = token_
			@lifetimeInSeconds = lifetimeInSeconds_
		end
	end
	class CheckoutTokenResponse
		attr_accessor :token, :description
		def initialize token_, description_
			@token      = token_
			@description = description_
		end
	end
end