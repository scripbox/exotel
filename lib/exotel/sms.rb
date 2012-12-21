# -*- encoding: utf-8 -*-
require 'httparty'
module Exotel
  class Sms
    include HTTParty
    base_uri "https://twilix.exotel.in/v1/Accounts"
    
    def initialize
    end
    
    def send(params={})
      fields = {From: params[:from], To: params[:to], Body: params[:body]} 
      options = {body: fields, basic_auth: auth }
      response = self.class.post("/#{Exotel.exotel_sid}/Sms/send",  options)
      handle_response(response)
    end
   
    def details(sid)
      response = self.class.get("/#{Exotel.exotel_sid}/Sms/Messages/#{sid}",  basic_auth: auth)
      handle_response(response)
    end
    
    protected
    
    def auth
      {username: Exotel.exotel_sid, password: Exotel.exotel_token}
    end
    
    def handle_response(response)
      case response.code.to_i
 	    when 200...300 then Exotel::Response.new(response)
      when 401 then raise Exotel::AuthenticationError, "#{response.body} Verify your sid and token." 
 	    else
 	      raise Exotel::UnexpectedError, response.body
 	    end
    end
  end
end  



