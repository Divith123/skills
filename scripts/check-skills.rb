#!/usr/bin/env ruby
# Checks every skill against the Agent Skills spec (agentskills.io/specification)
# and this repository's own limits. Run from the repository root: ruby scripts/check-skills.rb
require "json"
require "yaml"

ALLOWED_FIELDS = %w[name description license compatibility metadata allowed-tools].freeze
MAX_BODY_LINES = 500
errors = []
fail_with = ->(msg) { errors << msg }

skill_dirs = Dir.glob("skills/*/").map { |d| d.chomp("/") }
fail_with.("no skills found under skills/") if skill_dirs.empty?

skill_dirs.each do |dir|
  path = File.join(dir, "SKILL.md")
  next fail_with.("#{dir}: missing SKILL.md") unless File.file?(path)

  lines = File.readlines(path)
  next fail_with.("#{path}: line 1 must be ---") unless lines.first&.strip == "---"

  close = lines[1..].index { |l| l.strip == "---" }
  next fail_with.("#{path}: frontmatter has no closing ---") unless close

  begin
    fm = YAML.safe_load(lines[1..close].join)
  rescue Psych::Exception => e
    next fail_with.("#{path}: frontmatter is not valid YAML: #{e.message}")
  end
  next fail_with.("#{path}: frontmatter is not a mapping") unless fm.is_a?(Hash)

  extra = fm.keys - ALLOWED_FIELDS
  fail_with.("#{path}: fields outside the spec: #{extra.join(', ')}") unless extra.empty?

  name = fm["name"].to_s
  fail_with.("#{path}: name must be 1-64 lowercase letters, digits, single hyphens") unless name.match?(/\A[a-z0-9]+(-[a-z0-9]+)*\z/) && name.length <= 64
  fail_with.("#{path}: name '#{name}' must match folder '#{File.basename(dir)}'") unless name == File.basename(dir)

  desc = fm["description"].to_s
  fail_with.("#{path}: description is empty") if desc.strip.empty?
  fail_with.("#{path}: description is #{desc.length} chars (max 1024)") if desc.length > 1024
  # Claude Code shows < and > in descriptions as &lt; and &gt;.
  fail_with.("#{path}: description contains < or >") if desc.match?(/[<>]/)

  fail_with.("#{path}: #{lines.length} lines (max #{MAX_BODY_LINES})") if lines.length > MAX_BODY_LINES

  body = lines[(close + 2)..].join
  links = body.scan(/\]\(([^)#\s]+)\)/).flatten.reject { |l| l.match?(%r{\A[a-z]+://}) }
  links.each do |link|
    fail_with.("#{path}: broken link #{link}") unless File.exist?(File.join(dir, link))
  end
  Dir.glob(File.join(dir, "references", "*.md")).each do |ref|
    rel = ref.delete_prefix("#{dir}/")
    fail_with.("#{path}: #{rel} is never linked, so agents won't read it") unless links.include?(rel)
  end
end

Dir.glob("evals/*.json").each do |file|
  items = JSON.parse(File.read(file))
  valid = items.is_a?(Array) && items.all? { |i| i.keys.sort == %w[query should_trigger] && [true, false].include?(i["should_trigger"]) }
  fail_with.("#{file}: each item needs exactly query and should_trigger (boolean)") unless valid
rescue JSON::ParserError => e
  fail_with.("#{file}: invalid JSON: #{e.message}")
end

plugin_file = ".claude-plugin/plugin.json"
market_file = ".claude-plugin/marketplace.json"
if File.exist?(plugin_file) && File.exist?(market_file)
  begin
    plugin = JSON.parse(File.read(plugin_file))
    market = JSON.parse(File.read(market_file))
    entry_names = Array(market["plugins"]).map { |p| p["name"] }
    fail_with.("#{market_file}: no entry named '#{plugin['name']}' from #{plugin_file}") unless entry_names.include?(plugin["name"])
  rescue JSON::ParserError => e
    fail_with.("plugin manifest: invalid JSON: #{e.message}")
  end
end

if errors.empty?
  puts "OK: #{skill_dirs.length} skill(s) checked"
else
  warn errors.map { |e| "FAIL: #{e}" }
  exit 1
end
