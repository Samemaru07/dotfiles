#!/usr/bin/env python3
import curses
import time

# 5-row thick block digits
DIGITS = [
    ["█████", "█   █", "█   █", "█   █", "█████"],  # 0
    ["  █  ", "  █  ", "  █  ", "  █  ", "  █  "],  # 1
    ["█████", "    █", "█████", "█    ", "█████"],  # 2
    ["█████", "    █", "█████", "    █", "█████"],  # 3
    ["█   █", "█   █", "█████", "    █", "    █"],  # 4
    ["█████", "█    ", "█████", "    █", "█████"],  # 5
    ["█████", "█    ", "█████", "█   █", "█████"],  # 6
    ["█████", "    █", "    █", "    █", "    █"],  # 7
    ["█████", "█   █", "█████", "█   █", "█████"],  # 8
    ["█████", "█   █", "█████", "    █", "█████"],  # 9
]
COLON = ["   ", " █ ", "   ", " █ ", "   "]

def draw_clock(stdscr):
    try:
        curses.curs_set(0)
    except curses.error:
        pass
    curses.start_color()
    curses.init_pair(1, curses.COLOR_CYAN, curses.COLOR_BLACK)
    curses.init_pair(2, curses.COLOR_WHITE, curses.COLOR_BLACK)
    stdscr.timeout(500)

    while True:
        stdscr.erase()
        h, w = stdscr.getmaxyx()
        now = time.localtime()

        hh = f"{now.tm_hour:02d}"
        mm = f"{now.tm_min:02d}"

        # HH : MM  (5 segments: d d : d d, each 5 wide + 1 space gap)
        segments = [DIGITS[int(hh[0])], DIGITS[int(hh[1])],
                    COLON,
                    DIGITS[int(mm[0])], DIGITS[int(mm[1])]]

        clock_h = 5
        seg_w = 5
        gap = 1
        total_w = len(segments) * seg_w + (len(segments) - 1) * gap
        date_str = time.strftime("%Y-%m-%d", now)

        # Total height: clock(5) + gap(1) + date(1) = 7
        total_h = 7
        start_y = max(0, (h - total_h) // 2)
        start_x = max(0, (w - total_w) // 2)

        for row in range(clock_h):
            x = start_x
            for seg in segments:
                try:
                    stdscr.addstr(start_y + row, x, seg[row], curses.color_pair(1) | curses.A_BOLD)
                except curses.error:
                    pass
                x += seg_w + gap

        date_x = max(0, (w - len(date_str)) // 2)
        try:
            stdscr.addstr(start_y + clock_h + 1, date_x, date_str,
                          curses.color_pair(2) | curses.A_BOLD)
        except curses.error:
            pass

        stdscr.refresh()
        key = stdscr.getch()
        if key == ord('q'):
            break

curses.wrapper(draw_clock)
