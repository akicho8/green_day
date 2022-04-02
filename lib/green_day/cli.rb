# frozen_string_literal: true

require 'thor'
require 'parallel'
require 'colorize'
require 'io/console'
require_relative 'atcoder_client'
require_relative 'contest'
require_relative 'test_builder'

module GreenDay
  class Cli < Thor
    desc 'login Atcoder', 'login Atcoder and save session'
    def login
      print 'username: '
      username = $stdin.gets(chomp: true)
      print 'password: '
      password = $stdin.noecho { |stdin| stdin.gets(chomp: true) }.tap { puts }

      AtcoderClient.new.login(username, password)
      puts "Successfully created #{AtcoderClient::COOKIE_FILE_NAME}".colorize(:green)
    end

    desc 'new [contest name]', 'create contest workspace and spec'
    def new(contest_name)
      contest = Contest.new(contest_name, AtcoderClient.new)
      FileUtils.makedirs("#{contest.name}/spec")

      Parallel.each(contest.tasks, in_threads: THREAD_COUNT) do |task|
        task.submit_file_path.write("")
        task.spec_file_path.write(TestBuilder.build_test(task))
      end

      puts "Successfully created #{contest.name} directory".colorize(:green)
    end
  end
end
