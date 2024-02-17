import os
from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer
from kitty.tab_bar import DrawData, ExtraData, TabBarData, draw_title, as_rgb
from kitty.utils import color_as_int

timer_id = None

def parse_stl(screen: Screen, draw_data: DrawData, stl: str, draw: bool):
	pos = 0
	length = 0
	while pos < len(stl):
		next = stl.find("#[", pos)
		if next == -1:
			length += len(stl[pos:])
			if draw:
				screen.draw(stl[pos:])
			return length

		length += len(stl[pos:next])
		if draw:
			screen.draw(stl[pos:next])
		pos = next + 1
		next = stl.find("]", pos)
		if next == -1:
			length += len(stl[pos:])
			if draw:
				screen.draw(stl[pos:])
			return length

		fmt = stl[pos+1:next].split(",")
		for f in fmt:
			if f.startswith("fg="):
				if f == "fg=default":
					screen.cursor.fg = as_rgb(int(draw_data.default_fg))
				else:
					screen.cursor.fg = as_rgb(int(f[4:10], 16))
			elif f.startswith("bg="):
				if f == "bg=default":
					screen.cursor.bg = as_rgb(int(draw_data.default_bg))
				else:
					screen.cursor.bg = as_rgb(int(f[4:10], 16))

		pos = next + 1

	return length

def draw_tpipeline(screen: Screen, draw_data: DrawData):
	stl = open('/tmp/tmux-' + str(os.getuid()) + '/default-$0-vimbridge').readline()
	parse_stl(screen, draw_data, stl, True)
	stl = open('/tmp/tmux-' + str(os.getuid()) + '/default-$0-vimbridge-R').readline()
	length = parse_stl(screen, draw_data, stl, False)
	screen.draw(" " * (screen.columns - screen.cursor.x - length))
	length = parse_stl(screen, draw_data, stl, True)

def redraw_tab_bar(timer_id):
	tm = get_boss().active_tab_manager
	if tm is not None:
		tm.mark_tab_bar_dirty()

def draw_tab(
		draw_data: DrawData, screen: Screen, tab: TabBarData,
		before: int, max_title_length: int, index: int, is_last: bool,
		extra_data: ExtraData
		) -> int:

	global timer_id
	if timer_id is None:
		timer_id = add_timer(redraw_tab_bar, 0.3, True)

	if index == 1:
		draw_tpipeline(screen, draw_data)

	return screen.cursor.x
