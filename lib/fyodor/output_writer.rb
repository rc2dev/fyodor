require "fyodor/output_generator"
require "fyodor/strings"
require "pathname"

module Fyodor
  class OutputWriter
    include Strings

    def initialize(book, output_dir, config)
      @book = book
      @output_dir = output_dir
      @config = config
    end

    def write
      output = OutputGenerator.new(@book, @config).output
      File.open(path, "w") { |f| f.puts(output) }
    end


    private

    def filename
      return @filename if defined?(@filename)

      filename = @config["filename"] % {
        author: @book.author,
        author_fill: @book.author.empty? ? SINGULAR[:AUTHOR_NA] : @book.author,
        title: @book.title
      }
      filename = filename.gsub(/[?*:|\/"<>]/,"_")

      Pathname.new(filename)
    end

    def path
      result = @output_dir + filename

      i = 2
      while(result.exist?)
        result = @output_dir + "#{filename.basename} - #{i}#{filename.extname}"
        i += 1
      end

      result
    end
  end
end
