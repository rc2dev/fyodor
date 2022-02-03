require "fyodor/core_extensions/hash/merging"
require "pathname"
require "toml"

module Fyodor
  class ConfigGetter
    CONFIG_NAME = "fyodor.toml"
    TEMPLATE_NAME = "template.erb"
    DEFAULT_TEMPLATE_PATH = File.dirname(__FILE__) + "/../../share/template.erb"

    DEFAULTS = {
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
        "time" => false,
        "extension" => "md"
      }
    }

    def config
      @config ||= get_config
    end


    private

    def get_config
      Hash.include CoreExtensions::Hash::Merging

      @config_path = get_path(CONFIG_NAME)
      print_config_path
      user_config = @config_path.nil? ? {} : TOML.load_file(@config_path)

      config = DEFAULTS.deep_merge(user_config)
      config["output"]["template"] = template

      config
    end

    def get_path(name)
      possible_dirs.each do |d|
        path = d + name
        return path if path.exist?
      end

      return nil
    end

    def possible_dirs
      return @possible_dirs unless @possible_dirs.nil?

      @possible_dirs = []
      @possible_dirs << Pathname.new(ENV["XDG_CONFIG_HOME"]) + "fyodor" unless ENV["XDG_CONFIG_HOME"].nil?
      @possible_dirs << Pathname.new("~/.config/fyodor").expand_path
    end

    def print_config_path
      if @config_path.nil?
        puts "No config found: using defaults.\n"
      else
        puts "Using config at #{@config_path}.\n"
      end
    end

    def template
      template_path = get_path(TEMPLATE_NAME) || DEFAULT_TEMPLATE_PATH

      if template_path == DEFAULT_TEMPLATE_PATH
        puts "No template found: using default.\n\n"
      else
        puts "Using template at #{template_path}.\n\n"
      end

      File.read(template_path)
    end
  end
end
