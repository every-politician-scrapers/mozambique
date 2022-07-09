#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator WikidataIdsDecorator::Links

  def holder_entries
    noko.xpath("//h2[.//span[contains(.,'Lista de Gov')]]//following-sibling::ul[1]//li")
  end

  class Officeholder < OfficeholderNonTableBase
    def name_node
      noko.css('a').last
    end

    def raw_combo_date
      noko.text.gsub('presente', 'Incumbent').split('-', 2).last
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
