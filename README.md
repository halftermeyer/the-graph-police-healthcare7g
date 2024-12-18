# Neo4j Solution Engineering Hackathon
Fraud Detection & Investigation Demo

## All material available here:

- A [dump](./TheGraphPolice_dump_auradb_5.6.tar) of the database. It's tested on Aura 5.26, uses top-tier features like RBAC and requires 400 MB of storage. 
- A [NeoDash dashboard](./TheGraphPolice_dashboard_fraud_detection.json) which is also persisted in the database.
- A [Bloom Perspective](./TheGraphPolice_bloom_perspective_fraud_investigation.json)
- An [example cypher script](./example_create_user_rbac.cypher) to create a new database user with priviledges to manage cases.

All videos can be watched as a [Youtube Playlist](https://www.youtube.com/watch?v=dMyeZlyMNMo&list=PL5_423e39Gyek3muNh2nEvPMssioVapkW). Set the quality of the video to the highest for a better experience.

## Dataset presentation

This is a synthetic dataset created as a demo to address french insurance companies.
It contains data about healthcare professionals and the way they interact between each other and with patients (Beneficiary in the insurance company perspective).
The dataset is built from a KNN graph of users using euclidian distance between their GPS coordinate. The probability of an interaction between to actors of the network decreases with the distance.

If there's a need to dive deep in how the graph is built, a similar -- but somehow different as it's a randomized process -- graph can be rebuilt with [this material](./ingestion/). 

## Database presentation

#### In the same database live the data for several use cases:

- Healthcare professional fraud detection
- Healthcare professional fraud investigation

![healthcare_model](https://github.com/halftermeyer/neo4j-7g-healthcare-pro-fraud-detection/blob/main/media/healthcare_model.png?raw=true)

- Case Management

![case_mngt_model](https://github.com/halftermeyer/neo4j-7g-healthcare-pro-fraud-detection/blob/main/media/case_mngt_model.png?raw=true)


- KYW - Know Your Whoever

![kyw_model](https://github.com/halftermeyer/neo4j-7g-healthcare-pro-fraud-detection/blob/main/media/kyw_model.png?raw=true)

- HR database


![hr_model](https://github.com/halftermeyer/neo4j-7g-healthcare-pro-fraud-detection/blob/main/media/hr_model.png?raw=true)

#### The dataset could be upgraded for other use cases like:

- Healthcare insurance beneficiary fraud detection (not in the demo)
- Fire, Accidents and Miscellaneous Risks
- AML/CFT

## Demo presentation

#### The demo can be reset from neodash first tab

[![reset the demo](https://img.youtube.com/vi/badhHFOrwKQ/0.jpg)](https://www.youtube.com/watch?v=badhHFOrwKQ)


#### The demo is broken down into parts:
- NeoDash-based app for:
  - Know Your Healthcare professional (Pro 360)

    [![video of pro 360](https://img.youtube.com/vi/dMyeZlyMNMo/0.jpg)](https://www.youtube.com/watch?v=dMyeZlyMNMo)

  - Fraud detection scenarios: they are part of the Pro 360 view (Investigation) and some are also processed at the whole database scale in dedicated tabs (Detection).
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
    
- Bloom-based investigation:

[![Bloom investigation](https://img.youtube.com/vi/RSnzW-8TBEI/0.jpg)](https://www.youtube.com/watch?v=RSnzW-8TBEI)

  - *show investigations* search phrase
  - lasso selection
  - *show common PIIs* scene action [there's a twist here]
  - *label fraudulent* scene action
