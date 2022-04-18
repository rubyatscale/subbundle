# frozen_string_literal: true

require_relative "subbundle/version"
require "bundler"

module Subbundle
  def self.setup(*gems)
    # Don't write to the lockfile.
    Bundler::Definition.no_lock = true

    Bundler.definition.tap do |definition|
      definition.dependencies.keep_if { |dependency| gems.include?(dependency.name) }
      definition.locked_deps.keep_if { |name, _| gems.include?(name) }

      # Overrides the specs
      spec_set = Bundler::SpecSet.new(definition.instance_variable_get(:@locked_specs).for(definition.dependencies, false, true))
      definition.instance_variable_set(:@locked_specs, spec_set)
    end

    Bundler.require
  end
end
