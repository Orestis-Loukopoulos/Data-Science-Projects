# Data Analysis with REDIS

This project involves performing an analysis on data related to seller actions using REDIS. The instructions below will guide you through the installation process and the tasks you need to complete.
 
## Instructions

1. Install REDIS on your workstation:
   - If you are using Windows, download Version 4 of REDIS from the following link: [https://github.com/tporadowski/redis/releases](https://github.com/tporadowski/redis/releases).
   - If you have an older version, make sure to upgrade to Version 4, as some of the commands required for the assignment are not supported by older versions. The installation process is straightforward.

2. Download the dataset:
   - Download the "RECORDED_ACTIONS.zip" dataset from [https://drive.google.com/open?id=1wyL8nQKDEu6rdr9BH6CgBwGnPnvRT8cJ](https://drive.google.com/open?id=1wyL8nQKDEu6rdr9BH6CgBwGnPnvRT8cJ).

3. Complete the tasks:
   - Refer to the "TASKS" section for the specific tasks you need to accomplish.
   - Provide answers for the following additional questions:

## Tasks

1.1 How many users modified their listing on January?
   - Tip: Create a BITMAP called "ModificationsJanuary" and use "SETBIT -> 1" for each user that modified their listing. Use BITCOUNT to calculate the answer.

1.2 How many users did NOT modify their listing on January?
   - Tip: Use "BITOP NOT" to perform inversion on the "ModificationsJanuary" BITMAP and use BITCOUNT to calculate the answer. Combine the results with the answer from 1.1. Do these numbers match the total number of your users? If not, provide an explanation for the discrepancy.

1.3 How many users received at least one e-mail per month (January, February, and March)?
   - Tip: Create three BITMAPS named "EmailsJanuary", "EmailsFebruary", and "EmailsMarch". Fill them with "SETBIT" and use "BITOP AND" followed by "BITCOUNT" to calculate the answer.

1.4 How many users received an e-mail in January and March but NOT in February?
   - Tip: Perform "BITOP AND" on "EmailsJanuary" and "EmailsMarch". Perform an inversion of "EmailsFebruary" and use "BITOP AND" as well.

1.5 How many users received an e-mail in January that they did not open but still updated their listing?
   - Tip: Create a new BITMAP named "EmailsOpenedJanuary".

1.6 How many users received an e-mail in January that they did not open but still updated their listing in January OR received an e-mail in February that they did not open but still updated their listing in February OR received an e-mail in March that they did not open but still updated their listing in March?
   - Tip: Create two new BITMAPs named "EmailsOpenedFebruary" and "EmailsOpenedMarch". Perform the same steps as in 1.5 and calculate the answer using "BITOP OR".

1.7 Does it make any sense to keep sending e-mails with recommendations to sellers? Does this strategy really work? How would you describe this in terms a business person would understand?
   - Tip: You may use the findings of the previous questions or calculate anything else you want to justify your answer.