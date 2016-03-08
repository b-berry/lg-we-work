#!/usr/bin/env ruby
require 'kamelopard'
require 'csv'

g = GoogleGeocoder.new('AIzaSyBV0zBFD1wVdVJ5BxhrRvNtl5eAkbsPTq0')

results = {}
name_doc = 'we-work-placemarks'
folder = name_folder 'Locations'

#Atlanta Tower Place 3365 Piedmont Rd NE, Atlanta, GA        
#Austin  Congress    600 Congress Ave, Austin, TX        
#Austin  University Park 3300 N Interstate 35, Austin, TX        
pl_style = style(:icon => iconstyle("images/icon_mod.png", :scale => 3.5, :hotspot => xy(0.5,0)), :label => labelstyle(0, :color => 'ff5e9cbc'))
firstline = true
CSV.foreach('we-work_loc.csv') do |loc|
    # Skip first line
    if firstline
        firstline = false
        next
    end

    # Test for street address
    if loc[2].nil? or loc[2] == ''
	    glookup = "#{loc[0]},#{loc[1]}"
	    gname = "#{loc[1]}"
    else
        glookup = "#{loc[2]}"
	    gname = "#{loc[1]}"
    end

    res = g.lookup glookup

    begin
        results[loc] = res['results'][0]['geometry']['location']
    rescue
        results[loc] = {
            'msg' => 'ERROR in geocoder result',
            'result' => res
        }
        next
    end

    # Print search query
    puts "#{gname}:"
    puts "    #{results[loc]}"
    # Store loc info 
    folder << placemark(gname, :geometry => point(results[loc]['lng'], results[loc]['lat'], 0, :clampToGround), :styleUrl => pl_style)
end
# Display Data
puts "Finished:"
puts "    Found #{results.length} coordinates."
write_kml_to "#{name_doc}.kml"

# Print JSON formatted data
#puts JSON.pretty_generate(geodata)

# Write JSON formatted data
#File.open("#{gjson}","w") do |f|
#    f.write(JSON.pretty_generate(geodata))
#end



