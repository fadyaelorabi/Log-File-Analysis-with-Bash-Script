import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import re
from datetime import datetime

# Read and parse the data
data = []
with open('PatternsinFailureRequests.txt', 'r', encoding='utf-8') as f:
    for line in f:
        match = re.search(r'Failures on (\d{2}/\w{3}/\d{4}):(\d{2}): (\d+)', line)
        if match:
            date_str, hour, count = match.groups()
            dt = datetime.strptime(date_str, "%d/%b/%Y")
            data.append({
                "date": dt.date(),
                "hour": int(hour),
                "failures": int(count)
            })

# Convert to DataFrame
df = pd.DataFrame(data)

# Pivot for heatmap (rows = date, cols = hour)
heatmap_data = df.pivot(index="date", columns="hour", values="failures").fillna(0)

# Plot the heatmap
plt.figure(figsize=(16, 8))
sns.heatmap(heatmap_data, cmap="Reds", linewidths=0.5, annot=True, fmt=".0f")
plt.title("🔥 Failure Requests Heatmap (Hourly per Day)")
plt.xlabel("Hour of Day")
plt.ylabel("Date")
plt.tight_layout()
plt.show()
