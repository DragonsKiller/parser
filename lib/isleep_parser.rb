class IsleepParser
  attr_accessor :url_collections, :pages_url

  def initialize(url_collections, pages_url)
    @url_collections = url_collections
    @pages_url = pages_url
  end

  def parse
    (1..get_count_pages).each do |current_page|
      Nokogiri::HTML(open(@pages_url+current_page.to_s)).xpath("//div[@class='row products_category']/div/div/div/a/img/@src").each do |src|
        saver(current_page, src)
      end
    end
  end

  def get_count_pages
    Nokogiri::HTML(open(@url_collections)).xpath('//div[@class="row"]/div/div/div/div[@class="col-sm-6 text-right"]').to_s.gsub!(/<div class="col-sm-6 text-right">Показано с.*всего /, '').gsub!(/ страниц.*/, '').to_i
  end

  def saver(current_page, src)
    uri = URI.join(@pages_url+current_page.to_s, src ).to_s # make absolute uri
    File.open(File.join("../images/", File.basename(uri)),'wb'){ |f| f.write(open(uri).read) }
  end
end
