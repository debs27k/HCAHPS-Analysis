use project;
-- 1(Total Surveys = 22,804,072)
SELECT SUM(completedsurvey)AS Surveys
FROM responses;

-- 2(Number of Hospital Facilities = 36,703)
SELECT COUNT(facilityid) Facilities
FROM responses;

-- 3(Average responserate = 26, Minimum Responserate =3, Max Responsonserate= 100
SELECT ROUND(AVG(responserate),0) AS average_response_rate, MIN(responserate) AS minimum_response_rate, MAX(responserate) AS maximum_response_rate
FROM responses; 
-- "Average response rate is 26, Minimum Response Rate is 3 Maximum Response Rate is 100"

SELECT releaseperiod, 
MAX(bottomboxpercentage), 
MAX(middleboxpercentage)  , 
MAX(topboxpercentage)
FROM national_results AS n
JOIN measures AS m
ON m.measureid = n.measureid;
-- 4 Max_top_box_percentage = 87, Max_middle_box_percentage = 43, max_bottom_box percentage = 20


SELECT measure
FROM measures
GROUP BY measure;

-- 5(all through the years, "communication with doctors" recorded the highest topboxpercentage which later reduced by 3% in 2023)
SELECT releaseperiod, measure, bottomboxpercentage, middleboxpercentage  , topboxpercentage
FROM national_results AS n
JOIN measures AS m
ON m.measureid = n.measureid
WHERE measure IN ("communication with Doctors");

-- 6(Top box percentage was 79% in 2015 and increased from 2016 - 2022 and then returned back to 79 in 2023.) 
SELECT releaseperiod, measure, bottomboxpercentage, middleboxpercentage  , topboxpercentage
FROM national_results as n
JOIN measures as m
ON m.measureid = n.measureid
WHERE measure IN ("communication with Nurses");

-- 7 (There was an increase in the top box percentage from 2015 to 2021 and it decreased by 3% till 2023)
SELECT releaseperiod, measure, bottomboxpercentage, middleboxpercentage  , topboxpercentage
FROM national_results AS n
JOIN measures AS m
ON m.measureid = n.measureid
WHERE measure IN ("Responsiveness of Hospital Staff");

-- 8 (There was an increase in the top box percentage till 2021 and it decreased by 3% in 2022 and in 2023, it decreased by 2%)
SELECT releaseperiod, measure, bottomboxpercentage, middleboxpercentage  , topboxpercentage
FROM national_results AS n
JOIN measures AS m
ON m.measureid = n.measureid
WHERE measure IN ("Communication about Medicines");

-- 9 (There was an increase in the top box till 2021 and there was a decrease by 1% in 2022 and 2023) 
SELECT releaseperiod, measure, bottomboxpercentage, middleboxpercentage  , topboxpercentage
FROM national_results AS n
JOIN measures AS m
ON m.measureid = n.measureid
WHERE measure IN (SELECT measure FROM measures where measure = ("Discharge Information"));

-- 10 (there was an increase in the topbox percentage from 2015 - 2021 and there was a decrese by 2% till 2023)
SELECT releaseperiod, measure, bottomboxpercentage, middleboxpercentage  , topboxpercentage
FROM national_results AS n
JOIN measures AS m
ON m.measureid = n.measureid
WHERE measure IN ("Care Transition");

-- 11 (the topbox% in increased till 2021 and decreased by 3% till 2023)
SELECT releaseperiod, measure, bottomboxpercentage, middleboxpercentage  , topboxpercentage
FROM national_results AS n
JOIN measures AS m
ON m.measureid = n.measureid
WHERE measure IN ("Cleanliness of Hospital Environment");

-- 12 ( The topbox% flunctuated by 1% all through the years)
SELECT releaseperiod, measure, bottomboxpercentage, middleboxpercentage  , topboxpercentage
FROM national_results AS n
JOIN measures AS m
ON m.measureid = n.measureid
WHERE measure IN ("Quietness of Hospital Environment");

-- 13 (there was an increase in the top box% till 2022 when it dropped by 1%)
SELECT releaseperiod, measure, bottomboxpercentage, middleboxpercentage  , topboxpercentage
FROM national_results AS n
JOIN measures AS m
on m.measureid = n.measureid
WHERE measure IN ("Overall Hospital Rating");



-- (wildcards)
SELECT measureid, measure
FROM measures
WHERE measure LIKE "care%";

-- 14("Discharge Information" measure stood out in the best performing measures with(86.7%).  According the Average top box percentage.)
SELECT m.Measure, 
q.question, 
ROUND(AVG(bottomboxpercentage),1) AS averagebottomboxpercentage, 
ROUND(AVG(middleboxpercentage),1) AS averagemiddleboxpercentage, 
ROUND(AVG(topboxpercentage),1) AS averagetopboxpercentage
FROM national_results n
JOIN questions q ON q.measureid = n.measureid
JOIN measures m ON m.measureid = n.measureid
GROUP BY m.measure, q.question
order by averagetopboxpercentage desc
limit 2;

-- 15 SELECT state, count(completedsurvey) as 300andmore-- , count(completedsurvey) as btw2100and299
--     FROM responses
-- WHERE completedsurvey IN ( SELECT count(completedsurvey) FROM responses WHERE completedsurvey = "300and more" and completedsurvey = "Between 100 and 299")
-- group by state;

-- 16
SELECT state, 
    SUM(CASE WHEN completedsurvey = '300 or more' THEN 1 ELSE 0 END) AS "300andmore",
    SUM(CASE WHEN completedsurvey = 'Between 100 and 299' THEN 1 ELSE 0 END) AS "btw100and299"
    -- SUM(CASE WHEN completedsurvey = 'Fewer than 100' THEN 1 ELSE 0 END) AS "fewerthan100"
FROM responses
GROUP BY state;
    -- ORDER BY 300andmore, Btw100and299 desc

-- 17(All through the years, Kansas had the highest response rate in 2023 @ 100)
SELECT releaseperiod, facilityid, responserate,  (SELECT s.statename) AS state,
RANK() OVER(PARTITION BY releaseperiod ORDER BY responserate DESC) AS top5
FROM responses r
JOIN  states s ON r.state = s.state
ORDER BY responserate DESC
LIMIT 5;

-- 18(The state with the Maimum top box percentage is Alaska in the Pacific Region @ 91%) 
SELECT measureid, 
s.state, 
s.statename, 
s.region, 
MAX(topboxpercentage), 
MAX(middleboxpercentage), 
MAX(bottomboxpercentage)
FROM state_results r
JOIN states s ON r.state=s.state; 

-- 19(The measeure with the avgerage top box% is "Cleanliness of the environment" @ 71.4%)
SELECT releaseperiod, m.measureid, m.measure, ROUND(AVG(topboxpercentage),1)
FROM national_results n
JOIN measures m ON n.measureid = m.measureid;

-- 20
SELECT releaseperiod, startdate, LAG(startdate) OVER(ORDER BY startdate) AS rownum
FROM reports r; 



