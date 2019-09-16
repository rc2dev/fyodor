class Book
  attr_accessor :entries
  attr_reader :title, :author

  def initialize(title, author)
    raise "Book title can't be empty" if title.to_s.empty?

    @title = title
    @author = author
    @entries = []
  end

  def finish
    rm_empty_entries
    rm_dup_entries
  end

  def basename
    base = @author.to_s.empty? ? @title : "#{@author} - #{@title}"
    base.strip.gsub(/[?*:|\/"<>]/,"_")
  end

  def by_type(type)
    @entries.select { |entry| entry.type == type }
  end

  def count
    result = {}
    Entry::TYPE.each_value do |type|
      result[type] = @entries.count { |entry| entry.type == type }
    end
    result
  end


  private

  def rm_empty_entries
    @entries.select! { |entry| ! entry.empty? }
  end

  def rm_dup_entries
    @entries.uniq! { |entry| entry.uniq_info }
  end
end
