module ApplicationHelper
  def title
    @page_title ||= "Google Trend Aggregator"
  end
  
  def get_video_id thumbnail_url
    first_break=thumbnail_url.split('vi/')
    second_break = first_break[1].split('/default.jpg')
    video_id = second_break[0]
  end
  
  def delete(name)
    #options.stringify_keys!
    set_cookie("name" => name.to_s, "value" => "", "expires" => Time.at(0))
  end
end
