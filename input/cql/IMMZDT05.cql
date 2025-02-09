/*
 * Library: IMMZDT05 (IMMZ.DT.05.Hib)
 * Rule: if child or person has not been vaccinated, give Hib vaccine between 6 weeks and 59 months 
 * Trigger: Patient has never received Hib vaccination
 */
library IMMZDT05
// Start Skeleton CQL
using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1'
include IMMZCommon called IMMZCom
include IMMZConfig called IMMZConf
include IMMZConcepts called IMMZc
include IMMZVaccineLibrary called IMMZvl
include IMMZDT05Common called Com
include IMMZDT0501 called One
include IMMZDT0502 called Three
include IMMZDT0503 called ThreeOne
include IMMZDT0504 called TwoOne

// End Skeleton CQL
context Patient

define "Provision of the Hib dose":
	case
		when Com."Hib One Dose Schedule" 
			then One."Provision of the Hib dose"
		when Com."Hib Three Primary Dose Schedule"
			then Three."Provision of the Hib dose"
		when Com."Hib Three Primary plus One Booster Schedule"
			then ThreeOne."Provision of the Hib dose"
		when Com."Hib Two Primary plus One Booster Schedule"
			then TwoOne."Provision of the Hib dose"
		else false
	end


define "Schedule Due Date for Hib dose":
	case
		when Com."Hib One Dose Schedule" 
			then One."Schedule Due Date for Hib dose"
		when Com."Hib Three Primary Dose Schedule"
			then Three."Schedule Due Date for Hib dose"
		when Com."Hib Three Primary plus One Booster Schedule"
			then ThreeOne."Schedule Due Date for Hib dose"
		when Com."Hib Two Primary plus One Booster Schedule"
			then TwoOne."Schedule Due Date for Hib dose"
		else null
	end


define "Should vaccinate patient for Hib":
	"Provision of the Hib dose" and ("Schedule Due Date for Hib dose" <= (Now()))


define "Overdue Date for Hib dose":
	null

define "Expiration Date for Hib dose":
	case
		when Com."Hib One Dose Schedule" 
			then One."Expiration Date for Hib dose"
		when Com."Hib Three Primary Dose Schedule"
			then Three."Expiration Date for Hib dose"
		when Com."Hib Three Primary plus One Booster Schedule"
			then ThreeOne."Expiration Date for Hib dose"
		when Com."Hib Two Primary plus One Booster Schedule"
			then TwoOne."Expiration Date for Hib dose"
		else null
	end


define "Hib Next Dose Number":
	case
		when Com."Hib One Dose Schedule" 
			then One."Hib Next Dose Number"
		when Com."Hib Three Primary Dose Schedule"
			then Three."Hib Next Dose Number"
		when Com."Hib Three Primary plus One Booster Schedule"
			then ThreeOne."Hib Next Dose Number"
		when Com."Hib Two Primary plus One Booster Schedule"
			then TwoOne."Hib Next Dose Number"
		else null
	end


define "Number of Required Hib Doses":
	case
		when Com."Hib One Dose Schedule" 
			then One."Number of Required Hib Doses"
		when Com."Hib Three Primary Dose Schedule"
			then Three."Number of Required Hib Doses"
		when Com."Hib Three Primary plus One Booster Schedule"
			then ThreeOne."Number of Required Hib Doses"
		when Com."Hib Two Primary plus One Booster Schedule"
			then TwoOne."Number of Required Hib Doses"
		else null
	end



/*
 * Rule: Should vaccinate patient for Hib because no doses on 1 dose scheme
 * Annotations:
 * 	 - Provide Hib immunizations – using the "Hib Vaccine immunization – NO PREVIOUS" schedule (1 dose scheme)
 * Outputs:
 * 	 - Immunize Patient for Hib - No Doses
 * References:
 * 	- WHO recommendations for routine immunization - summary tables: https://www.who.int/teams/immunization-vaccines-and-biologicals/policies/who-recommendations-for-routine-immunization---summary-tables
 * Logic:
 *	 (("Hib vaccine immunization history" = "No-doses" = true) and ("Current Patient Age in Months" > 12))
 */
 /*
define "Should vaccinate patient for Hib because no doses on 1 dose scheme":
	IMMZCom."No Hib Doses Administered to Patient" and IMMZCom."Current Patient Age In Months" > 12
*/

