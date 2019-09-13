class Book
  attr_accessor :name, :entries
  attr_reader :filename

  def initialize(name)
    @name = name
    @entries = []
    set_filename
  end

  def clean_book
    rm_empty_entries
  end


  private

  def set_filename
    filename = name.strip
    filename.gsub!(/[?*:|\/"<>]/,"_")
    @filename = filename + ".md"
  end

  def rm_empty_entries
    @entries.select! { |entry| entry.text.strip != "" }
  end

  # def rm_dup_entries

  # end
end
