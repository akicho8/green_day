# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GreenDay::TestBuilder do
  let(:submit_file_path) { 'submit_file' }

  describe '.build_example' do
    subject { described_class.build_example(submit_file_path, input, output) }

    let(:input) { "2 900\n" }
    let(:output) { "Yes\n" }

    it {
      expect(subject).to eq(
        <<~SPEC
          \s\sit 'test with "2 900\\n"' do
          \s\s\s\sIO.popen("ruby submit_file", "w+") do |io|
          \s\s\s\s  io.puts("2 900\\n")
          \s\s\s\s  io.close_write
          \s\s\s\s  expect(io.readlines.join).to eq("Yes\\n")
          \s\s\s\send
          \s\send
        SPEC
      )
    }
  end

  describe '.build_test' do
    subject { described_class.build_test(submit_file_path, input_output_hash) }

    let(:input_output_hash) { { "2 900\n" => "Yes\n", "3 900\n" => "No\n" } }

    it {
      expect(subject).to eq(
        <<~SPEC
          RSpec.describe 'test' do
          \s\sit 'test with "2 900\\n"' do
          \s\s\s\sIO.popen("ruby submit_file", "w+") do |io|
          \s\s\s\s  io.puts("2 900\\n")
          \s\s\s\s  io.close_write
          \s\s\s\s  expect(io.readlines.join).to eq("Yes\\n")
          \s\s\s\send
          \s\send

          \s\sit 'test with "3 900\\n"' do
          \s\s\s\sIO.popen("ruby submit_file", "w+") do |io|
          \s\s\s\s  io.puts("3 900\\n")
          \s\s\s\s  io.close_write
          \s\s\s\s  expect(io.readlines.join).to eq("No\\n")
          \s\s\s\send
          \s\send

          end
        SPEC
      )
    }
  end
end
