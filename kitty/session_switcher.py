import json
import math

from os.path import expanduser
from itertools import islice
from typing import List, Dict, Any
from kitty.boss import Boss
from kitty.remote_control import create_basic_command, encode_send
from kitty.typing import KeyEventType
from kittens.tui.handler import Handler
from kittens.tui.loop import Loop
from kittens.tui.operations import styled, repeat

class SessionSwitcher(Handler):

    def __init__(self):
        self.session_names = {}
        self.os_windows = []
        self.selected_session_idx = None
        self.cmds = []
        self.windows_text = {}

    def initialize(self) -> None:
        self.cmd.set_cursor_visible(False)
        self.draw_screen()
        ls = create_basic_command('ls', no_response=False)
        self.write(encode_send(ls))
        self.cmds.append({'type': 'ls'})
        try:
            with open(f"{expanduser('~')}/.kitty-sessions.json") as f:
                self.session_names = json.loads(f.read())
        except:
            self.session_names = {}


    # this assumes that communication via kitty cmds in synchronous...
    def on_kitty_cmd_response(self, response: Dict[str, Any]) -> None:
        cmd = self.cmds.pop()
        if cmd['type'] == 'ls':
            os_windows = json.loads(response['data'])
            self.os_windows = os_windows
            active_windows = next(w for w in os_windows if w['is_active'])
            self.selected_session_idx = os_windows.index(active_windows)
            cmds = []
            for os_window in os_windows:
                for tab in os_window['tabs']:
                    for w in tab['windows']:
                        wid = w['id']
                        get_text = create_basic_command('get-text', {'match': f'id:{wid}'}, no_response = False)
                        self.write(encode_send(get_text))
                        self.cmds.insert(0, {
                            'type': 'get-text',
                            'os_window_id': os_window['id'],
                            'tab_id': tab['id'],
                            'window_id': wid,
                        })
            self.cmds = self.cmds + cmds
            self.draw_screen()

        if cmd['type'] == 'get-text':
            text = response['data']
            self.windows_text[cmd['window_id']] = text
            self.draw_screen()


    def on_key(self, key_event: KeyEventType) -> None:
        if key_event.matches('esc'):
            self.quit_loop(0)

        if key_event.matches('enter'):
            tab = next(t for t in self.os_windows[self.selected_session_idx]['tabs'] if t['is_active'])
            window_id = next(w for w in tab['windows'] if w['is_active'])['id']
            focus_window = create_basic_command('focus_window', {'match': f'id:{window_id}'}, no_response = True)
            self.write(encode_send(focus_window))
            self.quit_loop(0)

        if key_event.key == 'j':
            self.selected_session_idx = (self.selected_session_idx + 1) % len(self.os_windows)
            self.draw_screen()

        if key_event.key == 'k':
            self.selected_session_idx = (self.selected_session_idx + -1 + len(self.os_windows)) % len(self.os_windows)
            self.draw_screen()


    def draw_screen(self) -> None:
        self.cmd.clear_screen()
        print = self.print
        if not self.os_windows:
            return
        for i, os_window in enumerate(self.os_windows):
            wid = os_window['id']
            session_name = f' {self.session_names.get(str(wid), wid)} '
            if i == self.selected_session_idx:
                print(styled(session_name, bg='green', fg='black'))
            else:
                print(session_name)

        tabs = list(islice(self.os_windows[self.selected_session_idx]['tabs'], 0, 4))
        padding = 4
        padding_left = repeat(' ', math.floor(padding / 2))
        border_count = len(tabs) + 1
        tab_width = math.floor((self.screen_size.cols - padding - border_count)/len(tabs))
        tab_height = math.floor(self.screen_size.rows / 2)

        for _ in range(self.screen_size.rows - len(self.os_windows) - tab_height - 4):
            print('')

        border = ''
        for tab in tabs:
            border += '+' + repeat('-', tab_width + 1)
        print(padding_left + border + '+')


        # messy code for tab preview diplay
        lines_by_tab = []
        for tab in tabs:
            new_line = []
            w = tab['windows'][0]
            lines = self.windows_text.get(w['id'], '').split('\n')
            for line in islice(lines, 0, tab_height):
                new_line.append(line[:tab_width - 2].ljust(tab_width - 1))
            lines_by_tab.append(new_line)

        for line in zip(*lines_by_tab):
            print(padding_left + '| ' + ' | '.join(line) + ' |')

        border = ''
        for tab in tabs:
            border += '+' + repeat('-', tab_width + 1)
        print(padding_left + border + '+')


def main(args: List[str]) -> str:
    loop = Loop()
    handler = SessionSwitcher()
    loop.loop(handler)
