# frozen_string_literal: true

RSpec.describe Subbundle do
  it "has a version number" do
    expect(Subbundle::VERSION).not_to be nil
  end
end
