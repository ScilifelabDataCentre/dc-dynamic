#!/usr/bin/env python3

import datetime
import os
import sys

import requests

def get_new_figshare_items(day: str) -> list:
    """
    Obtain new items from the SciLifeLab Figshare instance.
    """
    query = f"https://api.figshare.com/v2/articles?page_size=10&order=published_date&order_direction=desc&institution=803&published_since={day}"
    req = requests.get(query)
    if req.status_code == 200:
        entries = [entry for entry in req.json() if entry["published_date"].startswith(day)]
    else:
        raise ValueError("Unable to retrieve the items")
    return entries


def gen_feed_payload(start_msg: str, entries: list, channel: str, day: str) -> dict:
    """
    Generate a payload with blocks formatting and text.

    The items will be "formatted for Twitter".

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
                    "text": f":figshare: *{len(entries)} new item{'s' if len(entries) > 1 else ''} in Figshare from {day}* :figshare:",
                },
            }
        ],
    }

    for entry in entries:
        payload["blocks"].append(
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": start_msg,
                },
            })
        payload["blocks"].append(
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": entry,
                },
            }
        )
        payload["blocks"].append({"type": "divider"})

    return payload


def gen_twitter_formatting(data_entries: list) -> list:
    twitter_entries = []
    for entry in data_entries:
        twitter_entries.append(f"{entry['title']}\nhttps://{entry['doi']}")
    return twitter_entries


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


def post_from_figshare(channel):
    """
    Post items from the SciLifeLab feed to a Slack channel.

     Args:
        feed_name (str): The item type (e.g. "career", "event").
        name (str): The custom name to use in the start message. Defaults to feed_name.
        channel (str): The ID of the channel to post in.
        path (str): Base path (except filename) for the helper file that will be created.
    """
    day: str = (datetime.date.today() - datetime.timedelta(days=1)).strftime("%Y-%m-%d")  # Yesterday
    items: list = get_new_figshare_items(day)
    if not items:
        return
    formatted_items: list = gen_twitter_formatting(items)

    start_msg: str = ("Here is the latest #opendata item published in @scilifelab "
                      "Data Repository - a service on  http://data.scilifelab.se")
    payload: dict = gen_feed_payload(start_msg, formatted_items, channel, day)
    post_to_slack(payload)


if __name__ == "__main__":
    path = "".join(sys.argv[1:]) if len(sys.argv) > 1 else ""
    try:
        post_from_figshare(os.environ.get("FIGSHARE_CHANNEL", ""))
    except ValueError as err:
        sys.stderr.write(f"Figshare task failed: {err}")
    else:
        print("Figshare task finished")
