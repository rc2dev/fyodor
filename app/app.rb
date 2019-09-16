#!/usr/bin/env ruby

require_relative "book"
require_relative "clippings_parser"
require_relative "config_getter"
require_relative "entry"
require_relative "hash"
require_relative "library"
require_relative "md_writer"
require_relative "output_writer"
require "toml"
require "pathname"
require "set"


class App

  def initialize
    get_args
    @config = ConfigGetter.config
  end

  def main
    library = Library.new
    ClippingsParser.new(@clippings_path, @config["parser"], library).parse
    OutputWriter.new(library, @output_dir, @config["ignored_books"]).write_all
  end


  private

  def get_args
    if ARGV.count != 2
      puts "Usage: #{File.basename($0)} my_clippings_path output_dir"
      exit 1
    end

    begin
      @clippings_path = get_path(ARGV[0])
      @output_dir = get_path(ARGV[1])
    rescue SystemCallError => e
      abort(e.message)
    end
  end

  def get_path(path)
    Pathname.new(path).expand_path.realpath
  end
end


App.new.main
