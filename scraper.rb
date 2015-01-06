# -*- coding: utf-8 -*-

require 'json'
require 'mechanize'
require 'turbotlib'

def clean_string(s)
  s.gsub(/\A[[:space:]]*(.*?)[[:space:]]*\z/) { $1 }
end

urls = {
  'Insurance' => 'http://www.a-zn.si/Eng/Default.aspx?id=44',
  'Reinsurance' => 'http://www.a-zn.si/Eng/Default.aspx?id=45',
  'Pension' => 'http://www.a-zn.si/Eng/Default.aspx?id=46',
  'Other' => 'http://www.a-zn.si/Eng/Default.aspx?id=47'
}

urls.each do |category, url|
  agent = Mechanize.new
  page = agent.get(url)

  number_of_pages = page.search('.pagerNumber a').last.text.to_i rescue 1

  0.upto(number_of_pages - 1) do |page_number|

    if page_number > 0
      page = agent.get(url + "&page=#{page_number}")
    end

    page.search('.zs > div:not(.zv) > .left, .zs > div:not(.zv) > .leftsmall').each do |co|
      company, *address_parts, url_string = co.to_s.split('<br>')

      data = {
        company_name: Nokogiri(company).search('b').text,
        address: address_parts.map {|x| clean_string(x)}.join(', ').squeeze(','),
        url: Nokogiri(url_string).search('a').attr('href'),
        category: category,
        source_url: url,
        sample_date: Time.now
      }

      puts JSON.dump(data)
    end
  end
end
