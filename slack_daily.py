#!/usr/bin/env python3

# Expects a bot token in SLACK_BOT_TOKEN
# Expects a user token in SLACK_USER_TOKEN

import datetime
import os

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

    Args:
        payload (dict): Data to send.
    """
    API_URL = "https://slack.com/api/chat.postMessage"
    res = requests.post(
        API_URL, headers={"Authorization": f"Bearer {os.environ.get('SLACK_TOKEN')}"}, json=payload
    )
    print(res)
    print(res.json())


def check_scilifelab_jobs(max_age=24):
    """
    Check for new jobs in the SciLifeLab jobs event feed.

    Args:
        max_age (int): Maximum time since the job was posted (hours).
    """
    feed_req = requests.get(SLL_FEED)
    soup = BeautifulSoup(feed_req.text, features="xml")
    time_limit = datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(hours=max_age)

    entries = []
    for entry in soup.find_all("item"):
        timestamp = datetime.datetime.strptime(entry.pubDate.text, FEED_DATE_FORMAT)
        if timestamp > time_limit:
            # the feed is a mix of everything, looking for /career/ in the link seems to work
            if "/career/" in entry.link.text:
                entries.append(
                    f":scilife: *{entry.title.text}*\n <{entry.link.text}|More information>\n"
                )
    if entries:
        if len(entries) > 1:
            start_msg = "New jobs posted on the <https://www.scilifelab.se/careers/|careers page>!"
        else:
            start_msg = "New job posted on the <https://www.scilifelab.se/careers/|careers page>!"
        # G019SN15M1T = #dc-dev-experimentation
        # C01LM5A7RUN = #jobs
        msg = gen_feed_payload(start_msg, entries, "C01LM5A7RUN")

        post_to_slack(msg)


check_scilifelab_jobs(24)
