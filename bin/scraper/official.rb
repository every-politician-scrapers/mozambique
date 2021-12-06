#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      paragraphs.last
    end

    def position
      paragraphs[-2]
    end

    def empty?
      paragraphs.empty?
    end

    private

    def paragraphs
      noko.css('p').map(&:text).map(&:tidy).reject(&:empty?)
    end
  end

  class Members
    def member_items
      super.reject(&:empty?)
    end

    def member_container
      noko.css('table.list td')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
