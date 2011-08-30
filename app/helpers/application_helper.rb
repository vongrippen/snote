module ApplicationHelper
  def google_analytics
    render :partial => 'shared/analytics' if Rails.env == 'test'
  end
  
  def coderay(text)
    text.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
      content_tag("notextile", CodeRay.scan($3, $2).div(:css => :class))
    end
  end
end
