#!/usr/bin/env bash
set -euo pipefail

USER_NAME="${1:-edenedfsls}"
LIGHTDM_LOG="${LIGHTDM_LOG:-/var/log/lightdm/lightdm.log}"
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-60}"

export DISPLAY="${DISPLAY:-:0}"

if [[ -z "${XAUTHORITY:-}" ]]; then
    for candidate in \
        "/var/lib/lightdm/.Xauthority" \
        "/run/lightdm/root/:0" \
        "/run/lightdm/root/:1"; do
        if [[ -e "$candidate" ]]; then
            export XAUTHORITY="$candidate"
            break
        fi
    done
fi

if ! command -v xdotool >/dev/null 2>&1; then
    echo "xdotool is required for LightDM auto-submit." >&2
    exit 1
fi

if [[ ! -r "$LIGHTDM_LOG" ]]; then
    echo "LightDM log is not readable: $LIGHTDM_LOG" >&2
    exit 1
fi

press_login() {
    local window_id
    window_id="$(xdotool search --onlyvisible --class lightdm-gtk-greeter 2>/dev/null | head -n 1 || true)"
    if [[ -n "$window_id" ]]; then
        xdotool windowactivate "$window_id" key Return
    else
        xdotool key Return
    fi
}

timeout "$TIMEOUT_SECONDS" bash -c '
    log_file="$1"
    user_name="$2"
    tail -n 0 -F "$log_file" 2>/dev/null |
    while IFS= read -r line; do
        case "$line" in
            *"Authenticate result for user ${user_name}: Success"*)
                sleep 0.3
                exit 10
                ;;
        esac
    done
' bash "$LIGHTDM_LOG" "$USER_NAME" || status=$?

status="${status:-0}"
if [[ "$status" == "10" ]]; then
    press_login
fi

exit 0
