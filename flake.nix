{
  description = "A collection of beat's flake templates";
  # NOTE: for more templates @see https://github.com/NixOS/templates

  outputs =
    { self }:
    {
      templates = {

        trivial = {
          path = ./trivial;
          description = "A very basic flake";
        };

        hetzner = {
          path = ./hetzner;
          description = "A flake to deploy to hetzner with deploy-rs and nixos-anywhere";
        };

        defaultTemplate = self.templates.trivial;
      };
    };
}
