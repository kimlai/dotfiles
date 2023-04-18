"""draw kitty tab"""
# pyright: reportMissingImports=false
# pylint: disable=E0401,C0116,C0103,W0603,R0913

import json

from os.path import expanduser

from kitty.fast_data_types import Screen, get_options, add_timer, current_focused_os_window_id
from kitty.tab_bar import (DrawData, ExtraData, TabBarData, as_rgb,
                           draw_tab_with_fade, draw_title)
from kitty.utils import color_as_int

opts = get_options()

def get_current_session():
    session_id = current_focused_os_window_id()
    try:
        with open(f"{expanduser('~')}/.kitty-sessions.json") as f:
            session_name = json.loads(f.read())[str(session_id)]
    except:
        session_name = "toto"
    return f" {session_name} "


def draw_session_name(screen: Screen, index: int) -> int:
    if index != 1:
        return screen.cursor.x

    session: str = get_current_session()

    fg, bg, bold, italic = (
        screen.cursor.fg,
        screen.cursor.bg,
        screen.cursor.bold,
        screen.cursor.italic,
    )
    screen.cursor.bold, screen.cursor.italic, screen.cursor.fg, screen.cursor.bg = (
        False,
        False,
        as_rgb(color_as_int(opts.color16)),
        as_rgb(color_as_int(opts.color2))
    )
    screen.draw(session)
    # set cursor position
    screen.cursor.x = len(session)
    # restore color style
    screen.cursor.fg, screen.cursor.bg, screen.cursor.bold, screen.cursor.italic = (
        fg,
        bg,
        bold,
        italic,
    )
    return screen.cursor.x


def draw_left_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData
) -> int:
    end = draw_tab_with_fade(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )
    return end

timer_id = None

def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global timer_id
    draw_session_name(screen, index)

    # Set cursor to where `left_status` ends, instead `right_status`,
    # to enable `open new tab` feature
    end = draw_left_status(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )
    return end
