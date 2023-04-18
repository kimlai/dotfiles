import json

from os.path import expanduser
from typing import List
from kitty.boss import Boss
from kittens.tui.operations import styled
from kitty.fast_data_types import current_focused_os_window_id

def main(args: List[str]) -> str:
    # this is the main entry point of the kitten, it will be executed in
    # the overlay window when the kitten is launched
    print(styled('Enter the new title for this session below.', bold=True))
    answer = input('> ')
    # whatever this function returns will be available in the
    # handle_result() function
    return answer

def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    with open(f"{expanduser('~')}/.kitty-sessions.json") as f:
        session_names = json.loads(f.read())
        session_names[str(current_focused_os_window_id())] = answer
    with open(f"{expanduser('~')}/.kitty-sessions.json", "w") as f:
        f.write(json.dumps(session_names))
