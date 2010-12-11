# Author:: David Pitman (ui-design@vestaldesign.com )
# Copyright:: Copyright (C) 2010 David Pitman
# License:: LGPL v2.1
#--
# Licensed under the Lesser General Public License (GPL), Version 2.1 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.gnu.org/licenses/lgpl-2.1.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# Feel free to use and update, but be sure to contribute your
# code back to the project and attribute as required by the license.
#++
require 'gdata4ruby/base' 

module GData4Ruby
  #The service class is the main handler for all direct interactions with the 
  #Google Data API.
  
  class OAuthService < Base
    #Convenience attribute contains the currently OAuth access token
    attr_reader :access_token
    
    #Accepts an optional attributes hash for initialization values, most likely :gdata_version
    def initialize(attributes = {})
      super(attributes)
      attributes.each do |key, value|
        if self.respond_to?("#{key}=")
          self.send("#{key}=", value)
        end
      end    
    end
    
    # The method is a generic hash to allow subclasses to easily receive args for their own type of authentication
    # In this case, we're using an OAuth AccessToken - http://oauth.rubyforge.org/rdoc/classes/OAuth/AccessToken.html
    def authenticate(options = {})
      @access_token = options[:access_token]
    end
    
    def reauthenticate(options = {})
      @access_token ||= options[:access_token]
    end
    
    
    def authenticated?
      return (@access_token != nil)
    end
    
    private
    
    def do_request(request)
      log("Sending request\nHeader: #{request.headers.inspect.to_s}\nContent: #{request.content.to_s}\n")
      set_protocol!(request.url)
      ret = case request.type
          when :get
            @access_token.get(request.url.to_s, request.headers)
          when :post
            @access_token.post(request.url.to_s, request.content, request.headers)
          when :put
            @access_token.put(request.url.to_s, request.content, request.headers)
          when :delete
            @access_token.delete(request.url.to_s, request.headers)
      end
      
      while ret.is_a?(Net::HTTPRedirection)
        log("Redirect received, resending request")
        request.parameters = nil
        request.url = ret['location']
        log("sending #{request.type} to url = #{request.url.to_s}")
        ret = do_request(request)
      end
      if not ret.is_a?(Net::HTTPSuccess)
        log("invalid response received: "+ret.code)
        raise HTTPRequestFailed, ret.body
      end
      log("20x response received\nResponse: \n"+ret.read_body)
      return ret
    end

    # Not used in OAuth implementation...
    def get_http_object(location)
      return nil
    end
    
    # Not used in OAuth implementation...
    def add_auth_header(request)
      return nil
    end
  
  end
end