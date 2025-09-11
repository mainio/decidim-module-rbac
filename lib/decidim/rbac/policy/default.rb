# frozen_string_literal: true

module Decidim
  module RBAC
    module Policy
      class Default
        class << self
          def context_readers
            @context_readers ||=
              if superclass.respond_to?(:context_readers)
                superclass.context_readers.dup
              else
                {}
              end
          end

          def context_reader(*names, prefix: nil)
            mapping = names.to_h { |key| [key.to_sym, "#{prefix}#{key}"] }
            context_readers.merge!(mapping)
            attr_reader(*mapping.values)
            private(*mapping.values)
          end
        end

        def initialize(record:, subject: nil, within:, **attributes)
          @record = record
          @subject = subject
          @within = within
          self.class.context_readers.each do |name, varname|
            instance_variable_set("@#{varname}", attributes.fetch(name, nil))
          end
        end

        # Applies both, the preconditions check and the permissions check on the
        # operation and returns the result.
        def apply(operation)
          # First check that the preconditions are fulfilled for the operation.
          return false unless able?(operation)

          # If the preconditions are fulfilled, check if the operation is
          # allowed for the given subject.
          allowed?(operation)
        end

        # Checks the preconditions for the operation.
        def able?(operation)
          case operation
          when :update, :admin_update, :admin_destroy, :admin_publish, :admin_unpublish
            record.present?
          when :admin_soft_delete
            return false unless record.respond_to?(:deleted?)

            !record.deleted?
          when :admin_restore
            return false unless record.respond_to?(:deleted?)

            record.deleted?
          else
            # :admin_manage_trash
            true
          end
        end

        # Checks the permissions for the operation.
        def allowed?(operation)
          has_permission?(operation)
        end

        private

        attr_reader :record, :subject, :within

        # def has_permission?(operation)
        #   operations = permissions[resource_key]
        #   return false unless operations

        #   operations.include?(operation)
        # end
        def has_permission?(operation, key = resource_key)
          operations = permissions[key]
          return false unless operations

          operations.include?(operation)
        end

        def resource_key
          @resource_key ||= self.class.name.underscore.split("/").last.to_sym
        end

        def permissions
          @permissions ||=
            if subject.present?
              subject.permissions_within(record_with_contexts)
            else
              Decidim::RBAC.registry.role(:visitor).permissions
            end
        end

        def able_to_read_publicly?(operation)
          [:read, :admin_read].include?(operation)
        end

        def record_with_contexts
          (Array(record) + Array(within)).compact.flat_map do |item|
            result = [item]
            result << item.participatory_space if item.respond_to?(:participatory_space)
            result << item.organization if item.respond_to?(:organization)
            result << item.component if item.respond_to?(:component)
            result
          end.uniq
        end

        def component
          @component ||= begin
            if respond_to?(:component)
              component
            elsif record && record.is_a?(Decidim::Component)
              record
            elsif record && record.respond_to?(:component)
              record.component
            elsif within && within.is_a?(Decidim::Component)
              within
            elsif within.respond_to?(:component)
              within.component
            end
          end
        end
      end
    end
  end
end
