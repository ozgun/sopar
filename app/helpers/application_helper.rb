# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def admin_page_title(page_title)
    content_for :title do 
      "<div class=\"span-24 pageTitle\">#{page_title}</div>"
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

  def time_my_format(time)
    time.strftime("%d/%m/%Y  %H:%M") if time
  end
  
  def time_only_date(time)
    time.strftime("%d/%m/%Y")
  end

  def print_tags(article)
    ret = ""
    if article.tag_list.size > 0
      ret = "<div class=\"tags\"><em>Tags:</em> "
      ret += render :partial => "tags/tag", :collection => article.tags, :spacer_template => "tags/tag_divider"
      ret += "</div>"
    end
    return ret
  end

  def rss_description
    "Feed description goes here..."
  end

  def custom_pagination(items)
    will_paginate items, {:prev_label => "&laquo; Previous", :next_label => "Next &raquo;"}
  end

end
