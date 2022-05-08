#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Presidente do Conselho Municipal'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[start name].freeze
    end

    def raw_end
      noko.xpath('following::tr[1]//td[1]').text.tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
