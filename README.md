# CuteCosmic

Plugins to the Qt toolkit that help make Qt (and KDE) applications look and feel more at home in the COSMIC™ Desktop environment.

Currently consists of a Qt Platform Theme plugin.

![Build Status](https://github.com/tenshou170/cutecosmic-nix/actions/workflows/build.yml/badge.svg)

> [!CAUTION]
> CuteCosmic is still experimental, things can break for NixOS.

>[!IMPORTANT]
> This fork of [CuteCosmic](https://github.com/IgKh/cutecosmic) is made specifically for NixOS. Use this repo to [report issues](https://github.com/tenshou170/cutecosmic-nix/issues) regarding CuteCosmic running on NixOS.

>[!Warning]
> CuteCosmic currently supports `nixos-unstable` (25.11 as of November 2025) branch. Advanced users can test this with `nixos-stable` branch at their own risk.
> 
> Although, support can be added through well-tested PRs.

## Features

The following configuration is relayed from COSMIC settings to Qt applications:

- [x] Dark mode
- [x] Per-application dark mode override
- [x] High contrast mode (Qt 6.10+)
- [x] File dialogs
- [x] Icon theme
  - Including symbolic icon re-coloring to avoid dark-on-dark icons
- [x] Fonts
- [x] Color palette[^1]

[^1]: Requires enabling the toolkit theming option in COSMIC settings. Most KDE applications require a restart after theme change.

## Sounds good, but how does it look?

The Qt Widgets Gallery example with the default COSMIC Light theme, Fusion style and the Pop! icon theme:

![Widget Gallery in Light Mode](.github/assets/gallery-default-light.png)

KDE Discover rocking the COSMIC version of the [Catppuccin](https://github.com/catppuccin/cosmic-desktop) Macchiato Lavender theme with the Breeze style and icons:

![KDE Discover in Dark Mode](.github/assets/discover-catppuccin.png)

## Installation

### Using Nix Flakes (Recommended)

#### Optional: Setup Cachix for faster installation

To avoid building from source, use the CuteCosmic binary cache:

```bash
# Install cachix if not already installed
nix-env -iA cachix -f https://cachix.org/api/v1/install

# Add the cutecosmic cache
cachix use cutecosmic
```

Or add it directly to your NixOS configuration:

```nix
{
  nix.settings = {
    substituters = [ "https://cutecosmic.cachix.org" ];
    trusted-public-keys = [ "cutecosmic.cachix.org-1:M2oYEewcaHGXvY5E0gk5hM/te42lRJHeG+x6v7VmWoo=" ];
  };
}
```

#### 1. Add CuteCosmic to your flake inputs

```nix
{
  inputs = {
    #...other inputs
    cutecosmic.url = "github:tenshou170/cutecosmic-nix";
  };
  #...rest of flake.nix
}
```

#### 2. Install in your NixOS configuration

```nix
{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.cutecosmic.packages.${pkgs.system}.default
  ];
}
```

#### 3. Set the platform theme environment variable

```nix
# In your NixOS configuration
environment.sessionVariables = {
  QT_QPA_PLATFORMTHEME = "cosmic";
};
```

### Building from Source with Nix

```bash
# Clone the repository
git clone https://github.com/tenshou170/cutecosmic-nix.git
cd cutecosmic-nix

# Optional: Use cachix for dependencies
cachix use cutecosmic

# Build using Nix flakes
nix build

# Or without flakes
nix-build
```

The built plugin will be available in `./result/lib/qt-6/plugins/platformthemes/libcutecosmictheme.so`

### Development Environment

Enter a development shell with all dependencies:

```bash
# With flakes
nix develop

# Without flakes
nix-shell
```

## Usage

If installed correctly, CuteCosmic will automatically be loaded and used when working from inside a `cosmic-session`.

You can force its usage with the `QT_QPA_PLATFORMTHEME` environment variable:

```bash
QT_QPA_PLATFORMTHEME=cosmic /path/to/a/qt/app
```

### Testing Without Installing

After building with Nix, you can test the plugin without system-wide installation:

```bash
export QT_QPA_PLATFORMTHEME=cosmic
export QT_PLUGIN_PATH=$(pwd)/result/lib/qt-6/plugins:$QT_PLUGIN_PATH
qtcreator  # or any Qt application
```

### Troubleshooting

If not working, set the `QT_DEBUG_PLUGINS` environment variable and watch the log traces to see if `libcutecosmictheme.so` is available and loaded:

```bash
QT_DEBUG_PLUGINS=1 QT_QPA_PLATFORMTHEME=cosmic your-qt-app
```

## Configuration

Most of the configuration is done using the options already present in the COSMIC Settings application.

CuteCosmic will by default use the Breeze widgets style engine if installed, or the built-in Fusion style otherwise. If you want it to use another style by default (e.g. Kvantum), you can set the `CUTECOSMIC_DEFAULT_STYLE` environment variable:

```nix
# In your NixOS configuration
environment.sessionVariables = {
  CUTECOSMIC_DEFAULT_STYLE = "kvantum";
};
```

## Important Notes

1. CuteCosmic makes extensive use of private Qt APIs that are outside the scope of Qt's normal compatibility guarantees. The Nix build pins specific Qt versions to ensure compatibility.

2. Applications distributed in self-contained packages (AppImage, Flatpak, etc.) have their own Qt build which cannot easily be extended with this plugin. This package is primarily for system Qt applications.

## Contributing

Issue reports and code contributions are gratefully accepted. Please do not send unsolicited Pull Requests; please first propose patch ideas and plans in the relevant issue (or open an issue if one doesn't already exist).

## License

Copyright 2025 Igor Khanin.

Made available under the [GPL v3](https://choosealicense.com/licenses/gpl-3.0/) license.

## Prior Art

Other third party Qt integration plugins:

- [KDE Plasma](https://invent.kde.org/plasma/plasma-integration)
- [LXQt](https://github.com/lxqt/lxqt-qtplugin)
- [qt6ct](https://www.opencode.net/trialuser/qt6ct) (Generic)
  - [KDE Patches](https://aur.archlinux.org/packages/qt6ct-kde)
- [GNOME](https://github.com/FedoraQt/QGnomePlatform/)
- [Liri](https://github.com/lirios/qtintegration)
- [Haiku](https://github.com/threedeyes/qthaikuplugins)