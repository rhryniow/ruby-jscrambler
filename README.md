# JScrambler client for Ruby.

[![Build Status](https://travis-ci.org/joseairosa/ruby-jscrambler.svg)](https://travis-ci.org/joseairosa/ruby-jscrambler)

**JScrambler** is an online JavaScript obfuscator and code optimization tool available as a Web application and Web API.

For more information vist [https://jscrambler.com/en](https://jscrambler.com/en)

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
  "deleteProject": false
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

This gem comes packed with a [rake](https://github.com/jimweirich/rake) task that you can run to process your files.

        bundle exec rake jscrambler:process

It will read your config file, take all the files specified in your `filesSrc` parameter, archive them, send them to JScrambler, download them and store them in your `filesDest` path.

Alternatively you can provide a custom config file:

        bundle exec rake jscrambler:process['/some/path/to/config.json']

### Rails

This gem integrates directly with Rails. Here's how your config file could look (just an example):

```json
{
  "filesSrc": ["/path/to/javascripst/**"],
  "filesDest": "/rails/root/app/assets/javascripts/",
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
  "deleteProject": false
}
```

To avoid clashing we recommend copying the files you want to process to a separate folder and pointing the `filesSrc` to that folder.

Normally you'll want to run this before running `rake assets:precompile`.

## License

JScrambler is released under the [MIT License](http://www.opensource.org/licenses/MIT).
