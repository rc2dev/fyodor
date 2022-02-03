require "fyodor/output_generator"

module Fyodor
  class OutputWriter
    def initialize(library, output_dir, config)
      @library = library
      @output_dir = output_dir
      @output_dir.mkdir unless @output_dir.exist?
      @config = config
    end

    def write_all
      puts "\nWriting to #{@output_dir}..." unless @library.empty?
      @library.each do |book|
        content = OutputGenerator.new(book, @config).content
        File.open(path(book), "w") { |f| f.puts(content) }
      end
    end


    private

    def path(book)
      basename = book.basename.gsub(/[?*:|\/"<>]/,"_")
      extension = @config["extension"]
      path = @output_dir + "#{basename}.#{extension}"

      i = 2
      while(path.exist?)
        path = @output_dir + "#{basename} - #{i}.#{extension}"
        i += 1
      end

      path
    end
  end
end
