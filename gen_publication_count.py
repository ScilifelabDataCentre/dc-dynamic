import json

import pandas
import requests

# get data
res = requests.get("https://publications-covid19.scilifelab.se/publications.json")
txt = res.json()
df = pandas.json_normalize(txt["publications"])
df = df[["type", "published"]]

# for now, assume dates with day as 00 are 1st day
df.replace("-00", "-01", regex=True, inplace=True)

# make the cumulative sum of papers published
df.published = pandas.to_datetime(df["published"], format="%Y-%m-%d").dt.date
currdate = pandas.to_datetime("today").date()
df = df[df["published"] < currdate]
df.sort_values(by="published", inplace=True)
df1 = df["published"].value_counts().sort_index().reset_index()
df1["cumulativecount"] = df1["published"].cumsum()

# find number of papers published in each month
df["year"] = pandas.DatetimeIndex(df["published"]).year
df["month"] = pandas.DatetimeIndex(df["published"]).month
df["index"] = pandas.to_datetime(df[["year", "month"]].assign(day=1))
df2 = df.groupby(["index"]).size().reset_index(name="Number Added")

outdata = {}
outdata["dates"] = list(str(val) for val in df1["index"])
outdata["cumsums"] = list(df1["cumulativecount"])
outdata["months"] = list(str(val).replace(" ", "T") for val in df2["index"])
outdata["per_month"] = list(df2["Number Added"])

print(json.dumps(outdata))
