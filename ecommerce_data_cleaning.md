First, I made some basic changes to the data:
- customer_id: remove null values 
- country: remove null and 'Unspecified' values 
- quantity: remove negative values
- stock_code: remove values that cannot be associated with a product description
- description: remove extra blank spaces, and capitalise all letters
I created a temporary table with these changes to continue cleaning.

Second, because each stock_code was having multiple variations of product description, I matched each code with only 1 standardised description for each product:
- Step 1: I created a list of stock_code that have more than 1 description
- Step 2: For each stock_code in the list created, I assigned each variation of description with a unique number
- Step 3: I transformed all description of one stock_code into the description assigned with number 1
I created the second temp table with these changes to continue cleaning.

Third, I looked at the standardised description in alphabetical order and updated the temp table several times to correct the typos spotted such as extra blank space and misspelled words.

Fourth, I removed duplicated records in the table:
- Step 1: I identify the duplicated records by using the row_number window function partition by all fields in the table, so all identical records would be labeled from 1, meaning duplicated records would have row number > 1
- Step 2: I selected all the duplicated records then union with the original table so that all identical record in both table are eliminated.
- Step 3: I double-check the result by running the queries above

After cleaning, I create a new table of clean data in the database.