local hotkeys_popup = require('awful.hotkeys_popup.widget')

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
local keys = require('awful.hotkeys_popup.keys')
keys.tmux.add_rules_for_terminal({ rule = { name = { 'tmux' } } })

local kitty_rule = { class = { 'Kitty', 'kitty' } }
local group_data = { color = '#009F00', rule_any = kitty_rule }
local kitty_keys = {
  ['Kitty:clipboard'] = {
    {
      modifiers = { 'Ctrl', 'Shift' },
      keys = {
        c = 'Copy to clipboard',
        v = 'Paste from clipboard',
        s = 'Paste from selection',
        o = 'Pass selection to program',
      },
    },
    {
      modifiers = { 'Shift' },
      keys = { ['Insert'] = 'Paste from selection' },
    },
  },
  ['Kitty:scroll'] = {
    {
      modifiers = { 'Ctrl', 'Shift' },
      keys = {
        ['Up'] = 'Scrool line up',
        k = 'Scrool line up',
        ['Down'] = 'Scrool line down',
        j = 'Scrool line down',
        ['PageUp'] = 'Scrool page up',
        ['PageDown'] = 'Scrool page down',
        ['Home'] = 'Scrool home',
        ['End'] = 'Scrool end',
        z = 'Scroll to previous prompt',
        x = 'Scroll to next prompt',
        h = 'Show scrollback',
        g = 'Show last command output',
      },
    },
  },
  ['Kitty:window'] = {
    {
      modifiers = { 'Ctrl', 'Shift' },
      keys = {
        ['Enter'] = 'New window',
        n = 'New OS window',
        w = 'Close window',
        [']'] = 'Next window',
        ['['] = 'Previous window',
        f = 'Move window forward',
        b = 'Move window backward',
        ['`'] = 'Move window to top',
        r = 'Star window resizing',
        ['1..0'] = 'Select specified window',
        ['F7'] = 'Focus visible window',
        ['F8'] = 'Swap with window',
      },
    },
  },
  ['Kitty:tab'] = {
    {
      modifiers = { 'Ctrl' },
      keys = {
        ['Tab'] = 'Next tab',
      },
    },
    {
      modifiers = { 'Ctrl', 'Shift', 'Mod1' },
      keys = {
        t = 'Set tab title',
      },
    },
    {
      modifiers = { 'Ctrl', 'Shift' },
      keys = {
        ['Right'] = 'Next tab',
        ['Left'] = 'Previous tab',
        ['Tab'] = 'Previous tab',
        t = 'New tab',
        q = 'Close tab',
        ['.'] = 'Move tab forward',
        [','] = 'Move tab backward',
      },
    },
  },
  ['Kitty:layout'] = { {
    modifiers = { 'Ctrl', 'Shift' },
    keys = { l = 'Next layout' },
  } },
  ['Kitty:font'] = {
    {
      modifiers = { 'Ctrl', 'Shift' },
      keys = {
        ['='] = 'Increase font size',
        ['+'] = 'Increase font size',
        ['-'] = 'Decrease font size',
        ['Backspace'] = 'Reset font size',
      },
    },
  },
  ['Kitty:selection'] = {
    {
      modifiers = { 'Ctrl', 'Shift' },
      keys = {
        e = 'Open URL',
        pf = 'Insert selected path',
        pF = 'Open selected path',
        pl = 'Insert selected line',
        pw = 'Insert selected word',
        ph = 'Insert selected hash',
        pn = 'Open the selected file at the selected line',
        py = 'Open the selected hyperlink',
      },
    },
  },
  ['Kitty:miscellaneous'] = {
    {
      modifiers = { 'Ctrl', 'Shift' },
      keys = {
        ['F1'] = 'Show documentation',
        ['F11'] = 'Toggle fullscreen',
        ['F10'] = 'Toggle maximized',
        u = 'Unicode input',
        ['F2'] = 'Edit config file',
        ['Esc'] = 'Open the kitty command shell',
        am = 'Increase background opacity',
        al = 'Decrease background opacity',
        a1 = 'Make background fully opaque',
        ad = 'Reset background opacity',
        ['Delete'] = 'Reset the terminal',
        ['F5'] = 'Reload kitty.conf',
        ['F6'] = 'Debug kitty configuration',
      },
    },
  },
}

for group_name, _ in pairs(kitty_keys) do
  hotkeys_popup.add_group_rules(group_name, group_data)
end

hotkeys_popup.add_hotkeys(kitty_keys)
