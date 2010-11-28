module ApplicationHelper
  
  def title 
    base_title = "photoNatic"
    if @title
      "#{base_title} | #{@title}"
    else
      "#{base_title}"
    end
  end
    
end
