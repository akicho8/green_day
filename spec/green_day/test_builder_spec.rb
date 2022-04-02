# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GreenDay::TestBuilder do
  let(:submit_file_path) { 'submit_file' }

  xdescribe '.build_example' do
    subject { described_class.build_example(submit_file_path, input, output) }

    let(:input) { "2 900\n" }
    let(:output) { "Yes\n" }

    it {
      expect(subject).to eq(
        <<~SPEC
          \s\sit 'test with "2 900\\n"' do
          \s\s  IO.popen("ruby submit_file", "w+") do |io|
          \s\s    io.puts("2 900\\n")
          \s\s    io.close_write
          \s\s    expect(io.readlines.join).to eq("Yes\\n")
          \s\s  end
          \s\send
        SPEC
      )
    }
  end

  xdescribe '.build_test' do
    subject { described_class.build_test(submit_file_path, input_output_hash) }

    let(:input_output_hash) { { "2 900\n" => "Yes\n", "3 900\n" => "No\n" } }

    it {
      expect(subject).to eq(
        <<~SPEC
          RSpec.describe 'test' do
            it 'test with "2 900\\n"' do
              IO.popen("ruby submit_file", "w+") do |io|
                io.puts("2 900\\n")
                io.close_write
                expect(io.readlines.join).to eq("Yes\\n")
              end
            end

            it 'test with "3 900\\n"' do
              IO.popen("ruby submit_file", "w+") do |io|
                io.puts("3 900\\n")
                io.close_write
                expect(io.readlines.join).to eq("No\\n")
              end
            end

          end
        SPEC
      )
    }
  end
end
