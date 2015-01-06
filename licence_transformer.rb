require 'json'

STDIN.each_line do |line|
  raw = JSON.parse(line)

  licence_record = {
    company_name: raw['company_name'],
    company_jurisdiction: 'Slovenia',
    source_url: raw['source_url'],
    sample_date: raw['sample_date'],
    category: 'Financial',
    jurisdiction_classification: raw['category'],
    confidence: 'HIGH',
  }

  puts licence_record.to_json
end
