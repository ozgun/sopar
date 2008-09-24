xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do 
  xml.channel do
    xml.title "#{@site_options.title} | #{@site_options.slogan}"
    xml.description @site_options.feed_description
    #xml.link formatted_articles_url(:rss)
    xml.link root_url
    for article in @articles
      xml.item do
        xml.title h(article.title)
        xml.description RedCloth.new(article.body).to_html
        xml.pubDate article.created_at.to_s(:rfc822)
        #xml.link formatted_article_url(article, :rss)
        xml.link article_url(article.permalink)
      end
    end
  end
end
