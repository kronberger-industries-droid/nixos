# modules/helix.nix
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    nil
    texlab
    tectonic
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "base16_default";
      editor = {
        line-number = "relative";
        lsp.display-messages = false;
      };
    };
    languages = {
      language-server.nil = {
        command = "${pkgs.nil}/bin/nil";
        file-types = [ "nix" ];
      };
      language-server.texlab = {
        command = "${pkgs.texlab}/bin/texlab";
        file-types = [ "latex" ];
        config = {
          texlab = {
            build = {
              onSave = true;
              forwardSearchAfter = true;
              executable = "${pkgs.tectonic}/bin/tectonic";
              args = [
                "-X"
                "compile"
                "%f"
                "--synctex"
                "--keep-logs"
                "--keep-intermediates"
                "--outdir=build"
                "-Zshell-escape"
              ];
              directory = "build";
              auxDirectory = "build";
            };
            chktex = {
              onOpenAndSave = true;
              onEdit = true;
            };
          };
        };
      };
    };
  };
}
