class Keyword
  include Mongoid::Document
  #include Mongoid::FullTextSearch
  #include Mongoid::Search
  include Mongoid::Searchable
  field :name, type:String
  field :youtube_crawled, type:Integer, :default => 0
  field :vimeo_crawled, type:Integer, :default => 0
  field :facebook_crawled, type:Integer, :default => 0
  field :twitter_crawled, type:Integer, :default => 0
  #index :name, unique: true
  embeds_many :posts
  
  validates_presence_of :name
  validates_uniqueness_of :name
  #search_in :name, { :match => :any }
  #fulltext_search_in :name, :index_name => 'name_index'
  searchable :name
  
  def self.crawler
      require 'nokogiri'
      require 'open-uri'
      doc = Nokogiri::HTML(open('http://www.google.com/trends/hottrends?sa=X'))
      doc.css('.hotColumn a').each do |keyword|        
        begin
          Keyword.create(:name => keyword.content)        	
        rescue =>  e
           puts e.message 
        end	
      end		
      Post.crawler
  end
		
end
