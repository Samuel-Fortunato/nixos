{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Insert the patch before Nixpkgs validates and repacks the Electron bundle.
  patchAnchor = "for js in app/.vite/build/*.js; do node --check";
  chatgpt = pkgs.chatgpt.overrideAttrs (old: {
    postPatch =
      assert lib.assertMsg
        (builtins.length (lib.splitString patchAnchor old.postPatch) == 2)
        "ChatGPT: upstream ASAR patch hook changed; review the new-window patch.";
      builtins.replaceStrings
        [ patchAnchor ]
        [
          ''
            # Allow the second instance to request a fresh window instead of focusing one.
            replaceInBundle 1 \
              'te=async(e,t)=>{try{let r=eM.getPrimaryWindow()??await eB("/")' \
              'te=async(e,t,fresh=!1)=>{try{let r=(fresh?null:eM.getPrimaryWindow())??await eB("/")'

            # Preserve deep-link and file handling before checking the new flag.
            replaceInBundle 1 \
              'if(e6.deepLinks.queueProcessArgs(e)){n&&te();return}n?te():' \
              'if(e6.deepLinks.queueProcessArgs(e)){n&&te();return}if(e.includes("--new-window"))return void te(void 0,void 0,!0);n?te():'

            for js in app/.vite/build/*.js; do node --check''
        ]
        old.postPatch;

    # Keep the original desktop entry, including its icon and MIME associations.
    postInstall = (old.postInstall or "") + ''
      substituteInPlace "$out/share/applications/chatgpt.desktop" \
        --replace-fail 'Exec=chatgpt %U' 'Exec=chatgpt --new-window %U'
    '';
  });
in
{
  options.my.modules.chatgpt.enable = lib.mkEnableOption "ChatGPT desktop";

  config = lib.mkIf config.my.modules.chatgpt.enable {
    home.packages = [ chatgpt ];
  };
}
