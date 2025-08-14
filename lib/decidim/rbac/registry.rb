# frozen_string_literal: true

module Decidim
  module RBAC
    class Registry
      include Singleton

      def initialize
        @groups = {}
        @roles = {}
        @policies = {}
      end

      def register
        yield self
      end

      def policy(key, klass = nil)
        if klass.nil?
          @policies[key] || Decidim::RBAC::Policy::Default
        else
          @policies[key] = klass
        end
      end

      def group(key, &block)
        key = key.to_sym
        return @groups[key] unless block_given?

        roledef = Definition::Group.new
        roledef.instance_eval(&block)
        @groups[key].deep_merge!(roledef.resources)
        @groups[key]
      end

      def role(key, &block)
        key = key.to_sym
        return @roles[key] unless block_given?

        @roles[key] ||= RBAC::Role.new(key.to_sym)

        roledef = Definition::Role.new
        roledef.instance_eval(&block)
        @roles[key].add_permissions(roledef.resources)
        @roles[key]
      end

      def roles(*keys)
        return @roles.values if keys.empty?

        @roles.values_at(*keys.uniq.map(&:to_sym)).compact
      end

      private

      # Currently not used
      def load
        scanner = Scanner.new
        scanner.roles do |key, settings|
          role(key, settings[:assignment]) do
            settings[:permission].each do |permkey, operations|
              permission(permkey) do
                operations.each { |op| operation(op) }
              end
            end
          end
        end
      end

      module Definition
        class Group
          attr_reader :resources

          def initialize
            @resources = {}
          end

          def resource(name, &block)
            resdef = Definition::Resource.new
            resdef.instance_eval(&block)

            resources.deep_merge!(name.to_sym => resdef.operations)
          end
        end

        class Role
          attr_reader :resources

          def initialize
            @resources = {}
          end

          def apply(group)
            groupdef = Registry.instance.group(group)
            return unless groupdef

            resources.deep_merge!(groupdef)
          end

          def resource(name, &block)
            resdef = Definition::Resource.new
            resdef.instance_eval(&block)

            resources.deep_merge!(name.to_sym => resdef.operations)
          end
        end

        class Resource
          attr_reader :operations

          def initialize
            @operations = []
          end

          def operation(key)
            operations.push(key.to_sym)
          end
        end
      end
    end
  end
end
