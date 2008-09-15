xml.instruct! :xml, :version=> '1.0', :encoding => 'UTF-8'
xml.urlset( :xmlns => 'http://www.google.com/schemas/sitemap/0.84') {
	xml.url {
		xml.loc("http://#{@site_domain}/sitemaps.xml")
		xml.changefreq('daily')
		xml.priority('0.9')
	}
	xml.url {
  	xml.loc("http://#{@site_domain}/")
		xml.changefreq('weekly')
		xml.priority('0.8')
	}
	@articles.each do |a| 
		xml.url {
			xml.loc("http://#{@site_domain}/articles/#{a.permalink}")
			xml.changefreq('weekly')
			xml.priority('0.7')
		}
	end
	@static_pages.each do |a| 
		xml.url {
			xml.loc("http://#{@site_domain}/static_pages/#{a.permalink}")
			xml.changefreq('weekly')
			xml.priority('0.6')
		}
	end
}
