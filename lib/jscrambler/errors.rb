module JScrambler
  class MissingKeys < StandardError; end
  class InvalidPath < StandardError; end
  class ApiError < StandardError; end
  class ProjectNotFound < StandardError; end
  class ConfigError < StandardError; end
end
