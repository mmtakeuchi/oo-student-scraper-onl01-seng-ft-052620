require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper
  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    student_page = doc.css('.student-card a')
    binding.pry
    student_page.map do |student|
      {
      name: student.css('.student-name').text,
      location: student.css('.student-location').text,
      profile_url: student.attr('href')
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    profiles = {}

    profile_page = doc.css('.social-icon-container a').map {|el| el.attribute('href').value}
    
    profile_page.map do |profile|
      if profile.include?("twitter")
        profiles[:twitter] = profile
      elsif profile.include?("linkedin")
        profiles[:linkedin] = profile
      elsif profile.include?("github")
        profiles[:github] = profile
      else 
        profiles[:blog] = profile
      end
    end

    profiles[:profile_quote] = doc.css(".profile-quote").text if doc.css(".profile-quote")
    profiles[:bio] = doc.css('.description-holder p').text if doc.css('.description-holder p')
    
    profiles
    
  end

end

