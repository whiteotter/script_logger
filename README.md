# ScriptLogger

Simple tool for logging results of script runs in csv format

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

require 'ostruct'
successful_logger = ScriptLogger.new('successful changes', invoice: [:first_col, :second_col, {third_col: "renamed_third_col"}], extra_headers: [:success_message])
unsuccessful_logger = ScriptLogger.new('unsuccessful changes', invoice: [{first_col: "first col renamed"}, :second_col, :third_col], extra_headers: [:fail_message])
begin
  # Step Two: Log to the loggers
  2.times do |i|
    if i.odd?
      invoice = OpenStruct.new(first_col: 'you should know', second_col: "and commas, are, not, a problem", third_col: "newlines\nare\nnot\na problem")
      successful_logger.log(invoice: invoice, success_message: "it worked!")
    else
      failed_invoice = OpenStruct.new(first_col: 'and missing headers', second_col: 'will be set to nil')
      unsuccessful_logger.log(invoice: failed_invoice, fail_message: "it failed, the right way")
    end
  end
ensure
  # Step Three: Print out all existing logs for this script
  puts ScriptLogger.all_logs_formatted
end
```

```
----successful changes -- 1 records-----
invoice_first_col,invoice_second_col,renamed_third_col,success_message
you should know,"and commas, are, not, a problem","newlines
are
not
a problem",it worked!

---unsuccessful changes -- 1 records----
first col renamed,invoice_second_col,invoice_third_col,fail_message
and missing headers,will be set to nil,,"it failed, the right way"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/whiteotter/script_logger.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

