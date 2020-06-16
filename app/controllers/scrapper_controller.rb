class ScrapperController < ApplicationController
  def run
    require 'open-uri'
    tunefind = Nokogiri::HTML(open("https://www.tunefind.com/show/power/season-1/18893"))
    song_titles = tunefind.xpath("//a[starts-with(@class, 'SongTitle__link_')]")
    song_artists = tunefind.xpath("//a[starts-with(@class, 'Subtitle__subtitle_')]")

    @formattedsearch = ""
    song_titles.length.times do |i|
      @formattedsearch += song_titles[i].content.to_s + "-" + song_artists[i].content.to_s + "\n"
    end
    render template: 'scrapper/run'
  end
  
end

#song title:
#<a href="/song/142232/190022/" class="SongTitle__link___2OQHD" title="Gap in the Clouds">Gap in the Clouds</a>
#song artist:
#<a href="/artist/yung-bans" class="Subtitle__subtitle___1rSyh">Yung Bans</a>

