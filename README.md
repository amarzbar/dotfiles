# My Dotfiles

This repository contains my configuration files for Arch Linux with i3, Rofi, Polybar, and Neovim.

![Screenshot](Screenshot.png)

## Installation

1. **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/dotfiles.git
    cd dotfiles
    ```

2. **Create symlinks:**
    ```bash
    ./install.sh
    ```

3. **Install necessary packages:**
    ```bash
    sudo pacman -S i3 rofi polybar neovim
    ```

4. **Restart i3:**
    ```bash
    i3-msg restart
    ```

## Configurations

- **i3:** `~/.config/i3/config`
- **Rofi:** `~/.config/rofi/config.rasi`
- **Polybar:** `~/.config/polybar/config`
- **Neovim:** `~/.config/nvim/init.vim`

## Wallpaper

The wallpaper is set at i3 startup by `feh` (see `i3/config`):

```
exec --no-startup-id feh --randomize --bg-fill $HOME/Pictures/Wallpapers/
```

`feh` picks a random image from `~/Pictures/Wallpapers/` and paints it as the X
root background. Drop images into that directory to add to the rotation.
Requires `feh` (`sudo pacman -S feh`).
