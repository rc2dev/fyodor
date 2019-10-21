require_relative "../util/strings"

class StatsPrinter
  include Strings

  def initialize(library)
    @library = library
  end

  def print
    num_books
    rejected
    types
    pretty_output
  end

  private

  def num_books
    puts "=> #{@library.size} books found"
  end

  def types
    ct = @library.count_types
    PLURAL.each { |type, label| puts "#{label.capitalize.rjust(12)}: #{ct[type] || 0}" }
    puts "-------------------"
    puts "#{"TOTAL".rjust(12)}: #{ct.sum {|k, v| v}}\n\n"
  end

  def rejected
    rejected = @library.rejected
    puts "=> Ignored #{rejected[:empty]} empty and #{rejected[:dup]} duplicated entries."
  end

  def pretty_output
    bad = @library.count_desc_unparsed
    percent = (bad.to_f / @library.count_entries.to_f) * 100

    if bad > 0
      warn <<~EOF
      We couldn't *improve* the output of #{bad} (#{percent.round(1)}%) entries.
      Possible causes:
      - Wrong strings in the config file (most probable).
      - Your locale has some specificity the app is not aware. Please open an issue.
      #{"- Your clippings file has more than one locale." if percent != 100}
      EOF
    else
      puts "ALL entries were correctly parsed."
    end
  end
end
