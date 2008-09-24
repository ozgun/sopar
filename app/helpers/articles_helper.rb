module ArticlesHelper

  def commentator_with_website(comment)
    if comment.commentator_website.blank?
      h(comment.commentator)
    else
      if comment.commentator_website =~ /^http:\/\//
        link_to(h(comment.commentator), h(comment.commentator_website))
      else
        link_to(h(comment.commentator), "http://#{h(comment.commentator_website)}")
      end
    end
  end

  def category_title
    if params[:category_id]
      "<div class=\"categoryTitle\"><h3>You are now browsing <em>#{h @article.category.title}</em> category.</h3></div>"
    end
  end

end
