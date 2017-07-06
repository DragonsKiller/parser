class NemanParser
  attr_accessor :root_url, :array_urls_collection

  def initialize(root_url, array_urls_collection)
    @root_url = root_url
    @array_urls_collection = array_urls_collection
  end

  def parse
    @array_urls_collection.each do |url|
      page = Nokogiri::HTML(open(url)).xpath('//div[@class="margin-minus"]/a[@class="prod prod_small"]').map { |link| link['href']}
      page.each do |link|
        image = Nokogiri::HTML(open(@root_url+link)).xpath("//div[@class='prod-wrapper']/a/span/span").xpath('//div[@class="prod-wrapper"]/a/span/span/span/img/@src').each do |src|
          uri_cheker(src)
        end
      end
    end
  end

  def uri_cheker(src)
    if !src.to_s.gsub(/\p{Cyrillic}/, '').nil?
      uri_normalizer(src)
    else
      uri = URI.join(@root_url+link, src ).to_s
      saver(uri)
    end
  end

  def uri_normalizer(src)
    src = Addressable::URI.parse(src.to_s)
    src = src.normalize
    uri = @root_url + src.to_s
    saver(uri)
  end

  def saver(uri)
    File.open(File.join("../images/", File.basename(uri)),'wb'){ |f| f.write(open(uri).read) }
  end
end
