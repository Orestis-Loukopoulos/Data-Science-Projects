-- Create table loc 
  CREATE TABLE e_properties.loc (
  location_id VARCHAR(45) NOT NULL,
  loc_name VARCHAR(45) NOT NULL,
  population INT,
  avg_salary FLOAT,
  PRIMARY KEY (location_id));
  
  -- create table property 
  CREATE TABLE e_properties.property (
  property_id INT NOT NULL,
  construction_year INT,
  size FLOAT,
  city VARCHAR(45),
  street VARCHAR(45),
  num INT,
  zip VARCHAR(10),
  floor_num INT,
  location_id VARCHAR(45) NOT NULL,
  PRIMARY KEY (property_id),
	FOREIGN KEY (location_id)
    REFERENCES e_properties.loc (location_id));
    
-- create table office
  CREATE TABLE e_properties.office (
  property_id INT NOT NULL,
  vat INT,
  PRIMARY KEY (property_id),
    FOREIGN KEY (property_id)
    REFERENCES e_properties.property (property_id));

-- create table residence    
  CREATE TABLE e_properties.residence (
  property_id INT NOT NULL,
  residence_id VARCHAR(15),
  PRIMARY KEY (property_id),
    FOREIGN KEY (property_id)
    REFERENCES e_properties.property (property_id));
    
-- create table valuator
CREATE TABLE e_properties.valuator (
  valuator_id VARCHAR(45) NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  age INT,
  sex VARCHAR(1),
  city VARCHAR(45),
  street VARCHAR(45),
  num INT,
  zip VARCHAR(10),
  PRIMARY KEY (valuator_id));

-- create table valuation
CREATE TABLE e_properties.valuation (
  valuation_id INT NOT NULL,
  worth FLOAT,
  val_day INT,
  val_month INT,
  val_year INT,
  property_id INT,
  valuator_id VARCHAR(45),
  PRIMARY KEY (valuation_id),
    FOREIGN KEY (property_id)
    REFERENCES e_properties.property (property_id),
    FOREIGN KEY (valuator_id)
    REFERENCES e_properties.valuator (valuator_id)); 