/*
 * Rule: Should vaccinate patient for Hib because no doses on 3p dose scheme
 * Annotations:
 * 	 - Provide Hib immunizations – using the "Hib Vaccine immunization 3p schedule – NO PREVIOUS" schedule (3 dose scheme)
 * Outputs:
 * 	 - Immunize Patient for Hib - No Doses
 * References:
 * 	- WHO recommendations for routine immunization - summary tables: https://www.who.int/teams/immunization-vaccines-and-biologicals/policies/who-recommendations-for-routine-immunization---summary-tables
 * Logic:
 *	 ((("Hib vaccine immunization history" = "No-doses") and ("Current Patient Age in Weeks" >= 6 )) and ("In a country where the peak burden of severe Hib disease occurs in young infants" = true))
 */
 /*
define "Should vaccinate patient for Hib because no doses on 3p dose scheme":
	IMMZCom."No Hib Doses Administered to Patient" and IMMZCom."Current Patient Age In Weeks" >= 6 and IMMZConf."In a country where the peak burden of severe Hib disease occurs in young infants" 
	*/

/*
 * Rule: Should vaccinate patient for Hib because 1 dose on 3p dose scheme
 * Annotations:
 * 	 - Provide Hib immunizations – using the "Hib Vaccine immunization 3p schedule – 1 PREVIOUS" schedule (3 dose scheme)
 * Outputs:
 * 	 - Immunize Patient for Hib - 1 Dose
 * References:
 * 	- WHO recommendations for routine immunization - summary tables: https://w
ww.who.int/teams/immunization-vaccines-and-biologicals/policies/who-recommendations-for-routine-immunization---summary-tables
 * Logic:
 *	 (((("Hib vaccine immunization history" = "1-dose" = true) and ("Date last Hib dose given" >= "4 weeks")) and ("In a country where the peak burden of severe Hib disease occurs in young infants" = true)) and ("Age when patient received 1st dose" <= "12 months"))
 */
 /*
define "Should vaccinate patient for Hib because 1 dose on 3p dose scheme":
	IMMZCom."Number of Hib Doses Administered to Patient" = 1
	and IMMZCom."Date Last Hib Dose Administered to Patient" more than 4 'weeks' before Today() 
	and IMMZConf."In a country where the peak burden of severe Hib disease occurs in young infants"
	and IMMZCom."Date First Hib Dose Administered to Patient" less than 12 'months' after Patient.birthDate
*/

/*
 * Rule: Should vaccinate patient for Hib because 2 doses on 3p dose scheme
 * Annotations:
 * 	 - Provide Hib immunizations – using the "Hib Vaccine immunization 3p schedule – 2 PREVIOUS" schedule (3 dose scheme)
 * Outputs:
 * 	 - Immunize Patient for Hib - 2 Doses
 * References:
 * 	- WHO recommendations for routine immunization - summary tables: https://www.who.int/teams/immunization-vaccines-and-biologicals/policies/who-recommendations-for-routine-immunization---summary-tables
 * Logic:
 *	 ((("Hib vaccine immunization history" = "2-doses") and ("Date last Hib dose given" >= "4 weeks")) and ("In a country where the peak burden of severe Hib disease occurs in young infants" = true))
 */
 /*
define "Should vaccinate patient for Hib because 2 doses on 3p dose scheme":
	IMMZCom."Number of Hib Doses Administered to Patient" = 2
	and IMMZCom."Date Last Hib Dose Administered to Patient" more than 4 'weeks' before Today()
	and IMMZConf."In a country where the peak burden of severe Hib disease occurs in young infants"
	*/

/*
 * Rule: Should vaccinate patient for Hib because No dose on 3p+1 dose scheme
 * Annotations:
 * 	 - Provide Hib immunizations – using the "Hib Vaccine immunization 3p + 1 schedule – NO PREVIOUS" schedule (3p+1 dose scheme)
 * Outputs:
 * 	 - Immunize Patient for Hib - No Doses
 * References:
 * 	- WHO recommendations for routine immunization - summary tables: https://www.who.int/teams/immunization-vaccines-and-biologicals/policies/who-recommendations-for-routine-immunization---summary-tables
 * Logic:
 *	 ((("Hib vaccine immunization history" = "No-doses") and ("Current Patient Age in Weeks" >= 6 )) and ("In a setting where the greatest disease morbidity and mortality occur later, or whererate reductions of disease are not fully sustained after the routine use of Hib vaccine" = true))
 */
 /*
define "Should vaccinate patient for Hib because No dose on 3p+1 dose scheme":
	IMMZCom."No Hib Doses Administered to Patient"
	and IMMZCom."Current Patient Age In Weeks" >= 6
	and IMMZConf."In a setting where the greatest disease morbidity and mortality occur later, or whererate reductions of disease are not fully sustained after the routine use of Hib vaccine"
*/

