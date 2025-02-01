final: prev: {
  gnome = prev.gnome.overrideScope (gfinal: gprev: {
    gnome-keyring = gprev.gnome-keyring.overrideAttrs (oldAttrs: {
      configureFlags = (builtins.filter (flag: flag != "--enable-ssh-agent")
        oldAttrs.configureFlags) ++ [ "--disable-ssh-agent" ];
    });
  });
}
