# Migrake::SQLStore

An extension for [Migrake][migrake] that stores the rake tasks that you ran in a
SQL database instead of the filesystem, useful for hosts like [Heroku][heroku]
where you have a read-only filesystem.

[migrake]: http://github.com/foca/migrake
[heroku]:  http://heroku.com

## Usage

In your Rakefile, instead of requiring `migrake`, require `migrake/sql_store`,
and initialize the store with the URI to your database:

``` ruby
require "migrake/sql_store"

Migrake.store = Migrake::SQLStore.new("postgres://foo:foo@localhost/database")

migrake Set.new([
  "some_rake_task",
  "another_rake_task",
  # etc, etc
])
```

When running `rake migrake` (or `rake migrake:ready`), SQLStore will check for a
`migrake_tasks` table. If it doesn't exist, it will create it transparently for
you.

This gem requires that you have the appropriate database adapter gems installed
and available (e.g. added to your Gemfile). If the target database is
postgresql, for example, make sure the `pg` is available in the environment
where `rake migrake` will be run.

## Heroku (or other envs which include `DATABASE_URL`)

If your ENV includes a `DATABASE_URL`, you don't need to do anything, as
requiring `migrake/sql_store` will, by default, attempt to connect to a database
at that location, if the ENV key is set. So for Heroku, all you'd do is this:

``` ruby
require "migrake/sql_store"

migrake Set.new([
  "some_rake_task",
  "another_rake_task",
  # etc, etc
])
```

## License

(The MIT License)

Copyright (c) 2012 [Nicolas Sanguinetti][me], with the support of [Cubox][cubox]

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[me]:    http://nicolassanguinetti.info
[cubox]: http://cuboxlabs.com
