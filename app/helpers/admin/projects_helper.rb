module Admin::ProjectsHelper
  def add_screenshot_link(title)
      link_to_function title do |page| 
        page.insert_html :bottom, :attachments, :partial => "screenshot", :object => Screenshot.new
      end
  end
end
