#!/usr/bin/ruby

require 'cgi'
require 'csv'
require 'stringio'
require 'tempfile'
require 'y_tube_fly'

UPLOADED_FILENAME = "raw_y_tube_data"

# Global variables are bad, mmmkay?
@cgi = CGI.new("html4")
@errors = Array.new
@flies = Array.new
@uploaded_file = @cgi.params[UPLOADED_FILENAME].first

@output_filename = @uploaded_file.original_filename.sub(/.csv$/,"") + "-processed.csv"

def process_uploaded_file
  line = 0
  @skip = false
  CSV::Reader.parse( @uploaded_file ) do |row|
    begin
      line += 1
      if @skip
        @skip = false
        next
      end
      date = row.shift
      gender = row.shift
      number = row.shift
      @flies << YTubeFly.new( "data" => row, "date" => date,
                              "gender" => gender, "number" => number )
    rescue RuntimeError => err
      @skip = true
      @errors << "Error on line #{line}: #{err}"
      retry
    end
  end
  rescue CSV::IllegalFormatError => err
    @errors << "Illegal format error: #{err}"
  rescue
    @errors << "Unrecognized error at line #{line}\n#{$!}"
end

if @uploaded_file.size > 0
  process_uploaded_file
else
  @errors << "Did not receive a file"
end

if @errors.size > 0
  @cgi.out do
    @cgi.html() do
      @cgi.head do
        @cgi.title{"#{@errors.size} error(s)"} +
        @cgi.body do
          "<h2>#{@errors.size} error(s)</h2><ul>" +
            @errors.collect { |e| "<li>#{e}</li>" }.join("\n") +
            "</ul>" + @cgi.pre do
                        CGI::escapeHTML(@uploaded_file.read)
                      end
        end
      end
    end
  end
else
  puts @cgi.header( "type" => "text/csv",
                    "Content-Disposition" => "attachment;filename=\"#{@output_filename}\"" )
  csv_out_data = CSV::Writer.create( $stdout )
  csv_out_data.close_on_terminate
  csv_out_data << YTubeFly.headers
  @flies.each { |f| csv_out_data << f.dump }
end
