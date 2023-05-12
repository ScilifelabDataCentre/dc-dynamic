import csv
import json

import pandas
import requests

# data
req = requests.get("https://blobserver.dc.scilifelab.se/blob/CSSS_estimates.csv")
reader = csv.reader(req.text.splitlines())
data = list(reader)[-21:]
df1 = pandas.DataFrame(
    data[0:], columns=["Lan", "Datum", "Uppskattning", "Low_CI", "High_CI"]
)

# format data
df1["Datum"] = pandas.to_datetime(df1["Datum"])
df1.sort_values(by="Datum", ascending=False, inplace=True)
df1.drop_duplicates("Lan", keep="first", inplace=True)
df1["Uppskattning"] = pandas.to_numeric(df1["Uppskattning"], errors="coerce")
df1["Uppskattning"] = df1["Uppskattning"].fillna(-0.1)

outdata = {}

outdata["z"] = list(df1["Uppskattning"])
outdata["custom"] = [[val] for val in outdata["z"]]
outdata["Lan"] = list(df1["Lan"])

print(json.dumps(outdata))
