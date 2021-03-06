class ScrapperController < ApplicationController
  def run
    require 'open-uri'
    input_search = params[:tv_show]
    puts "TV Show: #{input_search}"
    base_tunefind_url = "https://www.tunefind.com"
    @formattedsearch = []

    # Searching...
    curr_url = "https://www.tunefind.com/search/site?q=" + input_search
    tunefind_result_page = Nokogiri::HTML(open(curr_url))

    search_result = tunefind_result_page.xpath("//a[@class='tf-search-highlight']/@href").first.value

    # Get links to all the seasons in the show
    curr_url = base_tunefind_url + search_result
    tv_show_page = Nokogiri::HTML(open(curr_url))
    seasons_arr = tv_show_page.xpath("//h3[starts-with(@class, 'EpisodeListItem__title_')]/a/@href")

    # Get links to all the episodes in the season
    seasons_arr.each do |sea|
      puts "Going through season: #{sea}"
      curr_url = base_tunefind_url + sea
      curr_season_page = Nokogiri::HTML(open(curr_url))
      episodes_arr = curr_season_page.xpath("//h3[starts-with(@class, 'EpisodeListItem__title_')]/a/@href")
      # Get song titles and artists from each episode
      episodes_arr.each do |epi|
        curr_url = base_tunefind_url + epi
        curr_epi_page = Nokogiri::HTML(open(curr_url))
        song_titles = curr_epi_page.xpath("//a[starts-with(@class, 'SongTitle__link_')]")
        song_artists = curr_epi_page.xpath("//a[starts-with(@class, 'Subtitle__subtitle_')]")
        song_titles.length.times do |i|
          @formattedsearch << song_titles[i].content.to_s + " - " + song_artists[i].content.to_s
        end
      end
    end
    render template: 'scrapper/run'
  end  
end
