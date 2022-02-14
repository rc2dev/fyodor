require "fyodor/core_extensions/hash/merging"
require "pathname"
require "toml"

module Fyodor
  class ConfigGetter
    DEFAULT_TEMPLATE_PATH = File.dirname(__FILE__) + "/../../share/template.erb"

    DEFAULT_CONFIG = {
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
        "extension" => "md"
      }
    }

    def config
      return @config if defined?(@config)

      Hash.include CoreExtensions::Hash::Merging
      config = DEFAULT_CONFIG.deep_merge(user_config)
      config["output"]["template"] = template

      @config = config
    end


    private

    def config_dir
      @config_dir ||= Pathname.new(ENV["XDG_CONFIG_HOME"] || "~/.config").expand_path + "fyodor"
    end

    def user_config_path
      config_dir + "fyodor.toml"
    end

    def user_template_path
      config_dir + "template.erb"
    end

    def user_config
      if user_config_path.exist?
        puts "Using config at #{user_config_path}.\n"
        return TOML.load_file(user_config_path)
      end

      puts "No config found: using defaults.\n"
      {}
    end

    def template
      if user_template_path.exist?
        puts "Using custom template at #{user_template_path}.\n\n"
        return File.read(user_template_path)
      end

      puts "No custom template found: using default.\n\n"
      File.read(DEFAULT_TEMPLATE_PATH)
    end
  end
end
