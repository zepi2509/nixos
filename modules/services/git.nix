{ pkgs, ... }: 

{
  environment.systemPackages = with pkgs; [
    git-credential-manager
  ];

  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      credential = {
        credentialStore = "secretservice";
        helper = "manager";
      };
      fetch = {
        prune = true;
      };
    };
  };
}
