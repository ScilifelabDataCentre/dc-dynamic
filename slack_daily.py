#!/usr/bin/env python3

# Expects a bot token in SLACK_BOT_TOKEN
# Expects a user token in SLACK_USER_TOKEN

import datetime
import os
import sys

import lxml
import requests
from bs4 import BeautifulSoup

SLL_FEED = "https://www.scilifelab.se/feed/"
EVENTS_HELPER_FILENAME="slack-helper-events.dat"
EVENT_HELPER_URL = "https://blobserver.dckube.scilifelab.se/blob/slack-helper-events.dat"
JOB_HELPER_URL = "https://blobserver.dckube.scilifelab.se/blob/slack-helper-jobs.dat"
JOB_HELPER_FILENAME="slack-helper-jobs.dat"
FEED_DATE_FORMAT = "%a, %d %b %Y %H:%M:%S %z"


def gen_feed_payload(start_msg: str, entries: list, channel: str) -> dict:
    """
    Generate a payload with blocks formatting and text.

    Args:
        start_msg (str): Message to show before listing entries.
        entries (list): The entries to include (str).
        channel (str): The ID of the channel to post in.

    Returns:
        dict: The generated payload.
    """
    payload = {
        "channel": channel,
        "unfurl_links": False,
        "blocks": [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"*{start_msg}*",
                },
            },
            {"type": "divider"},
        ],
    }

    for entry in entries:
        payload["blocks"].append(
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": entry,
                },
            }
        )

    return payload


def post_to_slack(payload: dict):
    """
    Post a message to Slack.

    Args:
        payload (dict): Data to send.
    """
    API_URL = "https://slack.com/api/chat.postMessage"
    res = requests.post(
        API_URL, headers={"Authorization": f"Bearer {os.environ.get('SLACK_TOKEN')}"}, json=payload
    )
    # if res.status_code != 200 or res.json()["
    
    print(res)
    print(res.json())


def check_scilifelab_jobs(prefix=""):
    """
    Check for new jobs in the SciLifeLab jobs event feed.

     Args:
        prefix (str): Prefix (path) for the created helper file.
    """
    feed_req = requests.get(SLL_FEED)
    if feed_req.status_code != 200:
        raise ValueError("Unable to retrieve feed")
    last_req = requests.get(JOB_HELPER_URL)
    if last_req.status_code != 200:
        raise ValueError("Unable to retrieve helper")
    last = last_req.text
    soup = BeautifulSoup(feed_req.text, features="xml")

    new_last = ""
    entries = []
    for entry in soup.find_all("item"):
        if entry.guid.text == last:
            break
        if "/career/" in entry.link.text:
            print(entry.guid.text)
            if not new_last:
                new_last = entry.guid
            entries.append(
                f":scilife: *{entry.title.text}*\n <{entry.link.text}|More information>\n"
            )
    if entries:
        start_msg = f"New job{'s' if len(entries) > 1 else ''} posted on the <https://www.scilifelab.se/careers/|careers page>!"
        # G019SN15M1T = #dc-dev-experimentation
        # C01LM5A7RUN = #jobs
        msg = gen_feed_payload(start_msg, entries, "G019SN15M1T")
        # post_to_slack(msg)

    if new_last:
        with open(prefix + "/" + JOB_HELPER_FILENAME, "w") as new_last_file:
            new_last_file.write(new_last.text)


if __name__ == "__main__":
    prefix = "".join(sys.argv[1:]) if len(sys.argv) > 1 else ""
    try:
        check_scilifelab_jobs(prefix)
    except ValueError as err:
        sys.stderr.write(f"Job task failed: {err}")
    else:
        print("Job task finished")
