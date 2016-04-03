require "csv"
require "script_logger/version"

module ScriptLoggerInfo
end

class ScriptLogger
  attr_reader :log_name, :target_obj_attributes, :extra_headers
  attr_accessor :entries

  def initialize(name, args)
    @log_name = name
    @obj_headers = []
    @target_obj_attributes = {}

    args.each do |obj_name,obj_attrs|
      next if obj_name == :extra_headers

      @target_obj_attributes[obj_name] = []
      obj_attrs.each do |column_info|
        target_attr = column_info.is_a?(Hash) ? column_info.keys.first : column_info
        @target_obj_attributes[obj_name] << target_attr
      end

      obj_attrs.each do |column_info|
        column_name = column_info.is_a?(Hash) ? column_info.values.first : "#{obj_name}_#{column_info}"
        @obj_headers << column_name
      end
    end

    @extra_headers = args.fetch(:extra_headers,[])
    @entries       = [] << CSV.generate_line(@obj_headers + @extra_headers).chomp
  end

  def log(entry)
    entry_build = []
    entry.each do |col_key,col_val|
      if obj_attrs = target_obj_attributes[col_key]
        entry_build += obj_attrs.map {|obj_attr| col_val.send(obj_attr) }
      end
    end
    entry_build += extra_headers.map {|column| entry.fetch(column, nil)}
    entries << CSV.generate_line(entry_build).chomp
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