/*
 * Rule: Should vaccinate patient for Hib because 1 dose on 3p+1 dose scheme
 * Annotations:
 * 	 - Provide Hib immunizations – using the "Hib Vaccine immunization 3p + 1 schedule – 1 PREVIOUS" schedule (3p+1 dose scheme)
 * Outputs:
 * 	 - Immunize Patient for Hib - 1 Dose
 * References:
 * 	- WHO recommendations for routine immunization - summary tables: https://www.who.int/teams/immunization-vaccines-and-biologicals/policies/who-recommendations-for-routine-immunization---summary-tables
 * Logic:
 *	 (((("Hib vaccine immunization history" = "1-dose") and ("Date last Hib dose given" >= "4 weeks")) and ("In a setting where the greatest disease morbidity and mortality occur later, or whererate reductions of disease are not fully sustained after the routine use of Hib vaccine" = true)) and ("Age when patient received 1st dose" <= "12 months"))
 */
 /*
define "Should vaccinate patient for Hib because 1 dose on 3p+1 dose scheme":
	IMMZCom."Number of Hib Doses Administered to Patient" = 1
	and IMMZCom."Date Last Hib Dose Administered to Patient" more than 4 'weeks' before Today() 
	and IMMZConf."In a setting where the greatest disease morbidity and mortality occur later, or whererate reductions of disease are not fully sustained after the routine use of Hib vaccine"
	and IMMZCom."Date First Hib Dose Administered to Patient" less than 12 'months' after Patient.birthDate
	*/

/*
 * Rule: Should vaccinate patient for Hib because 2 doses on 3p+1 dose scheme
 * Annotations:
 * 	 - Provide Hib immunizations – using the "Hib Vaccine immunization 3p + 1 schedule – 2 PREVIOUS" schedule (3p+1 dose scheme)
 * Outputs:
 * 	 - Immunize Patient for Hib - 2 Doses
 * References:
 * 	- WHO recommendations for routine immunization - summary tables: https://www.who.int/teams/immunization-vaccines-and-biologicals/policies/who-recommendations-for-routine-immunization---summary-tables
 * Logic:
 *	 ((("Hib vaccine immunization history" = "2-doses") and ("Date last Hib dose given" >= "4 weeks")) and ("In a setting where the greatest disease morbidity and mortality occur later, or whererate reductions of disease are not fully sustained after the routine use of Hib vaccine" = true))
 */
 /*
define "Should vaccinate patient for Hib because 2 doses on 3p+1 dose scheme":
	IMMZCom."Number of Hib Doses Administered to Patient" = 2
	and IMMZCom."Date Last Hib Dose Administered to Patient" more than 4 'weeks' before Today() 
	and IMMZConf."In a setting where the greatest disease morbidity and mortality occur later, or whererate reductions of disease are not fully sustained after the routine use of Hib vaccine"
*/

/*
 * Rule: Should vaccinate patient for Hib because 3 doses on 3p+1 dose scheme
 * Annotations:
 * 	 - Provide Hib immunizations – using the "Hib Vaccine immunization 3p + 1 schedule – 3 PREVIOUS" schedule (3p+1 dose scheme)
 * Outputs:
 * 	 - Immunize Patient for Hib - Booster
 * References:
 * 	- WHO recommendations for routine immunization - summary tables: https://w
ww.who.int/teams/immunization-vaccines-and-biologicals/policies/who-recommendations-for-routine-immunization---summary-tables
 * Logic:
 *	 ((("Hib vaccine immunization history" = "3-doses") and ("Date last Hib dose given" >= "6 months")) and ("In a setting where the greatest disease morbidity and mortality occur later, or whererate reductions of disease are not fully sustained after the routine use of Hib vaccine" = true))
 */
 /*
define "Should vaccinate patient for Hib because 3 doses on 3p+1 dose scheme":
	IMMZCom."Number of Hib Doses Administered to Patient" = 3
	and IMMZCom."Date Last Hib Dose Administered to Patient" more than 6 'months' before Today() 
	and IMMZConf."In a setting where the greatest disease morbidity and mortality occur later, or whererate reductions of disease are not fully sustained after the routine use of Hib vaccine"
*/

