# frozen_string_literal: true

require_relative "subbundle/version"

module Subbundle
  def self.setup(*gems, name: nil)
    require "bundler"
    require "digest/md5"

    name ||= File.basename($PROGRAM_NAME)
    gems = gems.map(&:to_s)

    digest = Digest::MD5.new
    digest << Bundler.default_lockfile.to_s
    digest.file(Bundler.default_lockfile)
    gems.sort.each { |dep| digest << dep }

    subbundle_lockfile_path = Bundler.app_config_path.join("subbundles/#{name}.#{digest.hexdigest}.lock")

    if subbundle_lockfile_path.exist?
      return if setup_from_subbundle(gems, subbundle_lockfile_path)
    end

    default_lockfile = Bundler::LockfileParser.new(Bundler.read_file(Bundler.default_lockfile))
    required_dependencies = default_lockfile.dependencies.slice(*gems).values
    spec_set = Bundler::SpecSet.new(default_lockfile.specs)
    specs = spec_set.for(required_dependencies, false, true)
    dependencies = default_lockfile.dependencies.slice(*specs.map(&:name)).values
    source_list = build_source_list(specs.map(&:source).uniq)
    definition = Bundler::Definition.new(Bundler.default_lockfile, dependencies, source_list, {})
    subbundle_lockfile_path.dirname.mkpath
    subbundle_lockfile_path.write(Bundler.ui.silence { definition.to_lock })

    setup_from_subbundle(gems, subbundle_lockfile_path)
  end

  def self.setup_from_subbundle(gems, subbundle_lockfile_path)
    subbundle_lockfile = Bundler::LockfileParser.new(Bundler.read_file(subbundle_lockfile_path))
    dependencies = subbundle_lockfile.dependencies.slice(*gems).values
    source_list = build_source_list(subbundle_lockfile.sources)
    definition = Bundler::Definition.new(subbundle_lockfile_path, dependencies, source_list, {})
    if definition.nothing_changed?
      setup_runtime(definition)
      true
    else
      subbundle_lockfile_path.delete
      false
    end
  end

  def self.build_source_list(sources)
    sources.compact.each_with_object(Bundler::SourceList.new) do |source, source_list|
      case source
      when Bundler::Source::Git
        source_list.add_git_source(source.options)
      when Bundler::Source::Path, Bundler::Source::Gemspec
        source_list.add_path_source(source.options)
      when Bundler::Source::Rubygems
        next if source.remotes.empty?
        source_list.add_rubygems_source(source.options)
      else
        raise "unhandled: #{source.inspect}"
      end
    end
  end

  def self.setup_runtime(definition)
    Bundler.ui.silence { Bundler::Runtime.new(Bundler.root, definition).setup }
  end
end
