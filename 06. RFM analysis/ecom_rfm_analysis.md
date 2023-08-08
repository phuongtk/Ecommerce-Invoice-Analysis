## 1. Data modelling
Each distinct customer is ranked on three attributes: 
- Recency = How recent was the customer's last purchase?
- Frequency = How often did this customer make a purchase in a given period?
- Monetary = How much money did the customer spend in a given period?

After ranking, a score from 1 to 5 for each attribute is assigned to customers: the top 20% get 5 and the last 20% get 1. 

==> Each distinct customer now has their own RFM score summarised in a CSV file.

## 2. Data visualisation
I connected Tableau with 2 data sources: the CSV file for RFM score and the cleaned invoice dataset to create the following dashboard:

📎[Link to Tableau dashboard](https://public.tableau.com/views/E-commerceRFMAnalysis/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link)

#### Recency x Frequency chart
Customers are segmented according to their Recency x Frequency score, based on [CleverTap's](https://clevertap.com/blog/rfm-analysis/) approach. The aim of the business is to move customers from the bottom right corner to the top left corner of the chart. This business has a large proportion of hibernating customers, which indicates they might be seasonal customers (= only purchase for special occasions).
#### Monetary value
Combined with the RxF chart, this table can be used to filter whales/heavy spenders or lapsed customers (= once valuable customers but have since stopped) to study their behaviours.
#### Revenue by RFM segment
This bubble chart illustrates which customer segments contribute the most revenues to the business. Besides the two high-performing segments *Champions* and *Loyal Customers*, the *At risk* segment is notable and should be considered for corrective action because they contribute good revenues but are becoming lapsed customers.

## 3. Recommendations
Prioritise darker segments in the RxF chart, particularly:
- Analyse invoice to confirm if the *Hibernating* group consists of seasonal customers
- Compare the behaviours of *Loyal* group and *Hibernating* group to see why one is performing significantly better than the other.
- Offer rewards to maintain long-term relationship with current *Champions* and *Loyalists*
- Regarding *At risks* segment: personalized reactivation campaigns, offer helpful products based on their past purchase
