require_relative "../util/hash"
require "pathname"
require "toml"

class ConfigGetter
  PATHS = [Pathname.new(__FILE__).dirname + "../fyodor.toml",
           Pathname.new("~/.config/fyodor.toml").expand_path]
  DEFAULT = {
    "parser" => {
      "highlight" => "Your Highlight",
      "note" => "Your Note",
      "bookmark" => "Your Bookmark",
      "clip" => "Clip This Article",
      "loc" => "Location",
      "page" => "page",
      "time" => "Added on"
    },
    "output" => {
      "time" => false
    }
  }

  def config
    @config ||= get_config
  end


  private

  def get_config
    print_path
    user_config = path.nil? ? {} : TOML.load_file(path)
    DEFAULT.deep_merge(user_config)
  end

  def path
    @path ||= PATHS.find { |path| path.exist? }
  end

  def print_path
    if path.nil?
      puts "No config found: using defaults.\n\n"
    else
      puts "Using config at #{path}\n\n"
    end
  end
end
