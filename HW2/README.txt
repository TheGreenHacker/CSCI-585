# CSCI 585 HW2
NAME: Jack Li
ID: 1321-1056-14

## Q1
Script link: https://livesql.oracle.com/apex/livesql/s/lfginizw8xy97fh3h8vn8sgfi

Assumptions: Procedure costs are positive. Procedure codes are standard. The start and end times of each appointment belong to the same day (so no appointments start super late at night at 11:30 PM and end at 12:30 AM the next day for example). The end time of each appointment is later than the start time. Also, assume that the dental office operates at reasonable hours during the day (e.g. 9 AM to 6 PM) and thus there won't be appointments that are scheduled at super early or super late hours of the day. Each type of procedure has a fixed cost (e.g. all teeth cleanings cost the same) but the length of the same procedure may vary. All appointments are free of scheduling conflicts (same doctor can't see multiple patients in the same time period on a particular day, one doctor per room at a time, etc). The cost of each procedure is the sum of amount owed, amount paid by patient, and amount paid by insurance.

Input: The APPOINTMENT table contains 5 appointments, 4 of which occur in January 2021 and 1 occurs in February 2021.   The 4 January appointments contain 2 Periodic Oral Evaluation procedures (code D0120) and 2 Bite Wing procedures (code D0272). Their costs can be found in the PROC table. Each Periodic Oral Evaluation costs 140.00. Each Bite Wing costs 170.00. The time range of interest is the entire month of January 2021 (the 1st to 31st). By taking the difference between the start and end times in minutes, the lengths of the 4 January appointments in minutes are 56, 138, 55, and 142. 

Expected Outputs: The expected average procedure cost for the month of January 2021 is (2 * 140.00 + 2 * 170.00) / 4 = 155. The expected average procedure time (in minutes) is (56 + 138 + 55 + 142) / 4 = 97.75. 

## Q2
Script link: https://livesql.oracle.com/apex/livesql/s/lfjzmwzgeq3609chcz60n26kx

Assumptions: Same as Q1 since the same tables are used. But the data is slightly different.

Input: The APPOINTMENT table contains 5 appointments, 3 of which occur on January 9th, 2021 and the other 2 occur on different dates. The 3 January 9th, 2021 appointments include 2 Periodic Oral Evaluation procedures (code D0120) and 1 Root Planning 1-3 Teeth (code D4342). Their costs can be found in the PROC table. Each Periodic Oral Evaluation costs 140.00. Each 1 Root Planning 1-3 Teeth (code D4342) costs 500.00. The date of interest is January 9th, 2021.

Expected Output: The expected income (which is the sum of all procedures that day) for January 9th, 2021 is 2 * 140.00 + 500.00 = 780. 

## Q3
Script link: https://livesql.oracle.com/apex/livesql/s/lf1joz62qjzo4nttq6gfz5cfk

Assumptions: All employee id's are positive and all skills are uniquely identified by their descriptions and are non-empty. There are no extra skills in the CAPABILITY table so whatever skills it contains must exist in the master table, SKILL, of skills. All skill descriptions are case-insensitive (e.g. "TAKE OUT TRASK" is the same as "Take out trash").

Input: The CAPABILITY table is a bridge entity between the EMPLOYEE and SKILL tables. It contains a list of employees and their respective skills. The SKILL tables is the given table that contains every possible task. It contains 4 tasks: "File taxes", "Meet the press", "Organize spring cleaning", and "Reorder inventory". There are 4 employees. Employee with ID of 1 can do 2 of them, employee with ID of 2 can do 3 of them, and employees with ID of 3 and 4 can do all 4 of them.

Expected Output: A table containing IDs of 3 and 4 and the description of all the required tasks. There are 4 rows each for IDs of 3 and 4 (in total 8 rows) alongside the description of the 4 tasks mentioned above with each ID. Essentially, it's a subset of the CAPABILITY table minus the rows containing data for employee with ID's 1 and 2. 

## Q4
Script link: https://livesql.oracle.com/apex/livesql/s/lf11i94ub2gx1skpk7bnkgqmp

Query: As mentioned in HW1, the owners need to bill insurance providers for patients with insurance.  This requires the patient's subscriber id, the insurance provider name, type of procedure as indicated by the procedure code, the date of the procedure, the total amount requested, and the amount paid by the insurance company. My query finds this information for a given day. My SQL code does this by joining the APPOINTMENT table with the PROC and PATIENT tables on their respective foreign keys (proc_code and pat_id), respectively, to retrieve the patient's subscriber id and insurance provider name and procedure's cost from those tables. It filters each appointment by a given date (January 9th 2021 in this case) by extracting the date from the start time (which contains both date and time attributes as it's of DATETIME type) and determines if a patient has insurance by checking to see if the patient's subscriber id is not null. The necessary tables are PATIENT, PROC, and APPOINTMENT.

Assumptions: In addition to the assumptions from Q1, for the PATIENT table, assume that subscriber id and insurance provider name are either both not null for patients with insurance or both null for patients without insurance. In other words, it's impossible for the subscriber id to be not null and insurance provider name to be null and vice versa. Also assume that the amount paid by insurance is always 0 for patients without insurance, otherwise, it is non-zero. 

Input: In the APPOINTMENT table, there are 5 rows of data, 3 of which whose dates are January 9th 2021, the particular day of interest for the query. Out of those 3 appointments, only the two with patient id's 1 and 3 have insurance.

Expected output: The query should return a table with two rows containing the subscriber id, insurance provider name, procedure code, appointment date, procedure cost, and amount paid by insurance for patients with id 1 and 3. Both patients have United Healthcare as their provider and appointment dates of January 9th 2021 in accordance with the desired query date. Patient id 1 corresponds to insurance provider id D567238ef679, procedure code D0120, procedure cost (aka total amount for that appointment) of 140, and amount paid by insurance of 70. Patient id 3 corresponds to insurance provider id D8egft74890w, procedure code D4342, procedure cost of 500, and amount paid by insurance of 300. 

NOTE: The table is a little cut off in the Script Results window that pops up after running the script so the amt_paid_by_insurance won't show but check the output already in the link or click 'Download CSV'. Rest assured the desired output is returned.