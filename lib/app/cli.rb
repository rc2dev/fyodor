require_relative "config_getter"
require_relative "stats_printer"
require_relative "../entities/library"
require_relative "../parser/clippings_parser"
require_relative "../output/output_writer"
require "pathname"

class CLI
  def initialize
    get_args
    @config = ConfigGetter.config
  end

  def main
    library = Library.new
    ClippingsParser.new(@clippings_path, @config["parser"]).parse(library)
    StatsPrinter.new(library).print
    OutputWriter.new(library, @output_dir, @config["output"]).write_all
  end


  private

  def get_args
    if ARGV.count != 1 && ARGV.count != 2
      puts "Usage: #{File.basename($0)} my_clippings_path [output_dir]"
      exit 1
    end

    @clippings_path = get_path(ARGV[0])
    @output_dir = ARGV[1].nil? ? default_output_dir : get_path(ARGV[1])
  end

  def get_path(path)
    Pathname.new(path).expand_path
  end

  def default_output_dir
    Pathname.new(Dir.pwd) + "fyodor_output"
  end
end

