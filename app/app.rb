#!/usr/bin/env ruby

require_relative "book"
require_relative "clippings_parser"
require_relative "entry"
require_relative "library"
require_relative "output_writer"
require "pathname"


class App

  def initialize
    check_args
    @clippings_path = ARGV[0]
    @output_dir = Pathname.new(ARGV[1])
    check_paths
  end

  def main
    entries = ClippingsParser::parse(@clippings_path)
    library = Library.new(entries)
    OutputWriter::write_all(library, @output_dir)
  end


  private

  def check_args
    if ARGV.count != 2
      puts "Usage: #{$0} my_clippings_path output_dir"
      exit 1
    end
  end

  def check_paths
    unless File.directory?(@output_dir)
      puts "#{@output_dir} is not a directory"
      exit 1
    end

    unless File.file?(@clippings_path)
      puts "#{@clippings_path} is not a file"
      exit 1
    end
  end
end


app = App.new
app.main
