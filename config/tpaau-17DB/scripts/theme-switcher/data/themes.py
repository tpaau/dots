import os

class theme:
    def __init__(self, waybar_style: str, mako_conf: str, kitty_theme: str):
        self.waybar_style = waybar_style
        self.mako_conf = mako_conf
        self.kitty_theme = kitty_theme
        

    waybar_style: str
    mako_conf: str
    kitty_theme: str

AVAILABLE_THEMES = {
    'solid black, static waybar': theme(
        waybar_style=os.path.expanduser("~/.config/waybar/style-black-static.css"),
        mako_conf=os.path.expanduser("~/.config/mako/config"),
        kitty_theme="graphite"

    ),
    'solid black, floating waybar': theme(
        waybar_style=os.path.expanduser("~/.config/waybar/style-black-floating.css"),
        mako_conf=os.path.expanduser("~/.config/mako/config"),
        kitty_theme="graphite"
    )
}
