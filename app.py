import matplotlib.pyplot as plt
import pandas as pd

# Step 1: Read the file
filename = "reqs_by_hour.txt"
data = {}

with open(filename, "r") as f:
    for line in f:
        # Strip any leading or trailing whitespace and split on " : " (with spaces around the colon)
        parts = line.strip().split(" : ")
        if len(parts) == 2:
            time = parts[0].strip()  # "14:00"
            try:
                count = int(parts[1].strip())  # "498" -> convert to integer
                data[time] = count
            except ValueError:
                continue  # Skip lines with invalid numbers

# Step 2: Convert to DataFrame and sort
df = pd.DataFrame(list(data.items()), columns=["Hour", "Requests"])
df = df.sort_values("Hour")

# Print data to check if the parsing is correct
print(data)

# Step 3: Plot
plt.figure(figsize=(12, 6))
plt.bar(df["Hour"], df["Requests"], color="skyblue", edgecolor="black")
plt.xticks(rotation=45)
plt.title("Requests by Hour")
plt.xlabel("Hour of Day")
plt.ylabel("Number of Requests")
plt.grid(axis="y", linestyle="--", alpha=0.7)
plt.tight_layout()
plt.show()
