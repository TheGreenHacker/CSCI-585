# CSCI 585 HW1
NAME: Jack Li
ID: 1321-1056-14

## Entities

### PATIENT
The PATIENT entity contains basic information about patients like personal details as needed by the dental business.  The attributes INS_PROVIDER_NAME and INS_SUBSCRIBER_ID are optional since not all patients have insurance. Combined (since different providers may issue same subscriber id's for different patients but assume each provider has a unique name), they form a foreign key to index into the INSURANCE PROVIDER if that particular patient does have insurance. The PAT_ADDRESS is also optional since the front desk will contact patients by phone for scheduling appointments. 

### INSURANCE PROVIDER
Each row in The INSURANCE PROVIDER table represents a patient's insurance information for a particular provider. Assume all insurance providers have a distinct name. Another attribute INS_SUBSCRIBER_ID (foreign key in PATIENT table) is needed since an insurance provider will most likely serve multiple patients so their subscriber id is needed to distinguish each record from another. 

### PROCEDURE
The PROCEDURE entity represents a procedure that a patient undergoes during an appointment (medical record). It's an umbrella abstraction that also encompasses treatments and surgeries. PROC_NAME is for easy reference of what the procedure is and PROC_COST is the cost for that procedure. 

### APPOINTMENT
APPOINTMENT is a bridge entity to bridge the M:N relationships between PATIENT and PROCEDURE,  PATIENT and MEDICAL PROFESSIONAL, and MEDICAL PROFESSIONAL and PROCEDURE. It contains logistical and payment information about appointments. Thus, it's composite primary key consists of PAT_ID, PROC_CODE, DATE, and TIME. This is because different patients may be scheduled for the same procedure on a given day and patients can have the same procedure done multiple times over a given time period. However, it's safe to assume a patient won't have the same procedure multiple times in a day so those 3 attributes are enough to uniquely identify an appointment record. I decided not to include ROOM or EMP_ID as part of the primary key since that would result in partial dependencies as the 3 attributes related to payment (AMT_OWED, AMT_PAID_BY_INSURANCE, and AMT_PAID_BY_PATIENT) should only depend on PAT_ID, PROC_CODE, DATE, and TIME; the doctor that performed the procedure or the room in which the procedure took place do not determine how much is charged for a particular patient's procedure on a given day. All non-key attributes are required even AMT_PAID_BY_INSURANCE (better to have default 0 value than null so when calculating costs, there's no need to watch out for patients without insurance. EMP_ID is the employee id of the doctor that performs the procedure for an appointment. Assume exactly one doctor per appointment. 

### EMPLOYEE
EMPLOYEE is a supertype entity that contains attributes common to all employees like salary. The EMP_TYPE attribute is the subtype discriminator. It is disjoint since an employee cannot be both an office worker and a medical professional. Total completeness is required since each employee must be an office worker or medical professional (assume exterior cleaning services are hired for janitorial duties whose costs are included in EXPENSE table and thus not considered an employee). 

### OFFICE WORKER
OFFICE WORKER is a subtype entity of EMPLOYEE. Its OFF_ROLE attribute indicates what specific role each office worker (e.g. secretary, schedule coordinator, etc).

### MEDICAL PROFESSIONAL
MEDICAL PROFESSIONAL is another subtype entity of EMPLOYEE. All medical professionals like dentists and orthodontists have license numbers and professional titles as well as license expiration date.

### EXPENSE
The EXPENSE entity tracks all expenses (excluding salaries which can be found in EMPLOYEE table), both startup and recurring costs. The primary key includes the month and year for which that expense occurs in order to differentiate between recurring expenses (e.g. rent, supplies, utilities, etc) and for the owners to be able to assess net profit/loss over varying periods of time. This is also flexible to account for changes in prices for the same expenditure in different months. An optional attribute called EXP_DUE_DAY is needed since some expenses have a schedule (like rent for the leased medical building and potentially monthly loan payments). 

Final notes about entities: For assessing total profit, the owners can go through the APPOINTMENT table and sum up all the costs from the payment info in APPOINTMENT (or index into the PROCEDURE TIME to get the total cost for each procedure). To bill insurance providers, information from the INSURANCE PROVIDER table and APPOINTMENT table are needed. This can be retrieved using the necessary foreign key in APPOINTMENT to index into PATIENT table and then into the INSURANCE PROVIDER table to get that patient's specific plan information. 

For accessing loss, values would have to be retrieved from the EXPENSE and EMPLOYEE (for salaries) tables to obtain the total costs for that month. The monthly loan payments can be calculated beforehand from relevant background information and stored in the EXPENSE table. I chose not to create a LOAN entity since it would require storing redundant information like principle amount, interest rate, and penalty fee for each monthly payment installment. It's logical to assume that for most loans, those values are constant and provided beforehand so there's no need to store them in the database. If the owners do decide to store each monthly loan payment in the EXPENSE table, if they choose to take up more loans from different banks, they can differentiate between multiple loan payments for a month by including the name of the bank in the EXP_NAME field (or sum up the monthly payments for all loans and store the total value). 

For the front office to contact patients, there is no need to specify any relationship. The appropriate office workers can simply look up patients' contact details in PATIENT table. Also, assume only the owner(s), who do not count as employees, will manage all the expenses so there is no need to specify a relation for that either. 

## Relationships

### 1 (Optional) : M (Mandatory)
* An insurance provider may insure many patients. However, not all patients have insurance and at most, one patient is covered by one insurance company (doesn't make sense to be insured by multiple providers). Since there's no point in keep track of insurance providers who do not insure any patients of this dental business, all the recorded providers must insure at least one patient. This is a weak relationship since primary key of the child entity (PATIENT) does not contain a primary key component of the parent entity (INSURANCE PROVIDER).

### M : N
* A patient may see many doctors. A doctor may see many patients.
* A patient may have many procedures. A procedure may be performed for many patients.
* A doctor may perform many procedures. A procedure may be performed by multiple doctors (different rooms or different times).

These M : N can be broken down into three 1 (Mandatory) : M (Optional) relationships by resolving them into a bridge entity APPOINTMENT as follows:
* A patient may be scheduled for multiple appointments or none (due to being dormant or not having recently visited). However, an appointment must be scheduled for a patient.
* A procedure may be the reason for multiple appointments or none (since some procedures might not have been requested by any patients yet). An appointment must have a procedure as its reason.
* A doctor may be assigned to multiple appointments or none (some doctors might see no patients for the month). An appointment must be assigned to a doctor.

The 1 (Mandatory) : M (Optional) relationships between PATIENT and APPOINTMENT and between PROCEDURE and APPOINTMENT are strong since the child entity's (APPOINTMENT) primary key contains components of the corresponding parent entities' primary key (PATIENT and PROCEDURE). The 1 (Mandatory) : M (Optional) relationship between MEDICAL PROFESSIONAL and APPOINTMENT is weak since the child entity's (APPOINTMENT) primary key does not consist of MEDICAL PROFESSIONAL's primary key. 





