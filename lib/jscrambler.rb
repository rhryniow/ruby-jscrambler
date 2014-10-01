require 'logger'
require 'json'
require 'zip'
require 'openssl'
require 'base64'
require 'faraday'
require 'faraday_middleware'
require 'time'
require 'jscrambler/config'
require 'jscrambler/client'
require 'jscrambler/errors'
require 'jscrambler/archiver'
require 'jscrambler/project'
require 'jscrambler/project/file'
require 'jscrambler/middleware/default_params'
require 'jscrambler/middleware/authentication'

module JScrambler

  LOGGER = Logger.new(STDOUT)
  LOGGER.level = Logger::INFO

  if defined?(Rails)
    require 'jscrambler/engine'
    require 'jscrambler/railtie'
  end

  POLLING_MAX_RETRIES = 60
  POLLING_FREQUENCY = 1

  class << self

    def upload_code(json_config=nil)
      JScrambler::Client.new(json_config).new_project
    end

    def poll_project(requested_project, json_config=nil)
      self.find_project(requested_project, json_config) do |project|
        LOGGER.info "Waiting for project #{project.id} to finish processing..."

        retries = 0

        status = project.status
        while status != :finished
          sleep POLLING_FREQUENCY
          status = project.status
          break if status == :finished
          raise JScrambler::ApiError, 'Retries timeout exceeded while polling project' if retries >= POLLING_MAX_RETRIES
          retries += 1
        end

        LOGGER.info "Project #{project.id} is ready!"
        true
      end
    end

    def download_code(requested_project, json_config=nil)
      self.find_project(requested_project, json_config) do |project|
        project.download
      end
    end

    def get_info(requested_project, json_config=nil)
      self.find_project(requested_project, json_config)
    end

    def process(json_config=nil)
      project = self.upload_code(json_config)
      self.poll_project(project)
      project.download
      LOGGER.info "Finished processing #{project.id}!"
    end

    def projects(json_config=nil)
      JScrambler::Client.new(json_config).projects
    end

    def find_project(requested_project, json_config)
      project = if requested_project.kind_of? JScrambler::Project
                  requested_project
                else
                  JScrambler::Client.new(json_config).projects.find { |tmp_project|
                    tmp_project.id == requested_project
                  }
                end

      if project.nil?
        raise JScrambler::ProjectNotFound, "Could not find project #{requested_project}"
      else
        if block_given?
          yield(project)
        else
          project
        end
      end
    end
  end
end
