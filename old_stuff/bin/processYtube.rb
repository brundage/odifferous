#!/usr/bin/ruby

require 'csv'
require 'pp'
require 'y_tube_fly'

if ARGV[0].nil?
  p "Need ARGV[0]"
  exit 2
else
  infilename = ARGV[0]
end

today = Time.now.strftime("%Y-%m-%d")

outfilename = ARGV[1].nil? ? "#{File.basename(infilename)}-output-#{today}.csv" : ARGV[1]

infile = File.open( infilename, "rb" )
outfile = File.open( outfilename, "wb" )
line = 1

CSV::Writer.generate(outfile) do |csv_out|

  csv_out << YTubeFly.headers

  begin
    CSV::Reader.parse( infile ) do |row|
      date = row.shift
      gender = row.shift
      number = row.shift
      fly = YTubeFly.new( "data" => row, "date" => date, "gender" => gender, 
                          "number" => number )
      csv_out << fly.dump
      line += 1
    end
  rescue RuntimeError => err
    p "Error on line #{line}: #{err}"
  end

end
outfile.close; infile.close
