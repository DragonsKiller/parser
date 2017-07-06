class BrwParser
  attr_accessor :root_url, :collections_url
  def initialize(root_url, collections_url)
    @root_url = root_url
    @collections_url = collections_url
  end

  def parse
    page = Nokogiri::HTML(open(@collections_url)).xpath('//div[@class="item col-lg-3 col-md-4 col-sm-4 col-xs-12"]/a').map { |link| link['href'] }
    page.each do |link|
      image = Nokogiri::HTML(open(@root_url+link)).xpath("//div[@class='image']/ul/li/@style").to_s.gsub!(/background-image: url\(/, '')
      saver(image)
    end
  end

  def saver(image)
    if !image.nil?
      image = image.split(/\)/)
      image.each do |url|
        uri = @root_url+url
        File.open(File.join("../images/", File.basename(uri)),'wb'){ |f| f.write(open(uri).read) }
      end
    end
  end
end
