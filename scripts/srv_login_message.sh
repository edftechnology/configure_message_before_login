#!/usr/bin/env bash
set -euo pipefail

AUTO_SUBMIT_HELPER="/home/edenedfsls/.local/bin/srv_lightdm_auto_submit.sh"

/usr/bin/zenity --info --no-wrap \
    --text="ATTENTION! \n\n EDF Technology, based on current labor legislation, reserves the right to audit and monitor the equipment and systems made available by it. \n Therefore, this equipment and / or system should only be used for corporate purposes of interest to the Company, if you have doubts about your permission to access it, \n and immediately, as the unauthorized use can be characterized by misuse and non-observance of the internal regulations, which may subject the employee to disciplinary penalties pertaining to the Information Security Policy and the Code of Conduct and Ethics. \n The actions performed on this equipment are monitored, which gives the owner the right to use them for any purpose." \
    --title="EDF Technology" \
    --width=1280 \
    --height=720 \
    --timeout=10 || true

if [[ -x "$AUTO_SUBMIT_HELPER" ]]; then
    "$AUTO_SUBMIT_HELPER" edenedfsls &
fi
