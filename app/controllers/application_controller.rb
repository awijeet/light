class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def get_facebook_connect_url
   @oauth_url = MiniFB.oauth_url(FB_APP_ID, # your Facebook App ID (NOT API_KEY)
                               REDIRECT_URL,#"http://www.yoursite.com/sessions/create", # redirect url
                              :scope=>MiniFB.scopes.join(",")) # This asks for all permissions
  end
end
