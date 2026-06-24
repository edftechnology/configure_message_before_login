#!/usr/bin/env bash
set -euo pipefail

USER_NAME="${1:-edenedfsls}"
LIGHTDM_LOG="${LIGHTDM_LOG:-/var/log/lightdm/lightdm.log}"
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-60}"
AUTO_SUBMIT_LOG="${AUTO_SUBMIT_LOG:-/tmp/lightdm_auto_submit.log}"

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

log() {
    printf '%s %s\n' "$(date -Is)" "$*" >> "$AUTO_SUBMIT_LOG"
}

if [[ ! -r "$LIGHTDM_LOG" ]]; then
    echo "LightDM log is not readable: $LIGHTDM_LOG" >&2
    log "LightDM log is not readable: $LIGHTDM_LOG"
    exit 1
fi

press_login() {
    local window_id
    local attempt

    for attempt in 1 2 3 4 5; do
        window_id="$(
            {
                xdotool search --onlyvisible --class lightdm-gtk-greeter 2>/dev/null
                xdotool search --onlyvisible --name "Login" 2>/dev/null
                xdotool search --onlyvisible --name "Log in" 2>/dev/null
            } | head -n 1 || true
        )"

        log "auto-submit attempt=${attempt} display=${DISPLAY:-unset} xauthority=${XAUTHORITY:-unset} window=${window_id:-none}"

        if [[ -n "$window_id" ]]; then
            xdotool windowactivate "$window_id" 2>>"$AUTO_SUBMIT_LOG" || true
            xdotool key --clearmodifiers Return 2>>"$AUTO_SUBMIT_LOG" || true
            xdotool key --clearmodifiers KP_Enter 2>>"$AUTO_SUBMIT_LOG" || true
        else
            xdotool key --clearmodifiers Return 2>>"$AUTO_SUBMIT_LOG" || true
            xdotool key --clearmodifiers KP_Enter 2>>"$AUTO_SUBMIT_LOG" || true
        fi

        sleep 0.4
    done
}

log "started user=${USER_NAME} lightdm_log=${LIGHTDM_LOG} timeout=${TIMEOUT_SECONDS} display=${DISPLAY:-unset} xauthority=${XAUTHORITY:-unset}"

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
    log "authentication success detected for user=${USER_NAME}"
    press_login
else
    log "finished without authentication success status=${status}"
fi

exit 0
