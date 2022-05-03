#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      noko.css('td').first.text.tidy
    end

    field :provinceLabel do
      noko.xpath('preceding-sibling::tr[1]').text.tidy
    end

    field :position do
    end

    field :positionLabel do
      "Governor of #{provinceLabel}"
    end
  end

  class Members
    def member_container
      noko.css('.content-view-full table tr.bgdark')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
