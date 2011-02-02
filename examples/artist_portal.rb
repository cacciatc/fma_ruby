require 'rubygems'
require 'sinatra'
require '~/Projects/fma_ruby/lib/fma'


get '/:handle' do |handle|
	FMA::Tracks.find(:artist_handle=>handle).inject('') do |s,i|
		s += "
			<p>
				<object width=\"300\" height=\"50\">
				<param name=\"movie\" value=\"http://freemusicarchive.org/swf/trackplayer.swf\"/>
				<param name=\"flashvars\" value=\"track=http://freemusicarchive.org/services/playlists/embed/track/#{i.track_id}.xml\"/>
				<param name=\"allowscriptaccess\" value=\"sameDomain\"/>
				<embed type=\"application/x-shockwave-flash\" src=\"http://freemusicarchive.org/swf/trackplayer.swf\" width=\"300\" height=\"50\" flashvars=\"track=http://freemusicarchive.org/services/playlists/embed/track/#{i.track_id}.xml\" allowscriptaccess=\"sameDomain\" />
				</object> 
			</p>
		"
	end
end
