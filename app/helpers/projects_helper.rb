module ProjectsHelper

  def screenshot_small_with_link(project)
    if project.screenshots[0] and project.screenshots[0].public_filename(:small)
      link_to image_tag(project.screenshots[0].public_filename(:small), 
                        :title => project.description, :alt => project.description), 
              project_url(project.permalink) 
    end
  end

  def project_info(desc, value, options={})
    suffix = options[:suffix] ? options[:suffix] : ""
    value = auto_link(value) if options[:link]
    unless value.blank?
      "<tr><td class=\"projectTdLeft\">#{desc}</td>" +
      "<td class=\"projectTdRight\">#{value} #{suffix}</td></tr>"
    end
  end

end
