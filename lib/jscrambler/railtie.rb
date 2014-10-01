require 'jscrambler'
require 'rails'

module JScrambler
  class Railtie < Rails::Railtie
    railtie_name :jscrambler

    rake_tasks do
      load 'tasks/jscrambler.rake'
    end
  end
end
