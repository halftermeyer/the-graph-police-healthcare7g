## Fraud Detection & Investigation Demo

# Neo4j Solution Engineering Hackathon
# The Graph Police🕵️‍♂️🔍


### Demo & Dataset Background

This is a synthetic Dataset, created as a Demo to address insurance companies (French).
<br/>It contains data about Healthcare Professionals and the way they interact between each other, and with their patients (_Beneficiary_ in the Insurance Company perspective).
<br/>The Dataset is built from a KNN Graph of users using Euclidian Distance between their GPS coordinate.
<br/>The probability of an interaction between nodes of the network decreases with the distance.
<br/>If there's a need to dive deep in how the graph is built, you can rebuilt the Graph with [this material](./ingestion/). 

## Database

#### In the same DB we can find that our dataset can Demo several use cases:

1. Healthcare Professional Fraud Detection & Fraud Investigation

![healthcare_model](https://github.com/halftermeyer/neo4j-7g-healthcare-pro-fraud-detection/blob/main/media/healthcare_model.png?raw=true)

2. Case Management

![case_mngt_model](https://github.com/halftermeyer/neo4j-7g-healthcare-pro-fraud-detection/blob/main/media/case_mngt_model.png?raw=true)


3. KYW - Know Your Whoever

![kyw_model](https://github.com/halftermeyer/neo4j-7g-healthcare-pro-fraud-detection/blob/main/media/kyw_model.png?raw=true)

4. HR

![hr_model](https://github.com/halftermeyer/neo4j-7g-healthcare-pro-fraud-detection/blob/main/media/hr_model.png?raw=true)

#### The Dataset could be used and expanded for other use cases like:

- Healthcare Isurance Beneficiary Fraud Detection (not within this Demo)
- Fire, Accidents and Miscellaneous Risks Mitigation
- AML/CFT
- Others


## Demo presentation
#### The current Demo can be reset from neodash first tab

[![Unlikely association](https://img.youtube.com/vi/ifqc-LkD4-4/0.jpg)](https://www.youtube.com/watch?v=ifqc-LkD4-4)


#### The demo is splitted into several parts:
- NeoDash based app for:
  - Know Your Healthcare Professional (_Pro 360_)

    [![video of pro 360](https://img.youtube.com/vi/dMyeZlyMNMo/0.jpg)](https://www.youtube.com/watch?v=dMyeZlyMNMo)

  - Fraud Detection scenarios: They are part of the _Pro 360_ view (Investigation) and some are also processed at the whole DB scale in dedicated tabs (Detection).
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

  - Case Management: a case can be created in the Pro 360 tab and cases are visible in the Case Management tab

    [![Case Management](https://img.youtube.com/vi/w0mxS5Laf1g/0.jpg)](https://www.youtube.com/watch?v=w0mxS5Laf1g)
    
- Bloom Based Investigation:

[![Bloom investigation](https://img.youtube.com/vi/dhg7m-rmy60/0.jpg)](https://www.youtube.com/watch?v=dhg7m-rmy60)

  - *show investigations* search phrase
  - lasso selection
  - *show common PIIs* scene action [there's a twist here]
  - *label fraudulent* scene action

### All materials are available for free usages here:
- Download the [dump](./TheGraphPolice_dump_auradb_5.6.tar) file for the entire dataset. This was tested for Neo4j AuraDB 5.26, and uses top-tier features like RBAC and requires ~400 MB of storage.
- Use a [NeoDash Dashboard](./TheGraphPolice_dashboard_fraud_detection.json) which is also persisted in the DB.
- Use a [Bloom Perspective](./TheGraphPolice_bloom_perspective_fraud_investigation.json)
- This is a [Cypher Script](./example_create_user_rbac.cypher) which will create a new user on the DB, with enough privileges for *read* and *Case Management*.

