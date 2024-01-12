## This is the assigment on data streams for the Big Data Management Systems course. 
We are going to use Azure Stream Analytics to process a data stream of ATM transactions and answer stream queries. 
The schema of the stream is: (ATMCode, CardNumber, Type, Amount)

Create a trial account at: https://azure.microsoft.com/en-us/
Setup an Event Hub.
Generate a Security Access Signature: https://github.com/sandrinodimattia/RedDog/releases
Edit Generator.html (open with notepad) and update the CONFIG variables with your security access signature.
Feed the Event Hub with the use of Generator.html (Open Generator.html in a web browser and press the “Send Data” button.)
Setup a Storage account.
Upload the Reference Data files to your storage account (the How-To presentation will be updated to include reference data material.)
Setup a Stream Analytics Job.
Use the Event Hub + Reference Data Files as Input.
Create a Blob Storage Output.
Run the following queries:

- **Query 1**:
  Show the total “Amount” of “Type = 0” transactions at “ATM Code = 21” of the last 10 minutes. Repeat as new events
  keep flowing in (use a sliding window).
- **Query 2**:
  Show the total “Amount” of “Type = 1” transactions at “ATM Code = 21” of the last hour. Repeat once every hour
  (use a tumbling window).
- **Query 3**:
  Show the total “Amount” of “Type = 1” transactions at “ATM Code = 21” of the last hour. Repeat once every 30 minutes
  (use a hopping window).
- **Query 4**:
  Show the total “Amount” of “Type = 1” transactions per “ATM Code” of the last one hour (use a sliding window).
- **Query 5**:
  Show the total “Amount” of “Type = 1” transactions per “Area Code” of the last hour. Repeat once every hour (use a
  tumbling window).
- **Query 6**:
  Show the total “Amount” per ATM’s “City” and Customer’s “Gender” of the last hour. Repeat once every hour (use a
  tumbling window).
- **Query 7**:
  Alert (SELECT “1”) if a Customer has performed two transactions of “Type = 1” in a window of an hour (use a sliding
  window).
- **Query 8**:
  Alert (SELECT “1”) if the “Area Code” of the ATM of the transaction is not the same as the “Area Code” of the “Card
  Number” (Customer’s Area Code) - (use a sliding window)
