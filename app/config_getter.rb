require 'pathname'

class ConfigGetter

  CONFIG_PATHS = [Pathname.new(__FILE__).dirname + "../config.toml",
                  Pathname.new("~/.config/fyodor.toml").expand_path]
  CONFIG_DEFAULT = {
    "parser" => {
      "highlight" => "Your Highlight",
      "note" => "Your Note",
      "bookmark" => "Your Bookmark",
      "clip" => "Clip This Article"
    }
  }

  def self.config
    path = find_path
    puts "Using config at #{path}" unless path.nil?

    user_config = path.nil? ? {} : TOML.load_file(path)
    CONFIG_DEFAULT.deep_merge(user_config)
  end


  private

  def self.find_path
    CONFIG_PATHS.find { |path| path.exist? }
  end
end