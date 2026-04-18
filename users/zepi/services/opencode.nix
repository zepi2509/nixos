{
  readDotfiles,
  mkDotfiles,
  ...
}: {
  programs.opencode = {
    enable = true;
    settings = let
      target = mkDotfiles "opencode/opencode.json";
    in
      if builtins.pathExists target
      then builtins.fromJSON (builtins.readFile target)
      else {};
    context = readDotfiles "opencode/AGENTS.md";
    agents = mkDotfiles "opencode/agent/";
    commands = mkDotfiles "opencode/command/";
    skills = mkDotfiles "opencode/skill/";
    tools = mkDotfiles "opencode/tool/";
  };
}
