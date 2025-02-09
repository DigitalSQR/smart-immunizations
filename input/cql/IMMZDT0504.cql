/*
 * Library: IMMZDT03 (IMMZ.DT.05.Hib)
 * Rule: if child or person has not been vaccinated, give Hib vaccine between 6 weeks and 59 months 
 * Trigger: Patient has never received Hib vaccination
 */
library IMMZDT0504
// Start Skeleton CQL
using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1'
include IMMZCommon called IMMZCom
include IMMZConcepts called IMMZc
include IMMZConfig called IMMZConf
include IMMZVaccineLibrary called IMMZvl
include IMMZDT05Common called Com
// End Skeleton CQL
context Patient


/*
 * Expressions for the 2 primary dose + 1 booster Schedule
 */
define "Provision of the Hib dose":
	if "First Hib Dose Administered to Patient" is null 
	then Patient.birthDate + 59 months >= Now()
	else "Booster Hib Dose Administered to Patient" is null

define "Schedule Due Date for Hib dose":
	ToDateTime(
		case
		when Com."No Hib Doses Administered to Patient"
			then Patient.birthDate + 6 weeks
		when "Booster Hib Dose Administered to Patient" is not null
			then null
		when "Second Hib Dose Administered to Patient" is not null
			then "Date Second Hib Dose Administered to Patient" + 6 months
		else "Date Last Valid Hib Dose" + 8 weeks
		end
	)

define "Overdue Date for Hib dose":
  null

define "Expiration Date for Hib dose":
	ToDateTime(
		if "First Hib Dose Administered to Patient" is null 
		then Patient.birthDate + 59 months
		else null
	)

define "Hib Next Dose Number":
	case
	when "Second Hib Dose Administered to Patient" is not null then 'booster'
	when "First Hib Dose Administered to Patient" is not null then 2
	else 1
	end

define "Number of Required Hib Doses":
	if "Second Hib Dose Administered to Patient" is not null
	then 'booster'
	else 2

define "Date Last Valid Hib Dose":
	case
		when "Booster Hib Dose Administered to Patient" is not null 
			then "Date Booster Hib Dose Administered to Patient"		
		when "Second Hib Dose Administered to Patient" is not null 
			then "Date Second Hib Dose Administered to Patient"
		when "First Hib Dose Administered to Patient" is not null 
			then "Date First Hib Dose Administered to Patient"
		else null
	end

/**
 * @dataElement "First Hib Dose Administered to Patient"
 */
define "First Hib Dose Administered to Patient":
  Last(Com."Hib Doses Administered to Patient" I 
		where I.occurrence after Patient.birthDate + 6 weeks)

/**
 * @dataElement Date First Hib dose administered
 */
define "Date First Hib Dose Administered to Patient":
  date from ("First Hib Dose Administered to Patient".occurrence as FHIR.dateTime)

/**
 * @dataElement "Second Hib Dose Administered to Patient"
 */
define "Second Hib Dose Administered to Patient":
  Last(Com."Hib Doses Administered to Patient" I 
		where I.occurrence after "Date First Hib Dose Administered to Patient" + 8 weeks)

/**
 * @dataElement Date Second Hib dose administered
 */
define "Date Second Hib Dose Administered to Patient":
  date from ("Second Hib Dose Administered to Patient".occurrence as FHIR.dateTime)

/**
 * @dataElement "Booster Hib Dose Administered to Patient"
 */
define "Booster Hib Dose Administered to Patient":
  Last(Com."Hib Doses Administered to Patient" I 
		where I.occurrence after "Date Third Hib Dose Administered to Patient" + 6 months)

/**
 * @dataElement Date Booster Hib dose administered
 */
define "Date Booster Hib Dose Administered to Patient":
  date from ("Booster Hib Dose Administered to Patient".occurrence as FHIR.dateTime)