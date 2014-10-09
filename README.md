# JScrambler client for Ruby.

**JScrambler** is an online JavaScript obfuscator and code optimization tool available as a Web application and Web API.

For more information vist [https://jscrambler.com/en](https://jscrambler.com/en)

[![Build Status](https://travis-ci.org/joseairosa/ruby-jscrambler.svg)](https://travis-ci.org/joseairosa/ruby-jscrambler)

# Getting started

1. Install JScrambler at the command prompt if you haven't yet:

        gem install jscrambler

    Or by simply adding it to your Gemfile:
        
        gem 'jscrambler'
        
2. Create (if not there already) a `config` folder in your project root directory
3. In this folder add a `jscrambler_config.json` with the following content:
        
```json
{
  "filesSrc": ["REPLACE_WITH_SOURCE_FILES_PATH"],
  "filesDest": "REPLACE_WITH_DESTINATION_PATH",
  "host": "api.jscrambler.com",
  "port": 443,
  "apiVersion": 3,
  "keys": {
    "accessKey": "REPLACE_WITH_ACCESS_KEY",
    "secretKey": "REPLACE_WITH_SECRET_KEY"
  },
  "params": {
    "string_splitting": "%DEFAULT%",
    "function_reorder": "%DEFAULT%",
    "function_outlining": "%DEFAULT%",
    "dot_notation_elimination": "%DEFAULT%",
    "expiration_date": "2199-01-01",
    "rename_local": "%DEFAULT%",
    "whitespace": "%DEFAULT%",
    "literal_duplicates": "%DEFAULT%"
  },
  "deleteProject": true
}
```

This is the bare minimum to setup this gem. Now we need to change the config file to adapt to our needs.

# Configuration

Most of the parameters in the config file won't need to be altered, but some of them require mandatory changes.

1. [Create your account](https://jscrambler.com/en/account/signup) at the JScrambler website. This will give you both the `accessKey` and `secretKey`.
Once you have them replace `REPLACE_WITH_ACCESS_KEY` with your access key and `REPLACE_WITH_SECRET_KEY` with your secret key.

2. Change where to pick up your html and js file from by replacing the `["REPLACE_WITH_SOURCE_FILES_PATH"]` array. Some examples:

  ##### One file

        "filesSrc": ["/some/path/script.js"],

  ##### Multiple file

        "filesSrc": ["/some/path/script.js", "/some/path/jquery.js", "/some/path/index.html"],

  ##### All files in a given folder

        "filesSrc": ["/some/path/scripts/*"],

  ##### All files in a given folder and all its subfolders

        "filesSrc": ["/some/path/scripts/**"],

  ##### Combination of examples above

        "filesSrc": ["/some/path/scripts/**", "/some/path/html_files/*", "/some/path/vendor/jquery.js"],

3. Change where to store your obfuscated files after being processed by JScrambler by replacing `REPLACE_WITH_DESTINATION_PATH`. Example:

          "filesDest": ["/some/path/processed_files"], 

# How to process files

There are 2 ways to process your files using this gem:

1. This gem comes packed with a [rake](https://github.com/jimweirich/rake) task that you can run to process your files.
2. Using gem's internal API.

### Rake

In order to process files using this method, first of all open your `Rakefile` and add the following:

```ruby
spec = Gem::Specification.find_by_name 'jscrambler'
load "#{spec.gem_dir}/lib/tasks/jscrambler.rake"
```

This will make sure that when you run `bundle exec rake` it know where to search for JScrambler tasks.

Once this is done simply run:

        bundle exec rake jscrambler:process

It will read your config file, take all the files specified in your `filesSrc` parameter, archive them, send them to JScrambler, download them and store them in your `filesDest` path.

Alternatively you can provide a custom config file:

        bundle exec rake jscrambler:process['/some/path/to/config.json']
        
### Gem API

If you're a developer and want to integrate JScrambler functionalities directly into your ruby code, this will be your method of choice.

```ruby
require 'jscrambler'

# Will simply update your source code in filesSrc to JScrambler and create a new JScrambler::Project
JScrambler.upload_code

# Will wait until a given project has been processed. 
# `requested_project` - can either be a project ID hash or a JScrambler::Project
JScrambler.poll_project(requested_project)

# Will download processed source code for a given project.
# `requested_project` - can either be a project ID hash or a JScrambler::Project
JScrambler.download_code(requested_project)

# Will retrieve a JScrambler::Project object for a given project
# `requested_project` - can either be a project ID hash or a JScrambler::Project
JScrambler.get_info(requested_project)

# Takes `upload_code`, `poll_project` and `download_code` and runs them one after the other.
JScrambler.process

# Retrieves all projects
JScrambler.projects
```

# Specific framework integrations

### Rails

This gem integrates directly with Rails. Here's how your config file should look like:

```json
{
  "filesSrc": ["public/assets/*.js"],
  "filesDest": "public/assets/",
  "host": "api.jscrambler.com",
  "port": 443,
  "apiVersion": 3,
  "keys": {
    "accessKey": "REPLACE_WITH_ACCESS_KEY",
    "secretKey": "REPLACE_WITH_SECRET_KEY"
  },
  "params": {
    "string_splitting": "%DEFAULT%",
    "function_reorder": "%DEFAULT%",
    "function_outlining": "%DEFAULT%",
    "dot_notation_elimination": "%DEFAULT%",
    "expiration_date": "2199-01-01",
    "rename_local": "%DEFAULT%",
    "whitespace": "%DEFAULT%",
    "literal_duplicates": "%DEFAULT%"
  },
  "deleteProject": true
}
```

Make sure that you first run `rake assets:precompile` task. This will run the obfuscation on top of the already generated and unified javascript files in your `public/assets` folder. For more information on Rails assets pipeline [read here](http://guides.rubyonrails.org/asset_pipeline.html).

## License

JScrambler is released under the [MIT License](http://www.opensource.org/licenses/MIT).
