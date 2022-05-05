#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

# from https://stackoverflow.com/questions/1791639/converting-upper-case-string-into-title-case-using-ruby
class String
  def titlecase
    split(/([[:alpha:]]+)/).map(&:capitalize).join
  end
end

class Comparison < EveryPoliticianScraper::NulllessComparison
  def columns
    super - %i(arealabel partylabel) + %i(startdate enddate)
  end
end

diff = Comparison.new('wikidata.csv', 'scraped.csv').diff
puts diff.sort_by { |r| [r[0].to_s.gsub(/\-.*/, '+++').gsub('@@','!!'), r[2].to_s.downcase] }.map(&:to_csv)
