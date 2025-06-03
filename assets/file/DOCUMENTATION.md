## Comments

- `/uninstall.sh`
    - comment.1: `$total_tasks` holds the highest index (last element’s index), not the actual count of tasks. In most "$0..n$"–style loops this behaves like a total, but if your array is explicitly indexed (e.g. starts at `[1]` or has gaps), use `"${#list[@]}"` (the true length) instead. [Files with this comment](## Location)

- - -

## Location

- comment.1: `/uninstall.sh`, `/assets/source/distro_dependecies_check.sh`

