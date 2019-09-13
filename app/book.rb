class Book
  attr_accessor :entries, :num_notes, :num_highlights, :num_na
  attr_reader :title, :author, :filename

  def initialize(title, author)
    @title = title
    @author = author
    @entries = []
    set_filename
  end

  def clean_book
    rm_empty_entries
  end


  private

  def set_filename
    filename = "#{@author} - #{@title}"
    filename.strip!
    filename.gsub!(/[?*:|\/"<>]/,"_")
    @filename = filename + ".md"
  end

  def rm_empty_entries
    @entries.select! { |entry| entry.text.strip != "" }
  end
end
