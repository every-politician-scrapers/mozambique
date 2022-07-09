#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator WikidataIdsDecorator::Links

  def holder_entries
    noko.xpath("//h4[.//span[contains(.,'Governadores')]]//following-sibling::ul[1]//li")
  end

  class Officeholder < OfficeholderNonTableBase
    def item
      noko.css('a/@wikidata').map(&:text).last
    end

    def itemLabel
      noko.text.split(')').last.tidy
    end

    def raw_combo_date
      noko.text.gsub('-)', '- Incumbent)')[/\((.*?)\)/, 1]
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
