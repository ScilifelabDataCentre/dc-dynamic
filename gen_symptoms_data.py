import csv
import json

import pandas
import requests

# data
req = requests.get("https://urls.dckube.scilifelab.se/goto/csss/")
reader = csv.reader(req.text.splitlines())
data = list(reader)[-21:]
df1 = pandas.DataFrame(
    data[0:], columns=["Lan", "Datum", "Uppskattning", "Low_CI", "High_CI"]
)

REQ_ORDER = [
    "Sk\u00e5ne",
    "G\u00e4vleborg",
    "Gotland",
    "V\u00e4rmland",
    "V\u00e4sterbotten",
    "V\u00e4stmanland",
    "Norrbotten",
    "S\u00f6dermanland",
    "J\u00e4mtland",
    "Kalmar",
    "\u00d6sterg\u00f6tland",
    "Dalarna",
    "\u00d6rebro",
    "V\u00e4stra G\u00f6taland",
    "Blekinge",
    "Halland",
    "Uppsala",
    "V\u00e4sternorrland",
    "J\u00f6nk\u00f6ping",
    "Stockholm",
    "Kronoberg",
]

# format data
df1["Datum"] = pandas.to_datetime(df1["Datum"])
df1.sort_values(by="Datum", ascending=False, inplace=True)
df1.drop_duplicates("Lan", keep="first", inplace=True)
df1["Uppskattning"] = pandas.to_numeric(df1["Uppskattning"], errors="coerce")
df1["Uppskattning"] = df1["Uppskattning"].fillna(-0.1)

outdata = {}

outdata["z"] = list(df1["Uppskattning"])
outdata["custom"] = [[val] for val in outdata["z"]]

print(json.dumps(outdata))
