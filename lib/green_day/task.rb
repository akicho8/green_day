# frozen_string_literal: true

require "pathname"

module GreenDay
  class Task
    attr_reader :contest, :code, :client

    def initialize(contest, code, client)
      @contest = contest
      @code    = code
      @client  = client
    end

    def submit_file_path
      Pathname("#{contest.name}/#{code}.rb")
    end

    def spec_file_path
      Pathname("#{contest.name}/spec/#{code}_spec.rb")
    end

    def sample_answers
      @sample_answers ||= client.fetch_inputs_and_outputs(contest, self)
    end
  end
end
