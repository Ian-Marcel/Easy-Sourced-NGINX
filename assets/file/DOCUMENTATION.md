## Comments
- `/uninstall.sh`
    - .1: `$total_tasks` holds the highest index (last element’s index), not the actual count of tasks. In most "$0..n$"–style loops this behaves like a total, but if your array is explicitly indexed (e.g. starts at `[1]` or has gaps), use `"${#list[@]}"` (the true length) instead.
- `/assets/source/distro_dependecies_check.sh`
    - .1: `$total_tasks` holds the highest index (last element’s index), not the actual count of tasks. In most "$0..n$"–style loops this behaves like a total, but if your array is explicitly indexed (e.g. starts at `[1]` or has gaps), use `"${#list[@]}"` (the true length) instead.
