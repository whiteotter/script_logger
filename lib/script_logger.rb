require "csv"
require "script_logger/version"

class ScriptLogger
  attr_reader :headers, :log_name
  attr_accessor :entries

  def initialize(args)
    @log_name = args[:log_name]
    @headers = args[:headers]
    @entries = [] << CSV.generate_line(@headers).chomp
  end

  def log(entry)
    unknown_entry_keys = entry.keys - headers
    raise "Unknown Entry Keys: #{unknown_entry_keys}" if unknown_entry_keys.any?
    ordered_entry = headers.map {|entry_key| entry.fetch(entry_key, nil)}
    entries << CSV.generate_line(ordered_entry).chomp
  end

  def entry_count
    entries.count - 1
  end

  def to_s
    output = entries.inject("") { |r,entry| r += "#{entry}\n" }
    log_title = "#{log_name} -- #{entry_count} records"
    <<-STR
#{log_title.center(40,'-')}
#{output}
STR
  end

  def self.all_logs_formatted
    output = ObjectSpace.each_object(self).inject("") do |all_logs,log|
      all_logs += "#{log}\n\n"
    end

    <<-STR

#{output}

STR
  end
end
