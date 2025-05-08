import pandas as pd
import re
from scipy.stats import zscore
import matplotlib.pyplot as plt
import seaborn as sns

# Step 1: Read and parse the file
file_path = "ip_requests.txt"
data = []

with open(file_path, "r") as file:
    for line in file:
        match = re.match(r"(\d+\.\d+\.\d+\.\d+)\s+GET:\s*(\d+)\s+POST:\s*(\d*)", line.strip())
        if match:
            ip = match.group(1)
            get_value = int(match.group(2))
            post_value = int(match.group(3)) if match.group(3) else 0
            data.append((ip, get_value, post_value))

# Step 2: Create the DataFrame
df = pd.DataFrame(data, columns=["IP", "GET", "POST"])
df["Total"] = df["GET"] + df["POST"]

# Step 3: Calculate Z-score and detect anomalies
df["Z_score"] = zscore(df["Total"])
anomalies = df[df["Z_score"] > 3]  # Threshold can be tuned (e.g., 2.5 or 3)

# Show anomalies
print("Anomalous IPs (Z-score > 3):")
print(anomalies[["IP", "GET", "POST", "Total", "Z_score"]])

# Step 4: Visualize anomalies
plt.figure(figsize=(12, 6))
sns.scatterplot(x=range(len(df)), y=df["Total"], hue=df["Z_score"] > 3, palette={False: "blue", True: "red"})
plt.title("Anomaly Detection: Total Requests per IP")
plt.xlabel("Record Index")
plt.ylabel("Total Requests")
plt.legend(title="Anomaly")
plt.tight_layout()
plt.show()
