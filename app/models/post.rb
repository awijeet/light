class Post
  include Mongoid::Document
  #include Mongoid::FullTextSearch
  field :title, type: String
  field :description, type: String
  field :url, type: String
  field :thumbnail, type: String  
  belongs_to :post_category
  belongs_to :keyword
  has_many :likes

  #def to_s
   # '%s %s' % [title, description]
  #end

  #fulltext_search_in 

  validates_presence_of :title, :url
	validates_uniqueness_of :url
	
	def self.youtube_crawler 
		require 'youtube_it'
		client = YouTubeIt::Client.new
		keywords = Keyword.where(youtube_crawled: "0")
		keywords.each do |c|
			k = c.name			
				videos_search = client.videos_by(:query => "#{k}", :per_page => 50)
				videos_search.videos.each do |video|
				begin	
					thumbnail = video.thumbnails.first.url
					description = video.description
					title = video.title
					player_url = video.media_content[0].url
						post = Post.new
						post.title = title
						post.description = description
						post.thumbnail = thumbnail
						post.url = player_url
						post.keyword_id = c._id.to_s
						post.post_category_id = PostCategory.where(name: "Youtube" ).first._id.to_s
						post.save!											
					rescue => e
						puts  e.message 
					end		

					 begin
					 	c.youtube_crawled = 1
					 	c.save!				
					 rescue Exception => e
					 	p e.message		
					 end
              
					
			end 
		end	
	end
	
	def self.facebook_crawler
			keys = Keyword.all
			keys.each do |c|
				begin	
					k= c.name
					content = open(URI.encode("http://graph.facebook.com/search?q=#{k}&type=post&limit=50")).read
					hash_content = ActiveSupport::JSON.decode(content)
					hash_content["data"].each do |data|
						title = data["caption"]
						title = data["message"]
						id = data["id"]
						id_array = id.split("_")
						user_id = id_array[0]
						post_id = id_array[1]
						url = "http://www.facebook.com/"+user_id+"/posts/"+post_id
						#thumbnail = "https://graph.facebook.com/"+user_id+"/picture?type=large
						thumbnail = "https://graph.facebook.com/"+user_id+"/picture"					
						post = Post.new
						post.title = title
						post.description = title
						post.thumbnail = thumbnail
						post.url = url
						post.keyword_id = c._id.to_s
						post.post_category_id = PostCategory.where(name: "Facebook" ).first._id.to_s
						post.save!												
				end										
				rescue => e
					puts e.message
				end
		end	
	end
	
	def self.twitter_crawler
		celebrities = Keyword.find(:all)
		celebrities.each do |c|
			k = c.name
				content = open(URI.encode("http://search.twitter.com/search.json?q=#{k}")).read
				hash_content = ActiveSupport::JSON.decode(content)
				hash_content["results"].each do |data|
					thumbnail = data["profile_image_url"]
					title = data["text"]
					begin
						post = Post.new
						post.title = title
						post.description = title
						post.thumbnail = thumbnail
						post.keyword_id = c._id.to_s
						post.post_category_id = PostCategory.where(name: "Twitter" ).first._id.to_s
						post.url = "https://twitter.com/"+"#!/"+data["from_user"]+"/status/"+data["id_str"]
						post.save!												
					rescue => e
						puts e.message
					end	
				end
		end	
	end
	
	def self.vimeo_crawler
	keywords = Keyword.find(:all)
		keywords.each do |c|
			k = c.name
				k = URI.encode k
				doc = Nokogiri::XML(open("http://vimeo.com/tag:#{k}/rss"))
				title =  Array.new
				linkx = Array.new
				description = Array.new
				dc_creator = Array.new
				media_thumbnail = Array.new
				
				doc.xpath('.//link').each do |link|
					linkx << link.content
				end
				doc.xpath('.//description').each do |link|
					description << link.content
				end 
				doc.xpath('.//media:thumbnail').each do |link|
					media_thumbnail << link['url']
				end
				doc.xpath('.//title').each do |link|
					title << link.content
				end
				title.count.times do |i|
					if i <= 24
						begin
							video_id_fragment = linkx[i+1].split("http://vimeo.com/")
							video_id = video_id_fragment[1]
							post = Post.create!(:title => title[i+1],:description => description[i+1],:thumbnail => media_thumbnail[i],:post_category_id => PostCategory.where(name: "Vimeo" ).first._id.to_s.to_i,:keyword_id => c._id.to_s,:url => "http://player.vimeo.com/video/#{video_id}")
							#vimeo.post_id = post.id
							#vimeo.save!
						rescue => e
							puts e.message
						end #begin ends
					end	# if ends
			end # do ends
		end	# do ends	
	end 
	
	def self.google
		# Code for crawling content from google
	end
	
	def self.google_news
		require 'nokogiri'
		require 'open-uri'
		celebrities = Keyword.find(:all)
		celebrities.each do |c|
			k = c.name
			final_k = k.gsub(" ","+")
			search_url = "http://www.google.co.in/nwshp?oe=utf8&ie=utf8&source=uds&q="+final_k+"&hl=en&start=0"
			doc = Nokogiri::HTML(open(search_url))
				doc.css('.esc-wrapper').each do |keyword|
				
			end
		end	
		#doc = Nokogiri::HTML(open('http://www.google.co.in/trends/hottrends?sa=X'))
		#http://www.google.co.in/nwshp?oe=utf8&ie=utf8&source=uds&q=agent+vinod&hl=en&start=0
	end
	
	def self.google_blog
		#http://www.google.co.in/search?tbm=blg&hl=en&client=z2&q=agent+vinod
	end
	def self.crawler
		youtube_crawler
		facebook_crawler
		twitter_crawler
		vimeo_crawler
	end
end
