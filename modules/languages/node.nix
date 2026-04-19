{ pkgs, ... }: 

# Node.js development environment configuration

{
  environment.systemPackages = with pkgs; [
    nodejs  # JavaScript runtime and npm package manager
    # TypeScript note: Install per-project via npm/yarn
    # For global install: uncomment below
    # nodePackages.typescript
  ];
}
