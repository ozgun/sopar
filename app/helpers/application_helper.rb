# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def admin_page_title(page_title)
    #"<div class=\"adminPageTitle\">#{page_title}</div>"
    #"<h2>#{page_title}</h2>"
    content_for :title do 
      "<h2>#{page_title}</h2>"
    end
  end

  def fancy_submit_button(label)
    '<button type="submit" class="button positive" style="margin-top: 10px">
      <img src="/stylesheets/blueprint/plugins/buttons/icons/tick.png" alt=""/>' + label +
    '</button>'
  end

  
end
