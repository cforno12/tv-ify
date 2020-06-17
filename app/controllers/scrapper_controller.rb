class ScrapperController < ApplicationController
  def run
    require 'open-uri'
    input_search = "power"
    base_tunefind_url = "https://www.tunefind.com"

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
      curr_url = base_tunefind_url + sea
      curr_season_page = Nokogiri::HTML(open(curr_url))
      episodes_arr = curr_season_page.xpath("//h3[starts-with(@class, 'EpisodeListItem__title_')]/a/@href")
      # Get song titles and artists from each episode
      episodes_arr.each do |epi|
        curr_url = base_tunefind_url + epi
        curr_epi_page = Nokogiri::HTML(open(curr_url))
        song_titles = curr_epi_page.xpath("//a[starts-with(@class, 'SongTitle__link_')]")
        song_artists = curr_epi_page.xpath("//a[starts-with(@class, 'Subtitle__subtitle_')]")

        @formattedsearch = ""
        song_titles.length.times do |i|
          @formattedsearch += song_titles[i].content.to_s + " - " + song_artists[i].content.to_s + "\n"
        end
      end
    end
    render template: 'scrapper/run'
  end

  def search
    render template: 'scrapper/search'
  end
  
end

#song title:
#<a href="/song/142232/190022/" class="SongTitle__link___2OQHD" title="Gap in the Clouds">Gap in the Clouds</a>
#song artist:
#<a href="/artist/yung-bans" class="Subtitle__subtitle___1rSyh">Yung Bans</a>

