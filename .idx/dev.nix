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
    PATH = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
    ];
  };

  # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
  idx = {
    extensions = [
      "rust-lang.rust-analyzer"
      "tamasfe.even-better-toml"
      "fill-labs.dependi"
      "vadimcn.vscode-lldb"
      "bradlc.vscode-tailwindcss"
    ];

    # Commands to execute when the workspace is created and opened for the first time.
    workspace.onCreate = {
      rust-install = "rustup default nightly; rustup target add wasm32-unknown-unknown";
      wrangler = "npm install -g npm@latest && npm install -g wrangler@latest";
      cargo-install = "cargo install cargo-leptos && cargo install worker-build";
      tailwindcss-v4 = ''
        mkdir -p $HOME/.local/bin &&\
        wget https://github.com/tailwindlabs/tailwindcss/releases/download/v4.0.0-beta.9/tailwindcss-linux-x64 -O $HOME/.local/bin/tailwindcss && \
        chmod +x $HOME/.local/bin/tailwindcss \
      '';
    };
  };
}
