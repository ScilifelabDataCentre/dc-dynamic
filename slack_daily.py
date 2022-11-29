#!/usr/bin/env python3

import datetime
import os
import sys

import lxml
import requests
from bs4 import BeautifulSoup

SLL_FEED = "https://www.scilifelab.se/feed/"
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

    Requires a user/bot token in the environment variable SLACK_TOKEN.

    Args:
        payload (dict): Data to send.
    """
    API_URL = "https://slack.com/api/chat.postMessage"
    res = requests.post(
        API_URL, headers={"Authorization": f"Bearer {os.environ.get('SLACK_TOKEN')}"}, json=payload
    )
    # if res.status_code != 200 or res.json()["
    if not res.json()["ok"]:
        raise ValueError("Slack post failed")


def post_from_sll_feed(feed_name, channel, path="", name=""):
    """
    Post items from the SciLifeLab feed to a Slack channel.

     Args:
        feed_name (str): The item type (e.g. "career", "event").
        name (str): The custom name to use in the start message. Defaults to feed_name.
        channel (str): The ID of the channel to post in.
        path (str): Base path (except filename) for the helper file that will be created.
    """
    if not name:
        name = feed_name
    feed_req = requests.get(SLL_FEED)
    if feed_req.status_code != 200:
        raise ValueError("Unable to retrieve feed")
    helper_url = f"https://blobserver.dckube.scilifelab.se/blob/slack-helper-{feed_name}.dat"

    last_req = requests.get(helper_url)
    if last_req.status_code != 200:
        raise ValueError("Unable to retrieve helper")
    last = last_req.text
    soup = BeautifulSoup(feed_req.text, features="xml")

    new_last = ""
    entries = []
    for entry in soup.find_all("item"):
        if entry.guid.text == last:
            break
        if f"/{feed_name}/" in entry.link.text:
            if not new_last:
                new_last = entry.guid
            entries.append(
                f":scilife: *{entry.title.text}*\n <{entry.link.text}|More information>\n"
            )
    if entries:
        start_msg = f"New {name}{'s' if len(entries) > 1 else ''} posted on the <https://www.scilifelab.se/{feed_name}s/|{feed_name}s page>!"
        msg = gen_feed_payload(start_msg, entries, channel)
        post_to_slack(msg)

    if new_last:
        helper_filename = f"slack-helper-{feed_name}.dat"
        if path and not path.endswith("/"):
            path += "/"
        with open(path + helper_filename, "w") as new_last_file:
            new_last_file.write(new_last.text)


if __name__ == "__main__":
    path = "".join(sys.argv[1:]) if len(sys.argv) > 1 else ""
    try:
        post_from_sll_feed("career", os.environ.get("CAREER_CHANNEL", ""), path=path, name="job")
    except ValueError as err:
        sys.stderr.write(f"Job task failed: {err}")
    else:
        print("Job task finished")

    try:
        post_from_sll_feed("event", os.environ.get("EVENT_CHANNEL", path=path)
    except ValueError as err:
        sys.stderr.write(f"Event task failed: {err}")
    else:
        print("Event task finished")
