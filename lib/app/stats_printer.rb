require_relative "../util/util"

class StatsPrinter

  include Util

  def initialize(library)
    @library = library
  end

  def print
    num_books
    types
    rejected
    good_parsing
  end

  private

  def num_books
    puts "=> #{@library.size} books found"
  end

  def types
    ct = @library.count_types
    PLURAL.each { |type, label| puts "#{label.capitalize.rjust(12)}: #{ct[type]}" }
    puts "-------------------"
    puts "#{"TOTAL".rjust(12)}: #{ct.sum {|k, v| v}}\n\n"
  end

  def rejected
    rejected = @library.rejected
    puts "Ignored #{rejected[:empty]} empty and #{rejected[:dup]} duplicated entries."
  end

  def good_parsing
    ratio = (@library.count_desc_parsed.to_f / @library.count_entries.to_f) * 100
    puts "#{ratio.round(1)}% of good parsing."
    puts "Try fixing your configuration for better output." if ratio < 50
  end

end