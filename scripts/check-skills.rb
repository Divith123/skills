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
  skill = File.basename(file, ".json")
  fail_with.("#{file}: no skill named #{skill} under skills/") unless skill_dirs.include?("skills/#{skill}")
  items = JSON.parse(File.read(file))
  valid = items.is_a?(Array) && items.all? { |i| i.keys.sort == %w[query should_trigger] && [true, false].include?(i["should_trigger"]) }
  fail_with.("#{file}: each item needs exactly query and should_trigger (boolean)") unless valid
rescue JSON::ParserError => e
  fail_with.("#{file}: invalid JSON: #{e.message}")
end

def read_json(path, fail_with)
  JSON.parse(File.read(path))
rescue Errno::ENOENT
  fail_with.("#{path}: missing")
  nil
rescue JSON::ParserError => e
  fail_with.("#{path}: invalid JSON: #{e.message}")
  nil
end

# One plugin ships every skill in skills/. Each agent has its own manifest; all must agree on name and version.
plugin_name = read_json("plugin.json", fail_with)&.dig("name")
manifests = %w[plugin.json .claude-plugin/plugin.json .cursor-plugin/plugin.json .antigravity-plugin/plugin.json gemini-extension.json]
versions = {}
manifests.each do |path|
  data = read_json(path, fail_with) or next
  fail_with.("#{path}: name must be #{plugin_name}") unless data["name"] == plugin_name
  fail_with.("#{path}: version is missing") if data["version"].to_s.empty?
  versions[path] = data["version"]
end
fail_with.("manifest versions differ: #{versions}") unless versions.values.uniq.length == 1
version = versions.values.first

%w[.claude-plugin/marketplace.json .agents/plugins/marketplace.json].each do |path|
  market = read_json(path, fail_with) or next
  names = Array(market["plugins"]).map { |p| p["name"] }
  fail_with.("#{path}: no #{plugin_name} entry") unless names.include?(plugin_name)
end

changelog = File.exist?("CHANGELOG.md") ? File.read("CHANGELOG.md") : ""
fail_with.("CHANGELOG.md: no entry for version #{version}") unless version && changelog.include?("## #{version}")

cursor = read_json(".cursor-plugin/plugin.json", fail_with)
fail_with.(".cursor-plugin/plugin.json: rules file #{cursor['rules']} missing") if cursor && !File.exist?(cursor["rules"].to_s)
gemini = read_json("gemini-extension.json", fail_with)
fail_with.("gemini-extension.json: context file missing") if gemini && !File.exist?(gemini["contextFileName"].to_s)
fail_with.("GEMINI.md must import rules/AGENTS.md") unless File.exist?("GEMINI.md") && File.read("GEMINI.md").include?("@./rules/AGENTS.md")

# The always-on rule is written once in rules/AGENTS.md; every agent's copy must match it.
canonical = File.read("rules/AGENTS.md").lines.map(&:strip).reject { |l| l.empty? || l.start_with?("#") }.join(" ")
fail_with.("rules/AGENTS.md: the rule must not contain a single quote (the hook echoes it)") if canonical.include?("'")
adapter_copies = Dir.glob("adapters/*/*")
fail_with.("adapters/: no rule copies found") if adapter_copies.empty?
adapter_copies.each do |path|
  fail_with.("#{path}: rule text differs from rules/AGENTS.md") unless File.read(path).include?(canonical)
end
hooks = read_json("hooks/hooks.json", fail_with)
if hooks
  command = hooks.dig("hooks", "SessionStart", 0, "hooks", 0, "command").to_s
  payload = command[/\Aecho '(.*)'\z/, 1]
  context = payload && JSON.parse(payload).dig("hookSpecificOutput", "additionalContext") rescue nil
  fail_with.("hooks/hooks.json: SessionStart must echo JSON whose additionalContext matches rules/AGENTS.md") unless context == canonical
end

if errors.empty?
  puts "OK: #{skill_dirs.length} skill(s) checked"
else
  warn errors.map { |e| "FAIL: #{e}" }
  exit 1
end
