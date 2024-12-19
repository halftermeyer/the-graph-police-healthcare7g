## Fraud Detection & Investigation Demo

# Neo4j Solution Engineering Hackathon
# The Graph Police🕵️‍♂️🔍
![HIVE Image](https://github.com/user-attachments/assets/d4d2b9d5-e72b-4761-95d0-ebc8896214b5)

### Demo & Dataset Background
# Demo & Dataset Background

This is a synthetic Dataset, created as a Demo to address insurance companies (French).
<br/>It contains data about Healthcare Professionals and the way they interact between each other, and with their patients (_Beneficiary_ in the Insurance Company perspective).
<br/>The Dataset is built from a KNN Graph of users using Euclidian Distance between their GPS coordinate.
<br/>The probability of an interaction between nodes of the network decreases with the distance.
<br/>If there's a need to dive deep in how the graph is built, you can rebuilt the Graph with [this material](./ingestion/). 

## Database

#### In our Dataset you can Demo several use cases, here are the **Graph Models**:

1. Healthcare Professional Fraud Detection & Fraud Investigation
<img width="1362" alt="Screenshot 2024-12-17 at 17 45 14" src="https://github.com/user-attachments/assets/0873bb3f-34ae-4cb8-a07c-a4802950d362" />

2. Case Management
<img width="928" alt="Screenshot 2024-12-18 at 14 44 09" src="https://github.com/user-attachments/assets/7cec5b97-3418-4016-b8bc-5391916bf4df" />

3. KYW - Know Your **_Whoever_**
<img width="842" alt="Screenshot 2024-12-18 at 14 54 11" src="https://github.com/user-attachments/assets/497acbf8-e27b-4a0b-ae48-8c16ca83fe55" />

4. HR
<img width="828" alt="Screenshot 2024-12-18 at 15 04 01" src="https://github.com/user-attachments/assets/e9b9a06e-0935-4bbe-aaab-9f0ace7b7f43" />

#### The Dataset could be used and expanded for other use cases like:

- Healthcare Isurance Beneficiary Fraud Detection (not within this Demo)
- Fire, Accidents and Miscellaneous Risks Mitigation
- AML/CFT
- Others


### Demo & Presentation
The Demo is splitted into several parts:

### Neo4j NeoDash
First, reset the Current Demo from the first tab over NeoDash

[![Unlikely association](https://img.youtube.com/vi/ifqc-LkD4-4/0.jpg)](https://www.youtube.com/watch?v=ifqc-LkD4-4)

Now we can use **NeoDash** app for our use cases.
1. **Know Your Healthcare Professional (_Pro 360_)**

    [![video of pro 360](https://img.youtube.com/vi/dMyeZlyMNMo/0.jpg)](https://www.youtube.com/watch?v=dMyeZlyMNMo)

2. **Fraud Detection:** They are part of the _Pro 360_ view (Investigation) and some are also processed at the whole DB scale in dedicated tabs (Detection).
    - Unlikely association of cares during same visit

    [![Unlikely association](https://img.youtube.com/vi/uub31K26SSU/0.jpg)](https://www.youtube.com/watch?v=uub31K26SSU)
    - Suspicious distance Pro/Beneficiary


    [![Suspicious distance Pro/Beneficiary](https://img.youtube.com/vi/yHFxZcJOyNQ/0.jpg)](https://www.youtube.com/watch?v=yHFxZcJOyNQ)

    - Repeated same acts by a Pro

    [![Repeated same acts by a Pro](https://img.youtube.com/vi/QhO74O4Cf8s/0.jpg)](https://www.youtube.com/watch?v=QhO74O4Cf8s)

    - Prescriber to Executor suspicious flow

    [![Prescriber to Executor suspicious flow](https://img.youtube.com/vi/_F0jSwURNgU/0.jpg)](https://www.youtube.com/watch?v=_F0jSwURNgU)

    - Prescriber and Executor are the same person

    [![Prescriber and Executor are the same person](https://img.youtube.com/vi/dc2a4a0WPh8/0.jpg)](https://www.youtube.com/watch?v=dc2a4a0WPh8)

3. **Case Management:**
    a case can be created in the Pro 360 tab and cases are visible in the Case Management tab

    [![Case Management](https://img.youtube.com/vi/w0mxS5Laf1g/0.jpg)](https://www.youtube.com/watch?v=w0mxS5Laf1g)
    
### Neo4j Bloom

[![Bloom investigation](https://img.youtube.com/vi/dhg7m-rmy60/0.jpg)](https://www.youtube.com/watch?v=dhg7m-rmy60)

  - *show investigations* search phrase
  - lasso selection
  - *show common PIIs* scene action [there's a twist here]
  - *label fraudulent* scene action

### -------- Materials --------

## We encourage users to use these materials, which are also available for download here:
- Download the [dump](./TheGraphPolice_dump_auradb_5.6.tar) file for the entire dataset. This was tested for Neo4j AuraDB 5.26, and uses top-tier features like RBAC and requires ~400 MB of storage.
- Use a [NeoDash Dashboard](./TheGraphPolice_dashboard_fraud_detection.json) which is also persisted in the DB.
- Use a [Bloom Perspective](./TheGraphPolice_bloom_perspective_fraud_investigation.json)
- This is a [Cypher Script](./example_create_user_rbac.cypher) which will create a new user on the DB, with enough privileges for *read* and *Case Management*.

