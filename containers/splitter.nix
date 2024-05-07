{
  ephemeral = true;
  config = { pkgs, ... }: {
    system.stateVersion = "23.11";
    services.postgresql = {
      settings = { listen_addresses = "*"; port = 5908; };
      enable = true;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all       all     trust
        host all all      ::1/128      trust
        host all postgres 127.0.0.1/32 trust
      '';
    };

  };

}
