# Author:: Mike Reich (mike@seabourneconsulting.com)
# Copyright:: Copyright (C) 2010 Mike Reich
# License:: GPL v2
#--
# Licensed under the General Public License (GPL), Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
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
  
  class Service < Base
    #Convenience attribute contains the currently authenticated account name
    attr_reader :account
    
    # The token returned by the Google servers, used to authorize all subsequent messages
    attr_reader :auth_token
    
    #Accepts an optional attributes hash for initialization values, most likely :gdata_version
    def initialize(attributes = {})
      super(attributes)
      attributes.each do |key, value|
        if self.respond_to?("#{key}=")
          self.send("#{key}=", value)
        end
      end    
    end
    
    # The authenticate method passes the username and password to google servers.  
    # If authentication succeeds, returns true, otherwise raises the AuthenticationFailed error.
    # Thanks to David King and Scott Taylor for Ruby 1.9 fix.
    def authenticate(options = {})
      username = options[:username]
      password = options[:password]
      service = options[:service]
      @auth_token = nil
      ret = nil
      auth_args = "Email=#{username}&Passwd=#{password}&source=GCal4Ruby&service=#{service}&accountType=HOSTED_OR_GOOGLE"
      log(auth_args)
      ret = send_request(Request.new(:post, @@auth_url, auth_args))
      if ret.class == Net::HTTPOK
        body = ret.read_body
        lines = body.send(body.respond_to?(:lines) ? :lines : :to_s).to_a
        @auth_token = lines.to_a[2].gsub("Auth=", "").strip
        @account = username
        @password = password
        return true
      else
        @auth_token = nil
        raise AuthenticationFailed
      end
    end
    
    def reauthenticate(options = {})
      options[:username] ||= @account
      options[:password] ||= @password
      authenticate(options)
    end
    
    def authenticated?
      log("Authenticated: #{@auth_token}")
      return (@auth_token != nil)
    end
  end
end