#Copyright (c) <2010> <Chris Cacciatore>
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

require 'net/http'
require 'ostruct'
require 'rexml/document'

module FMA
  class Query
    include Net, REXML
    (URL_BASE = 'http://freemusicarchive.org/api/get/').freeze
    def self.get(q)
      Document.new(HTTP.get_response(URI.parse(URL_BASE + q.chop)).body)
    end
  end
  class Base
    def initialize(h)
      @o = OpenStruct.new(h)
    end
    def method_missing(sym,*args)
      @o.send(sym,args)
    end
    def self.try_parsing_date(str)
      d0 = ""
      begin
        d0 = Date.parse(i.elements["artist_active_year_begin"].text)
      rescue
      end
      d0
    end
  end
  class Artist < Base
    (URL_DATASET = 'artists.xml?').freeze
    def self.get(args)
      q = URL_DATASET + args.inject('') {|q_str,a_pair| q_str += a_pair.to_a.join('=').gsub(/[\s]+/,'_') + '&'}
      h = {}
      Query.get(q).elements["*/dataset"].each do |i|
        tmp_h = {
          :artist_id=>i.elements["artist_id"].text.to_i,
          :handle=>i.elements["artist_handle"].text,
          :url=>i.elements["artist_url"].text,
          :name=>i.elements["artist_name"].text,
          :bio=>i.elements["artist_bio"].text,
          :website=>i.elements["artist_website"].text,
          :wikipedia=>i.elements["artist_wikipedia_page"].text,
          :donation=>i.elements["artist_donation_url"].text,
          :contact=>i.elements["artist_contact"].text,
          :address=>i.elements["artist_contact_address"].text,
          :related_projects=>i.elements["artist_related_projects"].text,
          :labels=>i.elements["artist_associated_labels"].text,
          :comments=>i.elements["artist_comments"].text.to_i,
          :favorites=>i.elements["artist_favorites"].text.to_i,
        }
        d0 = try_parsing_date(i.elements["artist_active_year_begin"].text)
        d1 = try_parsing_date(i.elements["artist_active_year_end"].text)
        if d0 != "" and d1 != ""
          tmp_h[:active_years] = d0..d1
        else
          tmp_h[:active_years] = ""
        end
        tmp_h[:created] = try_parsing_date(i.elements["artist_date_created"].text)
        h[i.elements["artist_handle"].text] = Artist.new(tmp_h)
      end
      h
    end
  end
  class Album < Base
    (URL_DATASET = 'albums.xml?').freeze
    def self.get(*args)
      q = URL_DATASET + args.inject('') {|q_str,a_pair| q_str += a_pair.to_a.join('=').gsub(/[\s]+/,'_')  + '&'}
      h = {}
      Query.get(q).elements["*/dataset"].each do |i|
        tmp_h = {
          :album_id=>i.elements["album_id"].text.to_i,
          :handle=>i.elements["album_handle"].text,
          :url=>i.elements["album_url"].text,
          :title=>i.elements["album_title"].text,
          :type=>i.elements["album_type"].text,
          :artist=>i.elements["artist_name"].text,
          :artist_url=>i.elements["artist_url"].text,
          :producer=>i.elements["album_producer"].text,
          :engineer=>i.elements["album_engineer"].text,
          :information=>i.elements["album_information"].text,
          :tracks=>i.elements["album_tracks"].text.to_i,
          :listens=>i.elements["album_listens"].text,
          :comments=>i.elements["album_comments"].text.to_i,
          :favorites=>i.elements["album_favorites"].text.to_i,
        }
        tmp_h[:created] = try_parsing_date(i.elements["album_date_created"].text)
        tmp_h[:active_years] = try_parsing_date(i.elements["album_date_released"].text)
        h[i.elements["album_handle"].text] = Album.new(tmp_h)
      end
      h
    end
  end
  class Curator < Base
    (URL_DATASET = 'curators.xml?').freeze
    def self.get(*args)
      q = URL_DATASET + args.inject('') {|q_str,a_pair| q_str += a_pair.to_a.join('=').gsub(/[\s]+/,'_')  + '&'}
      h = {}
      Query.get(q).elements["*/dataset"].each do |i|
        tmp_h = {
          :curator_id=>i.elements["curator_id"].text.to_i,
          :handle=>i.elements["curator_handle"].text,
          :url=>i.elements["curator_url"].text,
          :site_url=>i.elements["curator_site_url"].text,
          :img=>i.elements["curator_image_file"].text,
          :title=>i.elements["curator_title"].text,
          :type=>i.elements["curator_type"].text,
          :tagline=>i.elements["curator_tagline"].text,
          :bio=>i.elements["curator_bio"].text,
          :playlists=>i.elements["curator_playlists"].text.to_i,
          :comments=>i.elements["curator_comments"].text.to_i,
          :favorites=>i.elements["curator_favorites"].text.to_i,
        }
        tmp_h[:created] = try_parsing_date(i.elements["curator_date_created"].text)
        h[i.elements["curator_handle"].text] = Curator.new(tmp_h)
      end
      h
    end
  end
  class Track < Base
    (URL_DATASET = 'tracks.xml?').freeze
    def self.get(*args)
      q = URL_DATASET + args.inject('') {|q_str,a_pair| q_str += a_pair.to_a.join('=').gsub(/[\s]+/,'_')  + '&'}
      h = {}
      Query.get(q).elements["*/dataset"].each do |i|
        tmp_h = {
          :track_id=>i.elements["track_id"].text.to_i,
          :title=>i.elements["track_title"].text,
          :artist_id=>i.elements["artist_id"].text.to_i,
          :artist_name=>i.elements["artist_name"].text,
          :artist_url=>i.elements["artist_url"].text,
          :album_id=>i.elements["album_id"].text.to_i,
          :album_title=>i.elements["album_title"].text,
          :artist_url=>i.elements["album_url"].text,
          :language_code=>i.elements["track_language_code"].text,
          :number=>i.elements["track_number"].text.to_i,
          :disc_number=>i.elements["track_disc_number"].text,
          :explicit=>i.elements["track_explicit"].text,
          :explicit_notes=>i.elements["track_explicit_notes"].text,
          :copyright_c=>i.elements["track_copyright_c"].text,
          :copyright_p=>i.elements["track_copyright_p"].text,
          :composer=>i.elements["track_composer"].text,
          :lyricist=>i.elements["track_lyricist"].text,
          :publisher=>i.elements["track_publisher"].text,
          :instrumental=>i.elements["track_instrumental"].text,
          :information=>i.elements["track_information"].text,
          :interest=>i.elements["track_interest"].text,
          :listens=>i.elements["track_listens"].text.to_i,
          :comments=>i.elements["track_comments"].text.to_i,
          :favorites=>i.elements["track_favorites"].text.to_i,
        }
        tmp_h[:created] = try_parsing_date(i.elements["track_date_created"].text)
        tmp_h[:recorded] = try_parsing_date(i.elements["track_date_recorded"].text)
        h[i.elements["track_title"].text] = Track.new(tmp_h)
      end
      h
    end
  end
end