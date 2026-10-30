#!/bin/bash
# nchat attachment opener: images -> kitty overlay, media -> mpv, rest -> xdg-open
f="${!#}"
case "$(file -b --mime-type "$f")" in
    image/*)
        kitty --class nchat-media -o background_opacity=1 --hold +kitten icat "$f"
        ;;
    video/* | audio/*)
        mpv --loop-file=inf "$f" &
        ;;
    *)
        xdg-open "$f" &
        ;;
esac
