# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  gem "csv"
  gem "csvlint", path: "../"
  gem "pry"
end

module Ct
  puts "Ruby: #{RUBY_VERSION}"
  #  puts "Csvlint: #{Csvlint::VERSION}"

  class Test
    EOL_MAP = {
      "\r" => "CR",
      "\n" => "LF",
      "\r\n" => "CRLF"
    }

    def initialize(main_eol, test_eol, loc)
      @main_eol = main_eol
      @test_eol = test_eol
      @loc = loc
      @csv = set_csv
    end

    def csv_parse = @csv_parse ||= run_csv_parse

    def lint = @lint ||= run_lint

    def row_count
      return unless @v.respond_to?(:row_count)

      @v.row_count
    end

    def result = {
      main_eol: EOL_MAP[main_eol],
      test_eol: EOL_MAP[test_eol],
      loc: loc,
      csv: csv.inspect,
      csvlint: lint,
      csvlint_row_ct: row_count,
      csv_parse: csv_parse
    }

    private

    attr_reader :main_eol, :test_eol, :loc, :csv

    def set_csv
      case loc
      when "final row ending"
        "obj,note#{main_eol}val,val#{main_eol}val,val#{test_eol}"
      when "extra blank row at end"
        "obj,note#{main_eol}val,val#{main_eol}val,val#{main_eol}#{test_eol}"
      when "blank row between populated rows"
        "obj,note#{main_eol}val,val#{main_eol}#{test_eol}val,val#{main_eol}"
      end
    end

    def run_csv_parse
      CSV.parse(csv, headers: true, nil_value: "")
    rescue => e
      "#{e.class}: #{e.message}"
    else
      "success"
    end

    def run_lint
      @v = Csvlint::Validator.new(StringIO.new(csv))
    rescue => e
      @v = nil
      "VALIDATION ERROR: #{e}"
    else
      return "valid" if @v.errors.empty?

      @v.errors.map(&:type).join("; ")
    end
  end

  module_function

  def base_test_configs(main, test)
    ["final row ending",
      "extra blank row at end",
      "blank row between populated rows"].map do |loc|
      Test.new(main, test, loc)
    end
  end

  def perms
    [
      ["\r", "\r"],
      ["\r", "\n"],
      ["\r", "\r\n"],
      ["\n", "\n"],
      ["\n", "\r"],
      ["\n", "\r\n"],
      ["\r\n", "\r\n"],
      ["\r\n", "\r"],
      ["\r\n", "\n"]
    ]
  end

  tr = perms.map { |pair| base_test_configs(*pair) }
    .flatten
    .map(&:result)

  headers = tr[0].keys

  CSV.open("csv_testing.csv", "w", write_headers: true, headers: headers) do |csv|
    tr.each do |result|
      csv << result.values_at(*headers)
    end
  end
end
