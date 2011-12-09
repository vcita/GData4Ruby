# vcita-GData4Ruby

## Introduction

GData4Ruby is a full featured wrapper for the Google Data base API.  GData4Ruby provides the ability to authenticate with GData using the ClientLogin method.  The package also includes a base gdata object  that can be subclassed to provide basic CRUD functions for all Google API service objects.  Additionally, a basic ACL object is included for interacting with ACL feeds and setting access rules.

## Author and Contact Information

GData4Ruby was created and is maintained by {Mike Reich}[mailto:mike@seabourneconsulting.com]  and is licenses under the LGPL v3.  You can find the text of the LGPL here: http://www.gnu.org/licenses/lgpl.html.  Feel free to use and update, but be sure to contribute your code back to the project and attribute as required by the license.

OAuth support was added by [edave](https://github.com/edave/)

### Website

http://cookingandcoding.com/gdata4ruby/

## Description

GData4Ruby has three major components: the service, the GData object and the AccessRule object.  Each service represents a google account, and includes a username (email) and a password.  You can use the GData service to authenticate either a google account or a google apps account. There are currently two types of services, Service, and OAuthService. 

Service uses Google's older [AuthSub](http://code.google.com/apis/accounts/docs/AuthSub.html) authentication mechanism, which is easier to setup, but requires you always know the username/password. (called Service to maintain backwards compatibility, but don't be confused, the base "Service" class is named Base)

OAuthService uses Google's newest authentication mechanism, [OAuth](http://code.google.com/apis/accounts/docs/OAuth.html), which is an OpenID-esque login system.

See Google's [Getting Started](http://code.google.com/apis/accounts/docs/GettingStarted.html) for more info on which mechanism is best for you. In general, it will likely be easiest to experiment with GData4Ruby using AuthSub and then switch to OAuth for any actual usage in your web app, etc.

The GData object provides a base class for interacting with Google API objects, i.e. Documents, Events, etc.  The GData object contains common attributes present in all Google API objects, and provides interfaces for basic CRUD functions.  This class is meant to be subclassed.

The AccessRule object provides a base class for interacting with Google Access Control Lists.  ACLs provide the main permissions mechanism for most Google API services.

## Examples

Below are some common usage examples.  For more examples, check the documentation.

### Service

1. Authenticate
    service = Service.new
    service.authenticate({:username => "user@gmail.com", :password => "password", :service => "cl"})

2. Authenticate with a specified GData version
	service = Service.new({:gdata_version => '3.0'})
	service.authenticate({:username => "user@gmail.com", :password => "password", :service => "cl"})
	
### OAuthService

You will need an OAuth Token for authenticating for any given user. If you are using Rails, [OAuth Plugin](https://github.com/pelle/oauth-plugin) makes this fairly easy for users to grant access to your application and generate [OAuth Tokens](http://code.google.com/p/oauth-plugin/wiki/AccessToken).

Once you have a token, authenticating is simple:

	service = OAuthService.new
	my_oauth_token = OAuth::AccessToken.new() # you will need to generate your own OAuth::Token
	service.authenticate({:access_token=>my_oauth_token})

	

## Base Options

GData4Ruby supports several options which are passed to any service (Base, Service, OAuthService) upon initialization using a hash

Enable SSL:

	my_generic_service = Service.new({:use_ssl => true})

Enable Debug Logging:

	my_generic_service = Service.new({:debug => true})
	
Disable checking whether the objects are publicly accessibly. This can significantly speed up the service, but also leaves you at risk of trying write to Google services which you do not have privileges. In many cases, you can disable this option.

	my_generic_service = Service.new({:check_public => false})
