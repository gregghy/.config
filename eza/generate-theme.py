#!/usr/bin/env python3
"""Generate ~/.config/eza/theme.yml from yazi's theme-dark.toml icon table,
tinted with the gruvbox-dark flavor's filetype colors."""
import tomllib

ICON_TOML = "/tmp/yazi-dark.toml"
ICON_URL = "https://raw.githubusercontent.com/sxyazi/yazi/main/yazi-config/preset/theme-dark.toml"

import os, urllib.request
if not os.path.exists(ICON_TOML):
    urllib.request.urlretrieve(ICON_URL, ICON_TOML)
OUT = "/home/gregghy/.config/eza/theme.yml"

# gruvbox mime-group colors (from yazi flavor.toml [filetype] rules)
IMG, MEDIA, ARCHIVE, DOC, DIR, NORMAL, AQUA = (
    "#d3869b", "#fabd2f", "#fb4934", "#689d6a", "#83a598", "#ebdbb2", "#8ec07c")

IMAGE_EXTS = {"png","jpg","jpeg","gif","webp","bmp","svg","ico","avif","heic","heif",
              "tiff","tif","raw","cr2","nef","dng","psd","xcf","jxl","qoi"}
MEDIA_EXTS = {"mp3","wav","flac","ogg","oga","m4a","aac","opus","wma","mid","midi",
              "mp4","mkv","avi","mov","webm","m4v","wmv","flv","mpg","mpeg","ts","m2ts","3gp"}
ARCHIVE_EXTS = {"zip","tar","gz","tgz","bz2","tbz2","xz","txz","zst","tzst","7z","rar",
                "lz4","lzo","jar","war","apk","aab","deb","rpm","iso","img","dmg"}
DOC_EXTS = {"pdf","doc","docx","xls","xlsx","ppt","pptx","odt","ods","odp","rtf",
            "epub","mobi","djvu","csv","tsv","md","txt"}

def grp_color(ext):
    if ext in IMAGE_EXTS: return IMG
    if ext in MEDIA_EXTS: return MEDIA
    if ext in ARCHIVE_EXTS: return ARCHIVE
    if ext in DOC_EXTS: return DOC
    return None

with open(ICON_TOML, "rb") as f:
    icon = tomllib.load(f)["icon"]

def esc(s):
    return s.replace("\\", "\\\\").replace('"', '\\"')

def style_block(glyph, fg):
    return f'{{glyph: "{esc(glyph)}", style: {{foreground: "{fg}"}}}}'

lines = []
lines.append('# eza theme — generated from yazi gruvbox-dark flavor')
lines.append('# colors: yazi filetype rules | icons: yazi icon table')
lines.append('colourful: true')
lines.append('')
lines.append('filekinds:')
for k, v in {
    "normal": f'foreground: "{NORMAL}"',
    "directory": f'foreground: "{DIR}", is_bold: true',
    "symlink": f'foreground: "{AQUA}"',
    "pipe": 'foreground: "#928374"',
    "socket": 'foreground: "#928374"',
    "block_device": 'foreground: "#928374"',
    "char_device": 'foreground: "#928374"',
    "special": 'foreground: "#665c54"',
    "executable": 'foreground: "#b8bb26", is_bold: true',
    "mount_point": f'foreground: "{DIR}", is_bold: true, is_underline: true',
}.items():
    lines.append(f'  {k}: {{{v}}}')
lines.append('')
lines.append('perms:')
for scope in ("user", "group", "other"):
    lines.append(f'  {scope}_read:      {{foreground: "#b8bb26"}}')
    lines.append(f'  {scope}_write:     {{foreground: "#fb4934"}}')
    lines.append(f'  {scope}_execute_file:  {{foreground: "#b8bb26"}}')
    lines.append(f'  {scope}_execute_other: {{foreground: "#b8bb26"}}')
lines.append('  special_user_file: {foreground: "#fe8019"}')
lines.append('  special_other:     {foreground: "#fe8019"}')
lines.append('  attribute:         {foreground: "#665c54"}')
lines.append('')
lines.append('size:')
for k in ("number_byte", "number_kilo", "number_mega", "number_giga", "number_tera", "number_huge"):
    lines.append(f'  {k}: {{foreground: "#83a598", is_bold: true}}')
for k in ("unit_byte", "unit_kilo", "unit_mega", "unit_giga", "unit_tera", "unit_huge"):
    lines.append(f'  {k}: {{foreground: "#928374"}}')
lines.append('')
lines.append('users:')
lines.append('  user_you:    {foreground: "#b8bb26"}')
lines.append('  user_root:   {foreground: "#fb4934", is_bold: true}')
lines.append('  user_other:  {foreground: "#928374"}')
lines.append('  group_yours: {foreground: "#b8bb26"}')
lines.append('  group_other: {foreground: "#928374"}')
lines.append('')
lines.append('links:')
lines.append('  normal:          {foreground: "#8ec07c"}')
lines.append('  multi_link_file: {foreground: "#8ec07c", is_bold: true}')
lines.append('')
lines.append('git:')
for k, c in {"new": "#b8bb26", "modified": "#fabd2f", "deleted": "#fb4934",
             "renamed": "#8ec07c", "typechange": "#d3869b",
             "ignored": "#665c54", "conflicted": "#fe8019"}.items():
    lines.append(f'  {k}: {{foreground: "{c}"}}')
lines.append('')
lines.append('punctuation:    {foreground: "#665c54"}')
lines.append('date:           {foreground: "#928374"}')
lines.append('inode:          {foreground: "#928374"}')
lines.append('blocks:         {foreground: "#928374"}')
lines.append('octal:          {foreground: "#928374"}')
lines.append('flags:          {foreground: "#928374"}')
lines.append('symlink_path:   {foreground: "#8ec07c"}')
lines.append('control_char:   {foreground: "#fb4934"}')
lines.append('broken_symlink: {foreground: "#fb4934", is_bold: true}')
lines.append('broken_path:    {foreground: "#fb4934", is_bold: true}')
lines.append('')

lines.append('filenames:')
for e in icon.get("dirs", []) + icon.get("files", []):
    name, text, fg = e["name"], e["text"], e.get("fg") or NORMAL
    lines.append(f'  "{esc(name)}": {{filename: {{foreground: "{fg}"}}, icon: {style_block(text, fg)}}}')
lines.append('')

lines.append('extensions:')
for e in icon.get("exts", []):
    name, text, fg = e["name"], e["text"], e.get("fg") or NORMAL
    name_fg = grp_color(name) or fg
    lines.append(f'  {esc(name)}: {{filename: {{foreground: "{name_fg}"}}, icon: {style_block(text, fg)}}}')

with open(OUT, "w") as f:
    f.write("\n".join(lines) + "\n")
print(f"wrote {OUT}: {len(lines)} lines, "
      f"{len(icon.get('dirs',[]))} dirs + {len(icon.get('files',[]))} files + {len(icon.get('exts',[]))} exts")
