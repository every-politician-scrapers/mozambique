#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    # these are the other way around, but by making this the position,
    # this will cope with multiple office-holders, and then we can remap the columns afterwards.
    def position
      noko.css('td text()').map(&:text).map(&:tidy).reject(&:empty?).each_cons(2).select { |a, b| a.include? 'Vice-Min' }.map(&:last).map { |txt| txt.gsub(/^:\s*/, '') }
    end

    # relly position
    def name
      noko.xpath('preceding::h3[1]').text
    end

    def empty?
      position.any? { |txt| txt.include? 'Endereço' }
    end
  end

  class Members
    def member_items
      super.reject(&:empty?)
    end

    def member_container
      noko.css('table.renderedtable tr')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