/*
 * Rule: Should vaccinate patient for Hib because No dose on 2p+1 dose scheme
 * Annotations:
 * 	 - Provide Hib immunizations – using the "Hib Vaccine immunization 2p + 1 schedule – NO PREVIOUS" schedule (2p+1 dose scheme)
 * Outputs:
 * 	 - Immunize Patient for Hib - No Doses
 * References:
 * 	- WHO recommendations for routine immunization - summary tables: https://www.who.int/teams/immunization-vaccines-and-biologicals/policies/who-recommendations-for-routine-immunization---summary-tables
 * Logic:
 *	 ((("Hib vaccine immunization history" = "No-doses") and ("Current Patient Age in Weeks" >= 6 )) and ("In a setting where the greatest disease morbidity and mortality occur later, or whererate reductions of disease are not fully sustained after the routine use of Hib vaccine" = true))
 */
 /*
define "Should vaccinate patient for Hib because No dose on 2p+1 dose scheme":
	IMMZCom."No Hib Doses Administered to Patient"
	and IMMZCom."Current Patient Age In Weeks" >= 6
	and IMMZConf."In a setting where the greatest disease morbidity and mortality occur later, or whererate reductions of disease are not fully sustained after the routine use of Hib vaccine"
*/

/*
 * Rule: Should vaccinate patient for Hib because 1 dose on 2p+1 dose scheme
 * Annotations:
 * 	 - Provide Hib immunizations – using the "Hib Vaccine immunization 2p + 1 schedule – 1 PREVIOUS" schedule (2p+1 dose scheme)
 * Outputs:
 * 	 - Immunize Patient for Hib - 1 Dose
 * References:
 * 	- WHO recommendations for routine immunization - summary tables: https://www.who.int/teams/immunization-vaccines-and-biologicals/policies/who-recommendations-for-routine-immunization---summary-tables
 * Logic:
 *	 (((("Hib vaccine immunization history" = "1-dose") and ("Date last Hib dose given" >= "8 weeks")) and ("In a setting where the greatest disease morbidity and mortality occur later, or whererate reductions of disease are not fully sustained after the routine use of Hib vaccine" = true)) and ("Age when patient received 1st dose" <= "12 months"))
 */
 /*
define "Should vaccinate patient for Hib because 1 dose on 2p+1 dose scheme":
	IMMZCom."Number of Hib Doses Administered to Patient" = 1
	and IMMZCom."Date Last Hib Dose Administered to Patient" more than 8 'weeks' before Today()
	and IMMZConf."In a setting where the greatest disease morbidity and mortality occur later, or whererate reductions of disease are not fully sustained after the routine use of Hib vaccine"
	and IMMZCom."Date First Hib Dose Administered to Patient" less than 12 'months' after Patient.birthDate
*/

/*
 * Rule: Should vaccinate patient for Hib because 2 dose on 2p+1 dose scheme
 * Annotations:
 * 	 - Provide Hib immunizations – using the "Hib Vaccine immunization 2p + 1 schedule – 2 PREVIOUS" schedule (2p+1 dose scheme)
 * Outputs:
 * 	 - Immunize Patient for Hib - Booster
 * References:
 * 	- WHO recommendations for routine immunization - summary tables: https://www.who.int/teams/immunization-vaccines-and-biologicals/policies/who-recommendations-for-routine-immunization---summary-tables
 * Logic:
 *	 ((("Hib vaccine immunization history" = "2-dose") and ("Date last Hib dose given" >= "6 months")) and ("In a setting where the greatest disease morbidity and mortality occur later, or whererate reductions of disease are not fully sustained after the routine use of Hib vaccine" = true))
 */
 /*
define "Should vaccinate patient for Hib because 2 dose on 2p+1 dose scheme":
	IMMZCom."Number of Hib Doses Administered to Patient" = 2
	and IMMZCom."Date Last Hib Dose Administered to Patient" more than 6 'months' before Today() 
	and IMMZConf."In a setting where the greatest disease morbidity and mortality occur later, or whererate reductions of disease are not fully sustained after the routine use of Hib vaccine"
*/
