-- Keep a log of any SQL queries you execute as you solve the mystery.
-- To understand structure of the table
.tables
-- To understand crime_scene_report table
crime_scene_reports
/* To find out description of the crimes tookplace on JULY 28 at Humphy Street
SELECT description FROM crime_scene_reports WHERE street = 'Humphrey Street' AND month = 7 AND day = 28;
Theft of the CS50 duck took place at 10:15am at the
Humphrey Street bakery. Interviews were conducted
today with three witnesses who were present at the
time – each of their interview transcripts mentions
the bakery. Littering took place at 16:36.
No known witnesses.*/
-- To understand interviews table
.schema interviews
-- To understand bakery_security_logs
.schema bakery_security_logs
-- To find out transcript of the interviewers
SELECT transcript FROM interviews WHERE transcript LIKE %bakery% AND month = 7 AND day = 28;
--interviews transcript-1
/*Sometime within ten minutes of the theft,
I saw the thief get into a car in the bakery parking
lot and drive away.If you have security footage from
the bakery parking lot, you might want to look for
cars that left the parking lot in that time frame.
*/
--interviews transcript-2
/*
I don't know the thief's name, but it was someone I
recognized. Earlier this morning, before I arrived
at Emma's bakery, I was walking by the ATM on Leggett
Street and saw the thief there withdrawing some money.
*/

--interviews transcript-3
/*
As the thief was leaving the bakery, they called someone
who talked to them for less than a minute. In the call,
I heard the thief say that they were planning to take
the earliest flight out of Fiftyville tomorrow.
The thief then asked the person on the other end of
the phone to purchase the flight ticket.
*/
-- Licence plate number within of car between 10:15
-- to 10:25 in bakery parking lot Which is
-- 13FNH73
SELECT license_plate FROM bakery_security_logs WHERE day = 28 AND month = 7 AND year = 2021 AND hour = 10 AND minute >= 10 AND minute <= 15;

SELECT name FROM people WHERE license_plate = (SELECT license_plate FROM bakery_security_logs WHERE day = 28 AND month = 7 AND year = 2021 AND hour = 10 AND minute >= 10 AND minute <= 15;)
-- name = Sophia (cars owner name)

-- To find the one who withdraws money from the ATM

SELECT name FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number WHERE atm_transactions.month = 7 AND atm_transactions.year = 2021 AND day = 28 AND atm_location = 'Leggett street';

-- find account numbers of transactions at Legget Street on july 28 2021
SELECT account_number FROM atm_transactions WHERE atm_location = 'Leggett Street' AND day = 28 AND month = 7 AND year = 2021;

-- To find people who used legget street atm on that day
SELECT name FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id WHERE account_number IN (SELECT account_number FROM atm_transactions WHERE atm_location = 'Leggett Street' AND day = 28 AND month = 7 AND year = 2021);
/*
name
Bruce
Kaelyn
Diana
Brooke
Kenny
Iman
Luca
Taylor
Benista
*/

SELECT caller,receiver FROM phone_calls WHERE day = 28 AND month = 7 AND year = 2021 AND duration <= 60;
SELECT name FROM people WHERE phone_number IN (SELECT caller FROM phone_calls WHERE day = 28 AND month = 7 AND year = 2021 AND duration <= 60);

--SELECT name,name FROM people JOIN phone_calls ON phone_calls.caller = people.phone_number phone_calls.receiver = people.phone_number WHERE day = 28 AND month = 7 AND year = 2021 AND duration <= 60;

--Callers
/*
name
Kenny
Sofia
Benista
Taylor
Diana
Kelsey
Kathryn
Bruce
Carina
  */

  -- Receivers
  /*
name
James
Larry
Luca
Anna
Jack
Melissa
Jacqueline
Philip
Robin
Doris
*/


SELECT city FROM airports WHERE id IN(SELECT destination_airport_id FROM flights WHERE origin_airport_id = (SELECT id FROM airports WHERE city = 'Fiftyville') AND day = 29 AND month = 7 AND year = 2021  AND hour = (SELECT MIN(hour) FROM flights WHERE origin_airport_id = (SELECT id FROM airports WHERE city = 'Fiftyville')AND day = 29 AND month = 7 AND year = 2021));

/*city
New York City
*/

SELECT name FROM people WHERE passport_number IN (SELECT passport_number FROM passengers WHERE flight_id = (SELECT id FROM flights WHERE day = 29 AND month = 7 AND year = 2021 AND origin_airport_id = (SELECT id FROM airports WHERE city = 'Fiftyville') AND destination_airport_id = (SELECT id FROM airports WHERE city = 'New York City')));
/*
name
Kenny
Sofia
Taylor
Luca
Kelsey
Edward
Bruce
Doris
*/



SELECT name FROM people WHERE phone_number IN (SELECT receiver FROM phone_calls WHERE day = 28 AND month = 7 AND year = 2021 AND duration <= 60 AND caller = (SELECT phone_number FROM people WHERE license_plate = '13FNH73'));

 -- Bruce is thief because he is present in all 4 lists- List of passengers, list of people who did the specific atm transactions, list of callers, and list of people who drove away in cars from the bakery
  -- Robin is accompliance since Bruce called robins they are corresponding receiver and callers list
  -- the city is newyork city