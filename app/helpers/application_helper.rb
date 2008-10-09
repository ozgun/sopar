# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def logged_in?
    session[:user_id]
  end

  #This is for tag cloud 
  #include TagsHelper
  
  #FIXME: This should work in TagsHelper, I don't know why it's not working there!
  def tag_cloud(tags, classes)
    return if tags.empty?
    max_count = tags.sort_by(&:count).last.count.to_f
    tags.each do |tag|
      index = ((tag.count / max_count) * (classes.size - 1)).round
      yield tag, classes[index]
    end
  end

  def rss_link
    unless @site_options.feedburner.blank?
      @site_options.feedburner
    else
      "http://#{@site_options.domain}/rss.xml" 
    end
  end

  def screenshot_thumb_with_link(screenshot)
    link_to(screenshot_thumb(screenshot), screenshot.public_filename) if screenshot
  end

  def screenshot_thumb(screenshot)
    image_tag(screenshot.public_filename(:thumb), :class => "screenshotThumb") if screenshot
  end

  def admin_page_title(page_title)
    content_for :title do 
      "<div class=\"span-24 pageTitle\"><div class=\"span-16\">#{page_title}</div><div class=\"span-8 last\" style=\"text-align:right; font-weight: normal; font-size: 10px;\"><a href=\"/\">View Site</a> | <a href=\"/logout\">Logout</a></div></div>"
    end
  end

  def prepare_lightwindow
    content_for :head do 
      javascript_include_tag "lightwindow"
    end
    content_for :head do 
      stylesheet_link_tag 'lightwindow'
    end
  end

  def page_title(page_title)
    content_for :title do 
      "<div class=\"pageTitle\"><h3>#{page_title}</h3></div>"
    end
  end

  def browser_title
    content_for :browser_title do 
      "#{@article.title}"
    end
  end

  def fancy_submit_button(label)
    '<button type="submit" class="button positive" style="width: 110px;"><img src="/stylesheets/blueprint/plugins/buttons/icons/tick.png" alt="" id="submitButtonImage" />' + label +
    '</button>'
  end

  def show_logo
    image_tag "logo.png" if logo_exists?
  end
 
  def logo_exists?
    File.exists?("public/images/logo.png")
  end

  def clear_fields(p, arr)
    arr.each do |item|
      p.replace_html item, ""
    end
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
    time.strftime("%d/%m/%Y") if time
  end

  def date_human(time)
    time.to_formatted_s(:long_ordinal) if time
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

  def custom_pagination(items)
    will_paginate items, {:prev_label => "&laquo; Previous", :next_label => "Next &raquo;", :page_links => false, :class => 'digg_pagination' }
  end

  def yes_or_no(val)
    val == 1 ? "Yes" : "No"
  end

  def published_or_not(val)
    val == 1 ? "<font class=\"green\">Published</font>" : "<font class=\"red\">Un-published</font>"
  end

  def html_title
    if @article 
      " | #{@article.title}" 
    elsif @page
      " | #{@page.title}"
    elsif @project
      " | #{@project.title}" 
    end
  end

  def bookmark_this_article
    if request.path_parameters['action'] == "show"
      bookmark_this
    end
  end

  def bookmark_this
    unless @site_options.addthis.blank?
      "#{@site_options.addthis}"
    end
  end

  def bookmark_this_article
    unless @site_options.addthis.blank?
      "<div class=\"bookmarkThis\">#{@site_options.addthis}</div>"
    end
  end

  def log_validation_errors(obj)
    obj.errors.each{|attr,msg| logger.debug "-------#{attr} - #{msg}-------" }
  end

  def screenshot_thumb_with_link_for_project(project)
    if project.screenshots[0]
      link_to image_tag(project.screenshots[0].public_filename(:thumb), 
                        :title => project.description, :alt => project.description), 
              project_url(project.permalink) 
    end
  end

  def top_menu
   ret = ""
   unless @site_options.menu.blank?
     menu_items = @site_options.menu.split("\n")
     menu_items.each_with_index do |item, index|
       item.gsub!(/\n|\r/, "")
       ret += item.to_s
       ret += "&nbsp;&nbsp;|&nbsp;&nbsp;" if index < menu_items.length - 1
     end 
   end 
   return ret
  end

  def admin_menu
   ret = ""
    if logged_in?
      ret += "&nbsp;|&nbsp;&nbsp;" 
      ret += link_to "Control Panel", :controller => "/admin/users", :action => :show, :id => session[:user_id]
      ret += "&nbsp;&nbsp;|&nbsp;&nbsp;" 
      ret += link_to "Logout", "/logout"
    end
   return ret
  end

end
