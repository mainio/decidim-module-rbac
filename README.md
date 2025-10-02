# Decidim::RBAC

**! ! ! WORK IN PROGRESS, DO NOT USE YET ! ! !**

[![Build Status](https://github.com/mainio/decidim-module-rbac/actions/workflows/ci_rbac.yml/badge.svg)](https://github.com/mainio/decidim-module-rbac/actions)
[![codecov](https://codecov.io/gh/mainio/decidim-module-rbac/branch/master/graph/badge.svg)](https://codecov.io/gh/mainio/decidim-module-rbac)

A [Decidim](https://github.com/decidim/decidim) module that allows managing
access to different resources within the system through Role Based Access
Control (RBAC).

RBAC is a method of managing system access by assigning users to predefined roles that carry specific sets of permissions. Instead of granting or revoking permissions individually—which quickly becomes unmanageable as systems grow—roles provide a structured, scalable way to ensure users have only the access they need. This improves security by reducing the risk of unauthorized actions, enhances efficiency by simplifying user management, and supports compliance by making it easier to audit who has access to what. Role-based permission follows the principle of “least privilege” rule, meaning users are granted only the minimum permissions necessary for their tasks.

After installing this module, your decidim app [ideally] should work as before, with all of the permission logic being replace by RBAC controls. This would introduce more flexible, easily managed permission work-flow for different roles.

## Notes

This module changes how Decidim permissions work internally, so it should be
used with caution on existing instances. It is recommended to test the
functionality thoroughly once this module is introduced. Currently this is a
proof of concept implementation to show how this could be implemented into the
system. Supports only a limited set of features and modules.

Currently the following modules are NOT supported (i.e. the permission policies
have NOT been written for these modules):

- `decidim-conferences`
- `decidim-demographics`
- `decidim-elections`
- `decidim-initiatives`

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-rbac"
```

And then execute:

```bash
bundle
bundle exec rails decidim_rbac:install:migrations
bundle exec rails db:migrate
```

Finally, run the following rake task to migrate all of the roles in your app:

```bash
bundle exec rake decidim_rbac:assign_roles
```

The above step migrates all of the permissions in the decidim, and saves those into `permision_role_assignment` table. This includes defining authors, admins, participant roles. This step is crucial, otherwise the existing users wont have any permission over the instance.

## Contributing

See [Decidim](https://github.com/decidim/decidim).

### Testing

To run the tests run the following in the gem development path:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake test_app
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rspec
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add these environment variables to the root directory of the project in a
file named `.rbenv-vars`. In this case, you can omit defining these in the
commands shown above.

### Test code coverage

If you want to generate the code coverage report for the tests, you can use
the `SIMPLECOV=1` environment variable in the rspec command as follows:

```bash
$ SIMPLECOV=1 bundle exec rspec
```

This will generate a folder named `coverage` in the project root which contains
the code coverage report.

## License

See [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt).
