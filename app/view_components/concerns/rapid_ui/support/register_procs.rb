# frozen_string_literal: true

module RapidUI
  module Support
    # The RegisterProcs module helps tables register and apply initialization and filter procs.
    # It provides a framework for defining and managing initialization and filter blocks
    # that can be applied to tables in a decentralized-pluginable way.
    module RegisterProcs
      extend ActiveSupport::Concern

    private

      def apply_proc(id, proc, *args)
        if_method = proc[2][:if]
        unless_method = proc[2][:unless]
        return if (if_method && !send(if_method)) || (unless_method && send(unless_method))

        if proc[1]
          proc[1].call(self, *args)
        else
          send(:"#{id}_#{proc[0]}", *args)
        end
      end

      # Class methods for registering initialization and filter procs.
      module ClassMethods
        def def_registered_procs(name)
          procs_method = :"#{name}_procs"
          register_method = :"register_#{name}"

          class_attribute procs_method, default: []

          define_singleton_method(register_method) do |id, after: nil, before: nil, **options, &block|
            add_proc(procs_method, id, block, after:, before:, **options)
          end
        end

        private

        # rubocop:disable Metrics/ParameterLists
        def add_proc(proc_method, id, block, after: nil, before: nil, **options)
          procs = public_send(proc_method).dup

          existing_index = find_proc_index(procs, id)
          raise ArgumentError, "proc #{id.inspect} has already been registered" if existing_index

          element = [ id, block, options ]

          if after
            procs.insert(find_proc_index!(procs, after) + 1, element)
          elsif before
            procs.insert(find_proc_index!(procs, before), element)
          elsif existing_index
            # replace the existing proc in the same spot in the array
            procs[existing_index] = element
          else
            procs << element
          end

          self.send(:"#{proc_method}=", procs)
        end
        # rubocop:enable Metrics/ParameterLists

        def find_proc_index!(procs, id)
          find_proc_index(procs, id) || raise(ArgumentError, "Unknown proc: #{id.inspect}")
        end

        def find_proc_index(procs, id)
          procs.index { |proc| proc.first == id }
        end
      end
    end
  end
end
