#!/usr/bin/env ruby
# Copies the always-on rule from rules/AGENTS.md and the version from plugin.json into every
# agent-specific file. Run from the repository root after editing either: ruby scripts/sync-copies.rb
require "json"

rule = File.read("rules/AGENTS.md").lines.map(&:strip).reject { |l| l.empty? || l.start_with?("#") }.join(" ")
abort "rules/AGENTS.md: the rule must not contain a single quote (the hook echoes it)" if rule.include?("'")

adapters = {
  "adapters/cursor/blame-the-intern.mdc" => "---\ndescription: Follow the blame-the-intern skill for every coding task.\nalwaysApply: true\n---",
  "adapters/kiro/blame-the-intern.md" => "---\ninclusion: always\n---",
  "adapters/windsurf/blame-the-intern.md" => "---\ntrigger: always_on\n---",
}
adapters.each { |path, frontmatter| File.write(path, "#{frontmatter}\n\n#{rule}\n") }

payload = JSON.generate({ hookSpecificOutput: { hookEventName: "SessionStart", additionalContext: rule } })
hooks = {
  description: "Reminds the agent at session start, after clear, and after compaction to follow the blame-the-intern skill.",
  hooks: { SessionStart: [{ matcher: "startup|resume|clear|compact", hooks: [{ type: "command", command: "echo '#{payload}'" }] }] },
}
File.write("hooks/hooks.json", JSON.pretty_generate(hooks) + "\n")

version = JSON.parse(File.read("plugin.json")).fetch("version")
%w[.claude-plugin/plugin.json .cursor-plugin/plugin.json .antigravity-plugin/plugin.json gemini-extension.json].each do |path|
  data = JSON.parse(File.read(path))
  data["version"] = version
  File.write(path, JSON.pretty_generate(data) + "\n")
end
market = JSON.parse(File.read(".claude-plugin/marketplace.json"))
market["plugins"].each { |p| p["version"] = version if p.key?("version") }
File.write(".claude-plugin/marketplace.json", JSON.pretty_generate(market) + "\n")

puts "Synced the rule into #{adapters.size} adapters and the hook, and version #{version} into every manifest."
