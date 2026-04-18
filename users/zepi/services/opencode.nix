{
  readDotfiles,
  mkDotfiles,
  mkDotfilesOutOfStore,
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
  };

  home.file.".agents".source = mkDotfilesOutOfStore ".agents";

  xdg.configFile = {
    "opencode/agents".source = mkDotfilesOutOfStore "opencode/agents";
    "opencode/commands".source = mkDotfilesOutOfStore "opencode/commands";
    "opencode/skills".source = mkDotfilesOutOfStore "opencode/skills";
    "opencode/tools".source = mkDotfilesOutOfStore "opencode/tools";
  };
}
