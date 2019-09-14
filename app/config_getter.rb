class ConfigGetter

  CONFIG_PATHS = [File.join(File.dirname(__FILE__), "../config.toml"),
                  File.expand_path("~/.config/fyodor.toml")]
  CONFIG_DEFAULT = {
    "parser" => {
      "note_str" => "Your Note",
      "highlight_str" => "Your Highlight"
    }
  }

  def self.config
    path = get_path
    user_config = path.nil? ? {} : TOML::load_file(path)
    CONFIG_DEFAULT.deep_merge(user_config)
  end


  private

  def self.get_path
    path = CONFIG_PATHS.find { |config| File.exist?(config) }
    puts "Using config at #{File::realpath(path)}" unless path.nil?
    path
  end
end