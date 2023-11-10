require 'nokogiri'
require 'csv'

def document_to_rows(file, rows)
  doc = Nokogiri::HTML.parse(File.read(file))

  works = doc.at_xpath('/html/body/div[1]/table/tr/td/table[4]/tr/td[2]/table/tr[2]/td/table/tr/td').xpath('.//table')
  works.each do |work|
    cirlce_tag = work.xpath('.//a').find do |a|
      a['href'] =~ %r{https://dl.getchu.com/search/dojin_circle_detail.php}
    end
    next if cirlce_tag.nil?

    title_tag = work.xpath('.//a').find do |a|
      next false if a['href'] !~ %r{https://dl.getchu.com/i/}

      a.xpath('.//img').empty?
    end
    next if title_tag.nil?

    registered_at = work.xpath('.//td').find do |td|
      td.text.strip =~ /^\d{4}年\d{2}月\d{2}日$/
    end
    price = work.xpath('.//span[@class="redboldtext"]')&.text&.strip
    tags = work.xpath('.//a').find_all do |a|
      a['href'] =~ %r{https://dl.getchu.com/search/search_list.php}
    end.map(&:text).map(&:strip).join(' ')

    rows << [
      cirlce_tag.text.strip,
      title_tag.text.strip,
      registered_at.text.strip,
      price.strip.gsub(/[円\,]/, ''),
      title_tag['href'],
      tags.strip
    ]
  end
end

csv = CSV.generate do |rows|
  rows << %w[サークル名 作品名 登録日 価格 URL タグ]
  Dir.glob('htmls/*.html') do |file|
    document_to_rows(file, rows)
  end
end
File.write('output.csv', csv)
