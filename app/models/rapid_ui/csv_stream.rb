require "csv"

module RapidUI
  class CsvStream
    attr_accessor :filename
    attr_accessor :content_type
    attr_accessor :last_modified
    attr_accessor :accel_buffering

    attr_accessor :block

    def initialize(filename:, content_type: "text/csv", last_modified: Time.now, accel_buffering: false, &block)
      @filename = filename
      @content_type = content_type
      @last_modified = last_modified
      @accel_buffering = accel_buffering

      @block = block
    end

    def write(data)
      @block.call(data)
      data
    end
  end
end
