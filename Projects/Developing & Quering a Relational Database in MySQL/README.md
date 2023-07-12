# Developing & Quering a Relational Database in MySQL


E-Properties estimates a set of properties managed by its appraisers. Each appraiser is described by a unique code, first name, last name, gender, age, and address. The properties are described by a unique code, address, floor, size (in sqm), construction year, and are classified as either offices or residences. Offices have additional information, such as the tax identification number of the owner, while residences have the owner's identification number. An appraiser evaluates a property, and the evaluation is recorded with a unique code, the value, and the date (day, month, year) of the evaluation. A property belongs to an area. An area is described by a code, a name, its population, and the average income.

## Tasks

1. **Entity-Relationship Model**
   - Describe your application using the entity-relationship model.
   - Use any program of your choice to design the diagram.

2. **Relational Model and SQL Tables**
   - Translate your design to the relational model.
   - Create tables, attributes, and constraints in SQL Server using SQL (`CREATE TABLE`).
   - Insert rows into the tables using `INSERT INTO` statements.

3. **SQL Queries**
   - Write and execute SQL queries for the following tasks:
     * a) Show the code and address of properties that belong to an area with an average income greater than €40,000 and have been evaluated between December 24th, 2020, and December 31st, 2020.
     * b) For each appraiser, display the count of evaluations they have performed in 2020.
     * c) Show the code of properties that have been evaluated more than twice in 2020.
     * d) Using nested queries, display the code of evaluations performed in areas with an average income greater than €25,000.
     * e) Show the count of evaluations in 2020 for properties that belong to areas with a population greater than 50,000.
     * f) For each area code, display the area code and the average evaluation value per sqm for that area, in ascending order of the average evaluation value.
     * g) For each appraiser in 2020, display their code, the count of evaluations they have performed for residences, and the count of evaluations they have performed for offices (3 columns).
     * h) For each area code, show the change in the average evaluation value per sqm between 2020 and 2019.
     * i) For each area code in 2020, display the count of evaluations for that area as a percentage of the total count of evaluations in 2020 (one column), and the population of the area as a percentage of the total population of all areas.

4. **Programming Task**
   - Using any programming language of your choice, connect to the database and implement query (i) from above without using GROUP BY in the SQL statement, meaning you can only use SELECT...FROM...WHERE.

