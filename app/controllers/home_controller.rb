class HomeController < ApplicationController

  before_filter :get_facebook_connect_url
  def index
      @page_title = "Home"
      @index_tab = "logout"      
      @keywords = Keyword.desc.page params[:page]
  end

  def about_us
    @page_title = "About us"
    @about_us_tab = "logout"
  end

  def privacy_policy
    @page_title = "Privacy policy"    
    @privacy_policy_tab = "logout"
  end
  
  def render_record
    id = params[:id]
    #keyword = Keyword.where(_id: id).first
    if request.xhr?
      @posts = Post.where(keyword_id: id).limit(25)
    else
      @posts = Post.where(keyword_id: id).page(params[:page]).per(50)
    end
    #render :text => @posts.count and return
    respond_to do |format|
      format.js      
      format.html      
      end
    #render :text => @posts._id and return
  end
  
  def login
      access_token_hash = MiniFB.oauth_access_token(FB_APP_ID, REDIRECT_URL, FB_SECRET, params[:code])
      @access_token = access_token_hash["access_token"]
      cookies[:acess_token] = @access_token
      @id = "me"
      @type = nil # (optional) nil will just return the object data directly
      @response_hash = MiniFB.get(@access_token, @id, :type=>@type)      
      # @response_hash is a hash, but also allows object like syntax for instance, the following is true:
      #@response_hash["user"] = @response_hash.user
      #render :text => @response_hash.user and return
      first_name = @response_hash.first_name
      last_name = @response_hash.last_name
      email_id = @response_hash.email
      uuid = @response_hash.id.to_s
      cookies[:first_name] = first_name
      cookies[:uuid] = uuid      
      #render :text => uuid and return
      user = User.where(uuid: uuid).first
      if user
        #user.login_count = user.login_count.to_i+1
        #user.save!        
      else
        new_user = User.new
        new_user[:first_name] = first_name
        new_user[:last_name] = last_name
        new_user[:uuid] = uuid
        new_user[:email_id] = email_id
        new_user[:access_token] = @access_token
        new_user.save!
        #User.create()
        #render :text => "User been added" and return
      end
      #render :text => @response_hash and return
      redirect_to :root
  end
  
  def logout
    #cookies.delete :access_token
    cookies[:acess_token] = nil
    cookies[:first_name] = nil
    cookies[:last_name] = nil
    redirect_to :root
  end

  def search
    @page_title = "Search Result for #{params[:search]}"
    @index_tab = "logout"    
    @keywords = Keyword.text_search(params[:search]) 
    #render :text => @keywords.count and return
  end

end
