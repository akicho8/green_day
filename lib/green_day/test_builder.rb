# frozen_string_literal: true

module GreenDay
  module TestBuilder
    extend self

    def build_test(task)
      body = task.sample_answers.map { |input, output|
        build_example(task, input, output)
      }.join("\n")

      <<~SPEC
        RSpec.describe 'test' do
        #{body}
        end
      SPEC
    end

    def build_example(task, input, output)
      <<~SPEC
        #{tab}it 'test with #{unify_cr_lf(input)}' do
        #{tab}  IO.popen("ruby \#{__dir__}/../#{task.code}.rb", "w+") do |io|
        #{tab}    io.puts(#{unify_cr_lf(input)})
        #{tab}    io.close_write
        #{tab}    expect(io.readlines.join).to eq(#{unify_cr_lf(output)})
        #{tab}  end
        #{tab}end
      SPEC
    end

    def unify_cr_lf(string)
      return unless string # たまに画像で例を出してくるとsampleの文字がなくなる

      string.gsub(/\R/, "\n").dump
    end

    def tab
      "\s\s"
    end
  end
end
