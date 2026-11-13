{ self, inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia.wrap {
        inherit pkgs; # THIS PART IS VERY IMPORTAINT, I FORGOT IT IN THE VIDEO!!!
        # settings = (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings;
        settings = (fromTOML (builtins.readFile ./noctalia.toml)).settings;
      };
    };
}
