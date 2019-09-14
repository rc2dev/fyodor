#!/usr/bin/env ruby

require_relative "book"
require_relative "clippings_parser"
require_relative "config_getter"
require_relative "entry"
require_relative "hash"
require_relative "library"
require_relative "output_writer"
require "toml"
require "pathname"


class App

  def initialize
    check_args
    check_paths

    @config = ConfigGetter::config
  end

  def main
    parser = ClippingsParser.new(@clippings_path, @config["parser"])
    entries = parser.parse
    library = Library.new(entries)
    writer = OutputWriter.new(library, @output_dir, @config["ignored_books"])
    writer.write_all
  end


  private

  def get_args
    if ARGV.count != 2
      puts "Usage: #{$0} my_clippings_path output_dir"
      exit 1
    end

    @clippings_path = ARGV[0]
    @output_dir = Pathname.new(ARGV[1])
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
