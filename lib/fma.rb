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

require 'rubygems'
require 'httparty'
require 'pp'
require 'ostruct'

module FMA
	class GettingsburgAddress
		def self.abe_find_me_something(*q)
			r = self.get('/',:query => q.first == nil ? {}:q.first)['dataset']
		end
	end
	class Tracks < GettingsburgAddress
		include HTTParty
		base_uri 'http://freemusicarchive.org/api/get/tracks.json'
		format :json
		class Track < OpenStruct;end
		def self.find(*q)
			self.abe_find_me_something(*q).inject([]) do |c,item|
				c << Track.new(item)
			end
		end
	end	
  	class Artists < GettingsburgAddress
		include HTTParty
		base_uri 'http://freemusicarchive.org/api/get/artists.json'
		format :json
		class Artist < OpenStruct;end
		def self.find(*q)
			self.abe_find_me_something(*q).inject([]) do |c,item|
				c << Artist.new(item)
			end
		end
	end	
  	class Albums < GettingsburgAddress
		include HTTParty
		base_uri 'http://freemusicarchive.org/api/get/albums.json'
		format :json
		class Album < OpenStruct;end
		def self.find(*q)
			self.abe_find_me_something(*q).inject([]) do |c,item|
				c << Album.new(item)
			end
		end
	end	
  	class Curators < GettingsburgAddress
		include HTTParty
		base_uri 'http://freemusicarchive.org/api/get/curators.json'
		format :json
		class Curator < OpenStruct;end
		def self.find(*q)
			self.abe_find_me_something(*q).inject([]) do |c,item|
				c << Curator.new(item)
			end
		end
	end	
end
