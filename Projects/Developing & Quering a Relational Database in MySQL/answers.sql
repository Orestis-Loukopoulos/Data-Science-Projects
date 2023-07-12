-- Question a
SELECT property.property_id, city, street, num, zip
FROM property
INNER JOIN loc 
	ON loc.location_id = property.location_id
INNER JOIN valuation 
	ON valuation.property_id = property.property_id
WHERE (loc.avg_salary > 40000) AND (valuation.val_day BETWEEN 24 AND 31) AND (valuation.val_month = 12) AND (valuation.val_year = 2020);

-- Question b
SELECT valuator.valuator_id, count(*) AS NUMBER_OF_VALUATIONS
FROM valuator, valuation
WHERE (valuation.valuator_id=valuator.valuator_id) 
		and valuation.val_year=2020
GROUP BY valuator.valuator_id;


-- Question c
SELECT property.property_id, COUNT(valuation_id) AS 'NumVal'
FROM property
INNER JOIN valuation
	ON valuation.property_id = property.property_id
WHERE valuation.val_year = 2020
GROUP BY property.property_id
HAVING NumVal > 2;

-- Question d
SELECT valuation_id
FROM valuation
WHERE valuation.property_id IN 
	(SELECT property_id
	 FROM property
	 WHERE property.location_id IN
		(SELECT location_id
         FROM loc
         WHERE loc.avg_salary > 25000));

-- Question e
SELECT COUNT(valuation_id)
FROM valuation
WHERE valuation.val_year = 2020 AND valuation.property_id IN
	(SELECT property_id
	 FROM property
     INNER JOIN loc ON property.location_id = loc.location_id
     WHERE loc.population > 50000);

-- Question f
SELECT loc.location_id, AVG(valuation.worth/property.size) AS Mean_value
FROM loc, property, valuation
WHERE (property.location_id = loc.location_id) 
		AND (valuation.property_id=property.property_id) 
GROUP BY loc.location_id
ORDER BY Mean_value;

-- Question g
SELECT valuator.valuator_id, COUNT(residence.property_id) AS 'Residence Counted', COUNT(office.property_id) AS 'Office Counted'
FROM valuator
INNER JOIN valuation
	ON valuation.valuator_id = valuator.valuator_id
LEFT JOIN residence
	ON residence.property_id = valuation.property_id
LEFT JOIN office
	ON office.property_id = valuation.property_id
WHERE valuation.val_year = 2020
GROUP BY valuator.valuator_id;

-- Question h
CREATE VIEW AverageVal2020 AS
SELECT loc.location_id, AVG(valuation.worth/property.size) AS "AverageValSQ", valuation.val_year
FROM loc
INNER JOIN property 
	ON loc.location_id = property.location_id
INNER JOIN valuation 
	ON valuation.property_id = property.property_id
WHERE valuation.val_year = 2020
GROUP BY loc.location_id;

CREATE VIEW AverageVal2019 AS
SELECT loc.location_id, AVG(valuation.worth/property.size) AS "AverageValSQ"
FROM loc
INNER JOIN property 
	ON loc.location_id = property.location_id
INNER JOIN valuation 
	ON valuation.property_id = property.property_id
WHERE valuation.val_year = 2019
GROUP BY loc.location_id;

SELECT AverageVal2020.location_id, (AverageVal2020.AverageValSQ - AverageVal2019.AverageValSQ) AS VarianceAverageValSQ_2020_2019
FROM AverageVal2020
INNER JOIN AverageVal2019
	ON AverageVal2020.location_id = AverageVal2019.location_id;

-- Question i
CREATE VIEW VTOTAL_FOR_LOC AS
SELECT loc.location_id, COUNT(valuation.valuation_id) AS total_loc
FROM loc
INNER JOIN property
	ON loc.location_id=property.location_id
INNER JOIN valuation
	ON valuation.property_id=property.property_id
WHERE valuation.val_year=2020
GROUP BY loc.location_id;

CREATE VIEW VTOTAL_FOR_ALL AS
SELECT COUNT(valuation_id) AS total_valuations_2020
FROM valuation
WHERE val_year=2020;

CREATE VIEW POPULATION_LOC AS
SELECT location_id, population AS pop_loc
FROM loc;

CREATE VIEW POPULATION_TOTAL AS
SELECT SUM(population) AS total_population
FROM loc;

SELECT  vtotal_for_loc.location_id, (total_loc/total_valuations_2020)*100 AS cnt_val, (pop_loc/total_population)*100 AS cnt_pop
FROM vtotal_for_loc, vtotal_for_all, population_loc, population_total
WHERE vtotal_for_loc.location_id=population_loc.location_id;

