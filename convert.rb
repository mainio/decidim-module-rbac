# frozen_string_literal: true

require "yaml"

puts "Decidim::RBAC.registry.configure do |reg|"

config = YAML.load_file("config/permissions.yml")
first_role = true
config["roles"].each do |role, details|
  puts "" unless first_role
  first_role = false

  puts "  reg.role :#{role} do |role|"

  first_permission = true
  details["permissions"].each do |resource, operations|
    puts "" unless first_permission
    first_permission = false

    puts "    role.resource :#{resource} do |res|"
    operations.each do |operation|
      puts "      res.operation :#{operation}"
    end
    puts "    end"
  end

  puts "  end"
end

puts "end"
