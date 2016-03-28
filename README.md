# ScriptLogger

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/script_logger`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'script_logger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install script_logger

## Usage

```ruby
# Step One: Create the loggers
successful_logger = ScriptLogger.new(log_name: 'successful changes', headers: [:first, :second, :third])
unsuccessful_logger = ScriptLogger.new(log_name: 'unsuccessful changes', headers: [:first, :second, :third])
begin
  # Step Two: Log to the loggers
  2.times do |i|
    if i.odd?
      successful_logger.log(first: 'you should know', second: "and commas, are, not, a problem", third: "newlines\nare\nnot\na problem")
    else
      unsuccessful_logger.log(first: 'and missing headers', second: 'will be set to') # `nil`
    end
  end
ensure
  # Step Three: Print out all existing logs for this script
  puts ScriptLogger.all_logs_formatted
end
```

```
----successful changes -- 1 records-----
first,second,third
you should know,"and commas, are, not, a problem","newlines
are
not
a problem"

---unsuccessful changes -- 1 records----
first,second,third
and missing headers,will be set to,
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/whiteotter/script_logger.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

