### :bar_chart: Distribution of quantity purchased
Because there were some extreme values in the *quantity* field, I wanted to know how it was distributed for each product by calculating the sample size, mean, median and standard deviation of the quantity purchased of each product. 

Unsurprisingly, most products' quantity had high standard deviation and large differences between the mean and the median.

### :moneybag: Discount
There was a range of *unit price* for one product, indicating that some invoices received discounts. I calculated the discount percentage that each invoice received based on the original unit price. 

Next, I examined the effectiveness of the discounts by calculating the correlation between the *unit price* and the *quantity* purchased of each product. 
The results showed that each product had a different level of price-quantity correlation. 

I also compared this correlation level with the original price of each product to see if more expensive products would have a stronger negative correlation of price-quantity. The result disproved this assumption.

### :christmas_tree: Xmas sales
I used SQL to transform and model data into appropriate tables to import them into Tableau to generate insights. Most of the insights for Christmas were presented in directory 05. 
*Important notes: The popularity of regular products in the Christmas season was based on a surge in orders or customers from September to November. 
Result based on this notion would exclude products which were popular in every month, and might also be affected by the time the product was stocked.
The final list of popular regular products was determined based on the number of orders and did exclude some products not meeting the above criteria after visualising.*

Besides insights presented in the dashboard, I also did a simple product association (or basket analysis) to discover which pair of Christmas-themed products are usually bought together.
