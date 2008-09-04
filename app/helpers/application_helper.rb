# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def admin_page_title(page_title)
    #"<div class=\"adminPageTitle\">#{page_title}</div>"
    #"<h2>#{page_title}</h2>"
    content_for :title do 
      "<div span=\"24\" class=\"pageTitle\">#{page_title}</div>"
    end
  end

  def fancy_submit_button(label)
    '<button type="submit" class="button positive" style="margin-top: 10px">
      <img src="/stylesheets/blueprint/plugins/buttons/icons/tick.png" alt=""/>' + label +
    '</button>'
  end

  def show_logo
    image_tag "logo.png" if logo_exists?
  end
 
  def logo_exists?
    File.exists?("public/images/logo.png")
  end

  def notice_message(msg)
    "<span class=\"green\">#{msg}</span>"
  end

  def warning_message(msg)
    "<span class=\"red\">#{msg}</span>"
  end

  def fancy_notice_message(msg)
    "<div class=\"success\">#{msg}</div>"
  end

  def fancy_warning_message(msg)
    "<div class=\"error\">#{msg}</div>"
  end
  
end
