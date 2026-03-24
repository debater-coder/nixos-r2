{ self, inputs, ... }:
{
  flake.nixosConfigurations.starscream = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.starscreamConfiguration
      inputs.home-manager.nixosModules.home-manager
      inputs.stylix.nixosModules.stylix
    ];
  };
}
