# Heroes Of Pymoli Data Analysis

## 3 Observable Trends
* There are more male players than female players 
    * (about 62.36% more)
* Most players are between 15 - 24 years old
    * (players in age range 15-19 and 20-24 together take up about 65.21% of the players)
* Most of bestselling items are in low price range 
    * (4 out of top 5 selling item prices range from $1.49 to $2.35)  


```python
import pandas as pd
pd.options.display.float_format = '$ {:,.2f}'.format

# Reading files and create dataframe
files = ["purchase_data2.json", "purchase_data.json"]
df = pd.concat([pd.read_json(f) for f in files]).reset_index()
```


```python
# Player Count
PlayerCount = len(df["SN"].unique())

# Result
pd.DataFrame({ "Total Players": PlayerCount }, index=[0]) 
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Players</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>612</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Purchasing Analysis (Total)
itemCount = len(df["Item ID"].unique())
averagePrice = df["Price"].mean()
purchaseCount = len(df)
totalRevenue = df["Price"].sum()

purchaseAnalysis = pd.DataFrame({
            "Number of Unique Items": itemCount,
            "Average Price": averagePrice,
            "Number of Purchases": purchaseCount,
            "Total Revenue": totalRevenue
             }, index=[0])

# formatting
purchaseAnalysis = purchaseAnalysis[["Number of Unique Items", "Average Price", "Number of Purchases", "Total Revenue"]]

# Result
purchaseAnalysis
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Number of Unique Items</th>
      <th>Average Price</th>
      <th>Number of Purchases</th>
      <th>Total Revenue</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>184</td>
      <td>$ 2.93</td>
      <td>858</td>
      <td>$ 2,514.43</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Gender Demographics
genderDemographics = df.groupby("Gender")["SN"].nunique().to_frame(name="Total Count")
genderDemographics["Percentage of Players"] = round(genderDemographics["Total Count"] / genderDemographics["Total Count"].sum() * 100, 2) 

# formatting
del genderDemographics.index.name
genderDemographics = genderDemographics.reindex(["Male", "Female", "Other / Non-Disclosed"])
genderDemographics = genderDemographics[["Percentage of Players", "Total Count"]]
genderDemographics["Percentage of Players"] = genderDemographics["Percentage of Players"].map("{:.2f} %".format)

# Result 
genderDemographics
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Percentage of Players</th>
      <th>Total Count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Male</th>
      <td>80.45 %</td>
      <td>498</td>
    </tr>
    <tr>
      <th>Female</th>
      <td>18.09 %</td>
      <td>112</td>
    </tr>
    <tr>
      <th>Other / Non-Disclosed</th>
      <td>1.45 %</td>
      <td>9</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Purchasing Analysis (Gender)
df_gender = df.groupby("Gender") 

PurchaseCount = df_gender.index.count()
AveragePrice = df_gender.Price.mean()
TotalValue = df_gender.Price.sum()
NormTotal = TotalValue / PurchaseCount

# formatting
columns = ["Purchase Count", "Average Price", "Total Purchase Value", "Normalized Totals"]
purchasingAnalysis_gender = pd.concat([PurchaseCount, AveragePrice, TotalValue, NormTotal], axis=1, keys=columns)
purchasingAnalysis_gender = purchasingAnalysis_gender.reindex(["Male", "Female", "Other / Non-Disclosed"])

# Result 
purchasingAnalysis_gender
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Price</th>
      <th>Total Purchase Value</th>
      <th>Normalized Totals</th>
    </tr>
    <tr>
      <th>Gender</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Male</th>
      <td>697</td>
      <td>$ 2.94</td>
      <td>$ 2,052.28</td>
      <td>$ 2.94</td>
    </tr>
    <tr>
      <th>Female</th>
      <td>149</td>
      <td>$ 2.85</td>
      <td>$ 424.29</td>
      <td>$ 2.85</td>
    </tr>
    <tr>
      <th>Other / Non-Disclosed</th>
      <td>12</td>
      <td>$ 3.15</td>
      <td>$ 37.86</td>
      <td>$ 3.15</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Age Demographics
bins = [0, 10, 15, 20, 25, 30, 35, 40, 999]
names = ['<10', '10-14', '15-19', '20-24', '25-29', '30-34', '35-39', '40+']
df["ageCategory"] = pd.cut(df["Age"], bins, labels=names)

df_user = df[["SN", "ageCategory"]].drop_duplicates()
ageDemographics = df_user["ageCategory"].value_counts().to_frame(name="Total Count")

ageDemographics["Percentage of Players"] = round(ageDemographics["Total Count"] / ageDemographics["Total Count"].sum() * 100, 2)

# formatting
ageDemographics = ageDemographics.reindex(names)
ageDemographics = ageDemographics[["Percentage of Players", "Total Count"]]
ageDemographics["Percentage of Players"] = ageDemographics["Percentage of Players"].map("{:.2f} %".format)

# Result 
ageDemographics
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Percentage of Players</th>
      <th>Total Count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>&lt;10</th>
      <td>4.21 %</td>
      <td>27</td>
    </tr>
    <tr>
      <th>10-14</th>
      <td>8.89 %</td>
      <td>57</td>
    </tr>
    <tr>
      <th>15-19</th>
      <td>24.80 %</td>
      <td>159</td>
    </tr>
    <tr>
      <th>20-24</th>
      <td>40.41 %</td>
      <td>259</td>
    </tr>
    <tr>
      <th>25-29</th>
      <td>8.74 %</td>
      <td>56</td>
    </tr>
    <tr>
      <th>30-34</th>
      <td>7.80 %</td>
      <td>50</td>
    </tr>
    <tr>
      <th>35-39</th>
      <td>4.68 %</td>
      <td>30</td>
    </tr>
    <tr>
      <th>40+</th>
      <td>0.47 %</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Purchasing Analysis (Age)
df_age = df.groupby("ageCategory")

PurchaseCount = df_age.index.count()
AveragePrice = df_age.Price.mean()
TotalValue = df_age.Price.sum()
NormTotal = TotalValue / PurchaseCount

columns = ["Purchase Count", "Average Purchase Price", "Total Purchase Value", "Normalized Totals"]
purchasingAnalysis_age = pd.concat([PurchaseCount, AveragePrice, TotalValue, NormTotal], axis=1, keys=columns)

# formatting
del purchasingAnalysis_age.index.name
purchasingAnalysis_age = purchasingAnalysis_age.reindex(names)

# Result
purchasingAnalysis_age
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
      <th>Normalized Totals</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>&lt;10</th>
      <td>37</td>
      <td>$ 2.98</td>
      <td>$ 110.44</td>
      <td>$ 2.98</td>
    </tr>
    <tr>
      <th>10-14</th>
      <td>82</td>
      <td>$ 2.88</td>
      <td>$ 236.36</td>
      <td>$ 2.88</td>
    </tr>
    <tr>
      <th>15-19</th>
      <td>204</td>
      <td>$ 2.86</td>
      <td>$ 583.43</td>
      <td>$ 2.86</td>
    </tr>
    <tr>
      <th>20-24</th>
      <td>338</td>
      <td>$ 2.97</td>
      <td>$ 1,003.03</td>
      <td>$ 2.97</td>
    </tr>
    <tr>
      <th>25-29</th>
      <td>80</td>
      <td>$ 2.88</td>
      <td>$ 230.59</td>
      <td>$ 2.88</td>
    </tr>
    <tr>
      <th>30-34</th>
      <td>65</td>
      <td>$ 3.00</td>
      <td>$ 194.73</td>
      <td>$ 3.00</td>
    </tr>
    <tr>
      <th>35-39</th>
      <td>49</td>
      <td>$ 3.00</td>
      <td>$ 147.21</td>
      <td>$ 3.00</td>
    </tr>
    <tr>
      <th>40+</th>
      <td>3</td>
      <td>$ 2.88</td>
      <td>$ 8.64</td>
      <td>$ 2.88</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Top Spenders
df_SN = df.groupby("SN")

top_five_SN = df_SN["Price"].sum().nlargest(5).to_frame(name="Total Purchase Value").reset_index()
purchase_count = df_SN.index.count().to_frame().rename(columns={"index":"Purchase Count"}).reset_index()

topSpenders = top_five_SN.merge(purchase_count)
topSpenders["Average Purchase Price"] = topSpenders["Total Purchase Value"] / topSpenders["Purchase Count"]

# formatting
topSpenders.set_index("SN", inplace=True)
topSpenders = topSpenders[["Purchase Count", "Average Purchase Price", "Total Purchase Value"]]

# Result
topSpenders
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>SN</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Undirrala66</th>
      <td>5</td>
      <td>$ 3.41</td>
      <td>$ 17.06</td>
    </tr>
    <tr>
      <th>Aerithllora36</th>
      <td>4</td>
      <td>$ 3.78</td>
      <td>$ 15.10</td>
    </tr>
    <tr>
      <th>Saedue76</th>
      <td>4</td>
      <td>$ 3.39</td>
      <td>$ 13.56</td>
    </tr>
    <tr>
      <th>Sondim43</th>
      <td>4</td>
      <td>$ 3.25</td>
      <td>$ 13.02</td>
    </tr>
    <tr>
      <th>Mindimnya67</th>
      <td>4</td>
      <td>$ 3.18</td>
      <td>$ 12.74</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Most Popular Items
df_group_item = df.groupby(["Item ID", "Item Name", "Price"])

most_sold_item = df_group_item.index.count().nlargest(5).to_frame(name="Purchase Count").reset_index()
value_item = df_group_item.Price.sum().to_frame().rename(columns={"Price":"Total Purchase Value"}).reset_index()

popularItems_sold = most_sold_item.merge(value_item)

# formatting
popularItems_sold.set_index(["Item ID", "Item Name"], inplace=True)
popularItems_sold = popularItems_sold[["Purchase Count", "Price", "Total Purchase Value"]].rename(columns={"Price":"Item Price"})

# Result
popularItems_sold
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>Purchase Count</th>
      <th>Item Price</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>Item ID</th>
      <th>Item Name</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>39</th>
      <th>Betrayal, Whisper of Grieving Widows</th>
      <td>11</td>
      <td>$ 2.35</td>
      <td>$ 25.85</td>
    </tr>
    <tr>
      <th>84</th>
      <th>Arcane Gem</th>
      <td>11</td>
      <td>$ 2.23</td>
      <td>$ 24.53</td>
    </tr>
    <tr>
      <th>13</th>
      <th>Serenity</th>
      <td>9</td>
      <td>$ 1.49</td>
      <td>$ 13.41</td>
    </tr>
    <tr>
      <th>31</th>
      <th>Trickster</th>
      <td>9</td>
      <td>$ 2.07</td>
      <td>$ 18.63</td>
    </tr>
    <tr>
      <th>34</th>
      <th>Retribution Axe</th>
      <td>9</td>
      <td>$ 4.14</td>
      <td>$ 37.26</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Most Profitable Items
df_group_item = df.groupby(["Item ID", "Item Name", "Price"])

sold_item = df_group_item.index.count().to_frame().rename(columns={"index":"Purchase Count"}).reset_index()
most_value_item = df_group_item.Price.sum().nlargest(5).to_frame().rename(columns={"Price":"Total Purchase Value"}).reset_index()

popularItems_profit = most_value_item.merge(sold_item)

# formatting 
popularItems_profit.set_index(["Item ID", "Item Name"], inplace=True)
popularItems_profit = popularItems_profit[["Purchase Count", "Price", "Total Purchase Value"]].rename(columns={"Price":"Item Price"})

# Result
popularItems_profit
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>Purchase Count</th>
      <th>Item Price</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>Item ID</th>
      <th>Item Name</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>34</th>
      <th>Retribution Axe</th>
      <td>9</td>
      <td>$ 4.14</td>
      <td>$ 37.26</td>
    </tr>
    <tr>
      <th>115</th>
      <th>Spectral Diamond Doomblade</th>
      <td>7</td>
      <td>$ 4.25</td>
      <td>$ 29.75</td>
    </tr>
    <tr>
      <th>32</th>
      <th>Orenmir</th>
      <td>6</td>
      <td>$ 4.95</td>
      <td>$ 29.70</td>
    </tr>
    <tr>
      <th>103</th>
      <th>Singed Scalpel</th>
      <td>6</td>
      <td>$ 4.87</td>
      <td>$ 29.22</td>
    </tr>
    <tr>
      <th>107</th>
      <th>Splitter, Foe Of Subtlety</th>
      <td>8</td>
      <td>$ 3.61</td>
      <td>$ 28.88</td>
    </tr>
  </tbody>
</table>
</div>


