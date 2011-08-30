module ApplicationHelper
  def google_analytics
    render :partial => 'shared/analytics' if Rails.env == 'test'
  end
  
  def textilize(text)
    Textilizer.new(text).to_html unless text.blank?
  end
end
