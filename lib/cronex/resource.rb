module Cronex

  RESOURCES_DIR = File.expand_path('../../../resources', __FILE__)

  class Resource
    attr_reader :locale, :messages

    def initialize(loc = :en)
      self.locale = loc || :en
    end

    def locale=(loc)
      result = load(loc)
      if result.nil? || result.empty?
        fail ResourceError, "Error: Invalid resource file for '#{loc}' locale"
      else
        @locale = loc
        @messages = result
      end
    end

    def load(loc)
      file = File.join(RESOURCES_DIR,  "resources_#{loc}.yml")
      fail ResourceError, "Resource file #{file} for '#{loc}' locale not found" unless File.exist?(file)
      YAML.load_file(file)
    end

    def [](key)
      @messages[key]
    end
    alias_method :get, :[]
  end
end
