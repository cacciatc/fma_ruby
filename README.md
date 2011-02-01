Intro
-----

This library is a simple hug around the [free music archive's](http://freemusicarchive.org) web API.

Examples
--------

	require 'lib/fma'
	#find all the tracks by a particular artist
	FMA::Track.get(:artist_handle=>'_ghost').each do |k,v|
  		puts v.title
	end

	#find out what a curator is up to, I think the API is not telling the truth here!
	FMA::Track.get(:curator_handle=>'wfmu').each do |k,v|
		puts v.title
	end
