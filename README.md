# Subbundle

Subbundle allows you to boot and require specific gems from your main gem bundle. This can
help if you have a very large number of gems in your `Gemfile.lock` and it takes 1+ seconds
to boot your bundle. This is especially useful for binstubs where you can simply load the
gem that binstub needs.

## Installation

Add to your application's Gemfile:

```ruby
gem 'subbundle'
```

Add the `subbundle` binstub to your project:

`PROJECT_DIR/bin/subbundle`
```ruby
# This file loads Subbundle without using loading other gems in the Gemfile, in order to be fast.
# It gets overwritten when you run the `subbundle binstub` command.

unless defined?(Subbundle)
  require "bundler"

  Bundler.locked_gems.specs.find { |spec| spec.name == "subbundle" }&.tap do |subbundle|
    Gem.use_paths Gem.dir, Bundler.bundle_path.to_s, *Gem.path
    gem "subbundle", subbundle.version
    require "subbundle"
  end
end
```

## Usage

To use subbundle in your binstub, simply modify your existing binstub:

```ruby
# Load the subbundle binstub first.
load File.expand_path("subbundle", __dir__)
# Setup the subbundle.
Subbundle.setup("rubocop")

# Execute the binary.
load Gem.bin_path("rubocop", "rubocop")
```

You're not limited to just one gem. You can load as many gems in your subbundle as you need:

```ruby
# Load the subbundle binstub first.
load File.expand_path("subbundle", __dir__)
# Setup the subbundle.
Subbundle.setup(*%w(
  rubocop
  rubocop-performance
)

# Execute the binary.
load Gem.bin_path("rubocop", "rubocop")
```

## Anecdotal Benchmarks

In a project with ~600 gems...

**Before**
```
$ time bin/rubocop --version
$ bin/rubocop --version  2.62s user 0.37s system 97% cpu 3.063 total
```

**After**
```
$ time bin/rubocop --version
bin/rubocop --version  0.51s user 0.16s system 92% cpu 0.720 total
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ngan/subbundle. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ngan/subbundle/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Subbundle project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ngan/subbundle/blob/master/CODE_OF_CONDUCT.md).
