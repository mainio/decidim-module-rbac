# frozen_string_literal: true

module Decidim
  module RBAC
    module CreateParticipatorySpacePrivateUserOverrides
      extend ActiveSupport::Concern

      def call
        return broadcast(:invalid) if form.invalid?

        ActiveRecord::Base.transaction do
          @user ||= existing_user || new_user
          create_private_user
          assign_private_role!
        end

        broadcast(:ok)
      rescue ActiveRecord::RecordInvalid
        form.errors.add(:email, :taken)
        broadcast(:invalid)
      end

      def assign_private_role!
        user.assign_role!("private_participant" ,private_user_to)
      end
    end
  end
end