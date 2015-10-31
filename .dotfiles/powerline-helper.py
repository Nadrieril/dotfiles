import sys, re

"""
Helps format powerline-like prompts

Example:
python powerline-helper.py zsh '#' 'F250,B240# %m #F240,B238# %n #F15,B31,bold# %~ #B236# $ '
"""

symbols = {
    'separator': u'\uE0B0',
    'separator_thin': u'\uE0B1'
}

color_templates = {
    'bash': '\\[\\e%s\\]',
    'zsh': '%%{%s%%}',
    'bare': '%s',
}

def parse_color(s):
    o = {'fg': '15', 'bg': '16', 'bold': False}
    for x in s.split(','):
        x = x.strip()
        if x == '': continue
        if x[0] == 'F':
            o['fg'] = x[1:]
        if x[0] == 'B':
            o['bg'] = x[1:]
        if x == 'bold':
            o['bold'] = True

    return o

def write_color(color_tpl, o):
    ret = ""
    if o['bold']:
        ret += color_tpl % '[1m'
    ret += color_tpl % ('[38;5;%sm' % o['fg'])
    ret += color_tpl % ('[48;5;%sm' % o['bg'])
    return ret

if __name__ == "__main__":
    args = sys.argv
    color_tpl = color_templates[args[1]]
    reset_color = color_tpl % '[0m'
    sep = args[2]

    segments = args[3].split(sep)
    if len(segments) % 2 == 1:
        segments.append('')

    # Transform segments to a list of elements of the form (color_code, text)
    segments = zip(segments[::2], segments[1::2])

    # Transform segments to a list of elements of the form (color_obj, text)
    segments = map(lambda x: (parse_color(x[0]), x[1]), segments)

    # Add separators between segments
    line = []
    segments = list(segments)
    for segment, next_segment in zip(segments, segments[1:]):
        line.append(segment)
        line.append(({'fg': segment[0]['bg'], 'bg': next_segment[0]['bg'], 'bold': False}
            , symbols['separator']))
    line.append(segments[-1])

    # Write line to stdout
    line = ''.join(map(lambda x: write_color(color_tpl, x[0]) + x[1] + reset_color, line))
    sys.stdout.write(line)
