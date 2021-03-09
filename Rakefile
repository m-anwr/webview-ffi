# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rake/extensiontask"

RuboCop::RakeTask.new
task default: :rubocop

Rake::ExtensionTask.new "webview" do |ext|
    ext.lib_dir = "lib/webview"
  end
