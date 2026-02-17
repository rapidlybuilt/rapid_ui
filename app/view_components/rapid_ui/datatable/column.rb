module RapidUI
  module Datatable
    class Column
      attr_accessor :id
      attr_accessor :label

      # TODO: remove this meta-indirection and just use regular OO-design.
      # Types + Extensions make this difficult where `class IntegerColumn < Column`
      # BUT then how does the export extension add `skip_export?` to its columns?
      attr_reader :cell_methods_by_format

      def initialize(**options)
        options.each do |key, value|
          send("#{key}=", value)
        end
        @cell_methods_by_format = {}
      end

      def cell_method_for(format)
        cell_methods_by_format[format]
      end
    end
  end
end
