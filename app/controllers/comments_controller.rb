class CommentsController < ApplicationController
  
  def create
    article = Article.published.find(params[:article_id].to_i)
    fill_required_fields = "Please fill the required fields!"
    comments_saved = "Comment saved. Will be published right after spam check. Thank you!"
    @site_options = SitePref.find :first
    if article.comments_closed == 0
      @comment = Comment.new(params[:comment])
      @comment.article = article
        if @site_options.recaptcha_public_key.blank? or @site_options.recaptcha_private_key.blank?
          @comment.save ? (flash[:notice] = comments_saved) : (flash[:warning] = fill_required_fields)
        else 
          if verify_recaptcha(@comment) and @comment.save
            flash[:notice] = comments_saved
          else
            flash[:warning] = fill_required_fields
          end
        end
    else
      flash[:warning] = "Comments closed!"
    end

    respond_to do |format|
      format.js
    end
  rescue Exception => e
    flash[:warning] = ERROR_MSG
    log_exception(e)
    respond_to do |format|
      format.js
    end
  end
end
