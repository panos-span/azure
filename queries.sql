/* Query 1:
Show the total “Amount” of “Type = 0” transactions at “ATM Code = 21” of the last 10 minutes. Repeat as new events
keep flowing in (use a sliding window).*/

SELECT SUM(Amount) AS Total_Amount
FROM [input]
    TIMESTAMP BY EventEnqueuedUtcTime
GROUP BY Type, ATMCode, SlidingWindow(minute, 10)
HAVING Type = 0 AND ATMCode = 21

/* Query 2:
Show the total “Amount” of “Type = 1” transactions at “ATM Code = 21” of the last hour. Repeat once every hour
  (use a tumbling window).*/

SELECT SUM(Amount) AS Total_Amount
FROM [input]
    TIMESTAMP BY EventEnqueuedUtcTime
GROUP BY Type, ATMCode, TumblingWindow(hour, 1)
HAVING Type = 1 AND ATMCode = 21

/* Query 3:
 Show the total “Amount” of “Type = 1” transactions at “ATM Code = 21” of the last hour. Repeat once every 30 minutes (use a hopping window).
 */

SELECT SUM(Amount) AS Total_Amount
FROM [input]
    TIMESTAMP BY EventEnqueuedUtcTime
GROUP BY Type, ATMCode, HoppingWindow(minute, 30, 1)
HAVING Type = 1 AND ATMCode = 21

/* Query 4:
Show the total “Amount” of “Type = 1” transactions per “ATM Code” of the last
one hour (use a sliding window). */

SELECT SUM(Amount) AS Total_Amount
FROM [input]
    TIMESTAMP BY EventEnqueuedUtcTime
WHERE Type = 1
GROUP BY ATMCode, SlidingWindow(hour, 1)

/* Query 5:
Show the total “Amount” of “Type = 1” transactions per “Area Code” of the last hour.
Repeat once every hour (use a tumbling window). */

/* Area Code is in the customerref table */

SELECT [customerref].area_code, SUM ([input].Amount) AS Total_Amount
FROM [input]
    TIMESTAMP BY EventEnqueuedUtcTime
    LEFT JOIN [customerref]
ON [customerref].card_number = [input].CardNumber
GROUP BY [input].[Type], [customerref].area_code, TumblingWindow(hour, 1)
HAVING [input].[Type] = 1

/* Area Code is in the atmref table */

SELECT [atmref].area_code, SUM ([input].Amount) AS Total_Amount
FROM [input]
    TIMESTAMP BY EventEnqueuedUtcTime
    LEFT JOIN [atmref]
ON [input].[ATMCode]=[atmref].[atm_code]
GROUP BY [input].[Type], [atmref].[area_code], TumblingWindow(hour, 1)
HAVING [input].[Type] = 1

/* Query 6:
Show the total “Amount” per ATM’s “City” and Customer’s “Gender” of the last hour.
Repeat once every hour (use a tumbling window). */

SELECT SUM([input].Amount) AS Total_Amount, [arearef].area_city, [customerref].gender
FROM [input]
    TIMESTAMP BY EventEnqueuedUtcTime
    LEFT JOIN [customerref]
ON [customerref].card_number = [input].CardNumber
    LEFT JOIN [arearef]
    ON [arearef].area_code = [customerref].area_code
GROUP BY [arearef].area_city, [customerref].gender, TumblingWindow(hour, 1)


/* Query 7:
Alert (SELECT “1”) if a Customer has performed two transactions of “Type = 1”
in a window of an hour (use a sliding window). */

SELECT 1 AS Alert, [customerref].last_name
FROM [input]
    TIMESTAMP BY EventEnqueuedUtcTime
    LEFT JOIN [customerref]
ON [customerref].card_number = [input].CardNumber
WHERE [input].[Type] = 1
GROUP BY [customerref].last_name, SlidingWindow(hour, 1)
HAVING COUNT (*) >= 2

/*
Query 8:
Alert (SELECT “1”) if the “Area Code” of the ATM of the transaction is not the same
as the “Area Code” of the “Card Number” (Customer’s Area Code) - (use a sliding window) */

SELECT 1 AS Alert, [atmref].area_code, [customerref].area_code
FROM [input]
    TIMESTAMP BY EventEnqueuedUtcTime
    LEFT JOIN [customerref]
ON [customerref].card_number = [input].CardNumber
    LEFT JOIN [atmref]
    ON [input].ATMCode = [atmref].atm_code
WHERE [customerref].area_code != [atmref].area_code
GROUP BY [atmref].area_code, [customerref].area_code, SlidingWindow(hour, 1)

/* Potential solution */

SELECT 1 AS Alert, [atmref].area_code AS ATM_AreaCode, [customerref].area_code AS Customer_AreaCode, COUNT (*) AS Count
FROM
    [input] TIMESTAMP BY EventEnqueuedUtcTime
    LEFT JOIN [customerref]
ON [input].CardNumber = [customerref].card_number
    LEFT JOIN [atmref]
    ON [input].ATMCode = [atmref].atm_code
WHERE [customerref].area_code != [atmref].area_code
GROUP BY
    [atmref].area_code,
    [customerref].area_code,
    SlidingWindow(hour, 1)


/* Works without the GROUP BY !!!!!! */