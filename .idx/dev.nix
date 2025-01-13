# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {

  # Which nixpkgs channel to use.
  channel = "stable-24.05"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.stdenv.cc
    pkgs.nodejs
    pkgs.rustup
    pkgs.leptosfmt
  ];

  # Sets environment variables in the workspace
  env = {
    RUSTUP_HOME = "$HOME/.rustup";
    PATH = ["$HOME/.cargo/bin"];
  };

  # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
  idx.extensions = [
    "rust-lang.rust-analyzer"
    "tamasfe.even-better-toml"
    "fill-labs.dependi"
    "vadimcn.vscode-lldb"
    "bradlc.vscode-tailwindcss"
  ];

  # Commands to execute when the workspace is created and opened for the first time.
  idx.workspace.onCreate = {
    rust-install = "rustup default nightly; rustup target add wasm32-unknown-unknown";
    npm-update = "npm install -g npm@latest";
    wrangler-install = "npm install -g wrangler@latest";
    # tailwindcss-install = "npm install -g tailwindcss@latest";
    # tailwindcss-v4beta-install = "npm install -g tailwindcss@next @tailwindcss/cli@next";
    cargo-leptos-install = "cargo install cargo-leptos --locked";
    worker-build-install = "cargo install worker-build";
  };
}
