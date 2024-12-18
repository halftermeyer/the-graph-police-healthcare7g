MATCH (p:Person)
WITH p, rand() AS ord
SET p._ord = ord;

MATCH (p:Person)
WITH p, rand() AS ord
SET p._ord_2 = ord;

MATCH (p:Person)
WITH p ORDER BY p._ord
LIMIT 100
SET p:PS;

MATCH (p:Person&!PS)
SET p:Beneficiaire;

MATCH (p:PS)
WITH p ORDER BY p._ord
LIMIT 30
SET p:Souscripteur;

MATCH (p:PS)
ORDER BY p._ord_2
LIMIT 30
SET p:Prescripteur;
MATCH (p:PS&!Prescripteur)
SET p:Executeur;

MATCH (p:Person)
WITH p, point({longitude: p.longitude, latitude: p.latitude}) AS loc
SET p.location = loc;

MATCH (p:Person|PS)
RETURN gds.graph.project(
  'myGraph',
  p,
  null,
  {
    sourceNodeLabels: labels(p),
    targetNodeLabels: [],
    sourceNodeProperties: p { .longitude, .latitude },
    targetNodeProperties: {}
  }
);

CALL gds.knn.filtered.write('myGraph', {
    writeRelationshipType: 'AMONG_50_CLOSEST',
    writeProperty: 'score',
    topK: 50,
    randomSeed: 42,
    concurrency: 1,
    nodeProperties: ['longitude', 'latitude'],
    sourceNodeFilter: 'PS'
})
YIELD nodesCompared, relationshipsWritten;

MATCH (p:Prescripteur)
WITH p ORDER BY p._ord_2
LIMIT 20
SET p:Generaliste;
MATCH (p:Prescripteur)
WITH p ORDER BY p._ord_2
SKIP 20
SET p:Ophtalmologiste;

MATCH (p:Executeur)
WITH collect (p) AS ps
UNWIND range (0, size(ps)-1) AS ix
WITH  ["Dentiste", "Opticien", "Pharmacien"][ix%3] AS speciality, ps[ix] AS p
SET p:$(speciality);

MATCH (d:Dentiste)
SET d:Prescripteur;

MATCH (p:Person&!PS) REMOVE p.siret;

MATCH (d:Person)
MERGE (d)-[:AMONG_50_CLOSEST]->(d);

CALL (){
MATCH path = (a:Ophtalmologiste)-[:AMONG_50_CLOSEST]-(p:!PS)-[:AMONG_50_CLOSEST]-(b:Opticien)
RETURN a AS prescripteur, b AS executeur, count(p) AS strength, "optique" AS presta
UNION
MATCH path = (a:Generaliste)-[:AMONG_50_CLOSEST]-(p:!PS)-[:AMONG_50_CLOSEST]-(b:Pharmacien)
RETURN a AS prescripteur, b AS executeur, count(p) AS strength, "pharmacie" AS presta
UNION
MATCH path = (a:Dentiste)-[:AMONG_50_CLOSEST]-(p:!PS)
RETURN a AS prescripteur, a AS executeur, count(p) AS strength, "dentisterie" AS presta
}
WITH prescripteur, executeur, strength, presta
MERGE (prescripteur)-[r:ORDONNANCE_PLAUSIBLE]->(executeur)
SET r.likelihood=strength, r.domaine=presta;

MATCH (p:Person)
WITH p, rand() AS mult
SET p.optic_mult = mult^3;
MATCH (p:Person)
WITH p, rand() AS mult
SET p.dent_mult = mult^2;
MATCH (p:Person)
WITH p, rand() AS mult
SET p.pharma_mult = mult;

MATCH (a:Generaliste), (p:Person&!PS), (b:Pharmacien)
WITH a AS prescripteur, p AS patient, b AS executeur, "pharmacie" AS presta, 0.3 AS yearly_esp, p.pharma_mult AS condition_factor, EXISTS {(p)<-[:AMONG_50_CLOSEST]-(a)} AS likely_prescripteur, EXISTS {(p)<-[:AMONG_50_CLOSEST]-(b)} AS likely_executeur
WITH prescripteur, patient, executeur, presta, yearly_esp, condition_factor, likely_prescripteur, likely_executeur
WITH prescripteur, patient, executeur, presta, yearly_esp, condition_factor, (toFloat(toInteger(likely_prescripteur)) + 0.2)*3.2 AS mult_prescripteur, (toFloat(toInteger(likely_executeur)) + 0.2)*3.2 AS mult_executeur //todo manage degree
WITH prescripteur, patient, executeur, presta, (yearly_esp * condition_factor * mult_prescripteur * mult_executeur * 1/(1+COUNT{(patient)<-[:AMONG_50_CLOSEST]->()})) + (rand()^3 * 0.5) AS esperance
WITH prescripteur, patient, executeur, presta, esperance , toInteger(round(esperance)) AS esperance_nb_events
WHERE esperance > 0.54
UNWIND range (1, esperance_nb_events) AS nth_time
WITH prescripteur, patient, executeur, presta, esperance, esperance_nb_events, nth_time
CALL (prescripteur, patient, executeur, presta, esperance, esperance_nb_events, nth_time){
  CREATE (prescripteur)-[:REALISE]->(prescr:Prestation:Prescription {domaine: presta})-[:ORDONNE]->(exec:Prestation:Execution {domaine: presta})<-[:REALISE]-(executeur),
  (prescr)-[:AU_BENEFICE_DE]->(patient),
  (exec)-[:AU_BENEFICE_DE]->(patient)
} IN TRANSACTIONS OF 100 ROWS;

MATCH (a:Ophtalmologiste), (p:Person&!PS), (b:Opticien)
WITH a AS prescripteur, p AS patient, b AS executeur, "optique" AS presta, 0.3 AS yearly_esp, p.optic_mult AS condition_factor, EXISTS {(p)<-[:AMONG_50_CLOSEST]-(a)} AS likely_prescripteur, EXISTS {(p)<-[:AMONG_50_CLOSEST]-(b)} AS likely_executeur 
WITH prescripteur, patient, executeur, presta, yearly_esp, condition_factor, likely_prescripteur, likely_executeur
WITH prescripteur, patient, executeur, presta, yearly_esp, condition_factor, (toFloat(toInteger(likely_prescripteur)) + 0.2)*3.0 AS mult_prescripteur, (toFloat(toInteger(likely_executeur)) + 0.2)*3.0 AS mult_executeur //todo manage degree
WITH prescripteur, patient, executeur, presta, (yearly_esp * condition_factor * mult_prescripteur * mult_executeur * 1/(1+COUNT{(patient)<-[:AMONG_50_CLOSEST]->()})) + (rand()^3 * 0.5) AS esperance
WITH prescripteur, patient, executeur, presta, esperance , toInteger(round(esperance)) AS esperance_nb_events
WHERE esperance > 0.52
UNWIND range (1, esperance_nb_events) AS nth_time
WITH prescripteur, patient, executeur, presta, esperance, esperance_nb_events, nth_time
CALL (prescripteur, patient, executeur, presta, esperance, esperance_nb_events, nth_time){
  CREATE (prescripteur)-[:REALISE]->(prescr:Prestation:Prescription {domaine: presta})-[:ORDONNE]->(exec:Prestation:Execution {domaine: presta})<-[:REALISE]-(executeur),
  (prescr)-[:AU_BENEFICE_DE]->(patient),
  (exec)-[:AU_BENEFICE_DE]->(patient)
} IN TRANSACTIONS OF 100 ROWS;

MATCH (a:Dentiste), (p:Person&!PS)
WITH a AS prescripteur, p AS patient, a AS executeur, "dentisterie" AS presta, 1.8 AS yearly_esp, p.dent_mult AS condition_factor, EXISTS {(p)<-[:AMONG_50_CLOSEST]-(a)} AS likely_prescripteur, EXISTS {(p)<-[:AMONG_50_CLOSEST]-(b)} AS likely_executeur 
WITH prescripteur, patient, executeur, presta, yearly_esp, condition_factor, likely_prescripteur, likely_executeur
WITH prescripteur, patient, executeur, presta, yearly_esp, condition_factor, (toFloat(toInteger(likely_prescripteur)) + 0.2)*1.7 AS mult_prescripteur, (toFloat(toInteger(likely_executeur)) + 0.2)*1.7 AS mult_executeur //todo manage degree
WITH prescripteur, patient, executeur, presta, (yearly_esp * condition_factor * mult_prescripteur * mult_executeur * 1/(1+COUNT{(patient)<-[:AMONG_50_CLOSEST]->()})) + (rand()^3 * 0.5) AS esperance
WITH prescripteur, patient, executeur, presta, esperance , toInteger(round(esperance)) AS esperance_nb_events
WHERE esperance > 0.7
UNWIND range (1, esperance_nb_events) AS nth_time
WITH prescripteur, patient, executeur, presta, esperance, esperance_nb_events, nth_time
CALL (prescripteur, patient, executeur, presta, esperance, esperance_nb_events, nth_time){
  CREATE (prescripteur)-[:REALISE]->(prescr:Prestation:Prescription {domaine: presta})-[:ORDONNE]->(exec:Prestation:Execution {domaine: presta})<-[:REALISE]-(executeur),
  (prescr)-[:AU_BENEFICE_DE]->(patient),
  (exec)-[:AU_BENEFICE_DE]->(patient)
} IN TRANSACTIONS OF 100 ROWS;

MATCH (el:ElementFacturable)
UNWIND split(el.soins_associes, ',') AS soin_id
MERGE (assoc:ElementFacturable {id: soin_id})
MERGE (el)-[:ASSOCIATION_COURANTE]->(assoc);

MATCH (el:ElementFacturable)
UNWIND split(el.association_surprenante, ',') AS soin_id
MERGE (assoc:ElementFacturable {id: soin_id})
MERGE (el)-[:ASSOCIATION_DOUTEUSE]->(assoc);

MATCH (presta:Prestation)
WITH presta, toInteger(round(3*rand())) AS actes
UNWIND range(1, actes) AS acte
WITH presta, acte
CALL (presta) {
MATCH (el:ElementFacturable {profession:presta.domaine})
UNWIND range(1, el.frequence) AS ball
WITH el, ball, rand() AS ord
ORDER BY ord
RETURN el.soin_ou_medicament AS soin_ou_medicament, el.prix AS prix_conseillé
LIMIT 1
}
WITH presta, acte, soin_ou_medicament, prix_conseillé, round((1 + (rand()^3)) * prix_conseillé, 2) AS prix_facture
CALL (presta, acte, soin_ou_medicament, prix_conseillé, prix_facture) {
CREATE (presta)-[:CONTIENT]->(soin:Soin {soin_ou_medicament:soin_ou_medicament, prix_conseillé: prix_conseillé, prix_facture:prix_facture})
} IN TRANSACTIONS OF 100 ROWS;

CREATE FULLTEXT INDEX ps_fulltext_index
FOR (n:PS) ON EACH [n.first_name, n.last_name, n.city, n.email]
OPTIONS {
  indexConfig: {
    `fulltext.analyzer`: 'french'
  }
};

CREATE FULLTEXT INDEX soin_fulltext_index
FOR (n:Soin) ON EACH [n.soin_ou_medicament]
OPTIONS {
  indexConfig: {
    `fulltext.analyzer`: 'french'
  }
};

MATCH (p:Prestation)
CALL (p) {
WITH 2023 as startYear, 2023 as endYear
WITH startYear, (endYear - startYear) as yearRange
WITH date({
  year:toInteger(1+startYear+floor(rand()*yearRange)), 
  month:toInteger(1+floor(rand()*12)), 
  day:toInteger(1+floor(rand()*27))
}) as d
SET p.date = d
} IN TRANSACTIONS OF 100 ROWS;

MATCH path = (benef:Beneficiaire)<-[:AU_BENEFICE_DE]-(prestation:Prestation&Execution)<-[:REALISE]-(ps:PS), (prestation)-[:CONTIENT]->(s:Soin), (el:ElementFacturable {soin_ou_medicament: s.soin_ou_medicament})
WITH ps, s.soin_ou_medicament AS soin, prestation, el.frequence/100.0 AS `fréquence normale`  ORDER BY ps, soin, prestation.date ASC
WITH ps, soin, collect(prestation) AS prestas, `fréquence normale`
WITH ps, soin, `fréquence normale`, [ix IN range(0, size(prestas)- 2) | {p1: prestas[ix], p2: prestas[ix+1], delta: duration.inDays(prestas[ix].date, prestas[ix+1].date).days }] AS deltas
UNWIND deltas AS delta
WITH ps, soin, `fréquence normale`, delta
WITH ps, soin, `fréquence normale`, delta.p1 AS p1, delta.p2 AS p2, delta.delta AS delta
MERGE (p1)-[:MEME_SOINS_SUCCESSIFS {ps_id: ps.id, soin: soin, frequence_normale: `fréquence normale`, delta_jours: delta}]->(p2);

WITH {
    `Vitamine C (comprimés)`: 'Vitamin C (tablets)',
    `Sirop contre la toux`: 'Cough syrup',
    `Antihistaminique (Cétirizine)`: 'Antihistamine (Cetirizine)',
    `Test de grossesse`: 'Pregnancy test',
    `Ibuprofène (boîte de 20 comprimés 200 mg)`: 'Ibuprofen (box of 20 tablets 200 mg)',
    `Paracétamol (boîte de 16 comprimés 500 mg)`: 'Paracetamol (box of 16 tablets 500 mg)',
    `Crème anti-inflammatoire (Diclofénac)`: 'Anti-inflammatory cream (Diclofenac)',
    `Pansements (boîte de 20)`: 'Bandages (box of 20)',
    `Thermomètre électronique`: 'Electronic thermometer',
    `Antibiotique (Amoxicilline)`: 'Antibiotic (Amoxicillin)',
    `Contrôle de la vue`: 'Eye examination',
    `Lunettes de vue (monture + verres simples)`: 'Eyeglasses (frame + single vision lenses)',
    `Lunettes pour enfants`: 'Children\'s glasses',
    `Verres anti-reflets`: 'Anti-reflective lenses',
    `Lentilles de contact (paire mensuelle)`: 'Contact lenses (monthly pair)',
    `Verres progressifs`: 'Progressive lenses',
    `Monture de lunettes`: 'Eyeglass frame',
    `Réparation de monture`: 'Frame repair',
    `Traitement anti-rayures`: 'Anti-scratch treatment',
    `Lunettes de soleil`: 'Sunglasses',
    `Consultation standard`: 'Standard consultation',
    `Traitement d'une carie simple`: 'Simple cavity treatment',
    `Extraction d'une dent`: 'Tooth extraction',
    `Détartrage`: 'Scaling',
    `Radiographie panoramique`: 'Panoramic X-ray',
    `Pose d'un implant dentaire`: 'Dental implant placement',
    `Pose d'un bridge`: 'Bridge placement',
    `Couronne céramo-métallique`: 'Ceramo-metallic crown',
    `Appareil orthodontique (par semestre)`: 'Orthodontic appliance (per semester)',
    `Blanchiment des dents`: 'Teeth whitening'
} AS translations
MATCH (n:Soin) SET n.`care_or_medicine` = translations[n.`soin_ou_medicament`];

WITH {
    `Vitamine C (comprimés)`: 'Vitamin C (tablets)',
    `Sirop contre la toux`: 'Cough syrup',
    `Antihistaminique (Cétirizine)`: 'Antihistamine (Cetirizine)',
    `Test de grossesse`: 'Pregnancy test',
    `Ibuprofène (boîte de 20 comprimés 200 mg)`: 'Ibuprofen (box of 20 tablets 200 mg)',
    `Paracétamol (boîte de 16 comprimés 500 mg)`: 'Paracetamol (box of 16 tablets 500 mg)',
    `Crème anti-inflammatoire (Diclofénac)`: 'Anti-inflammatory cream (Diclofenac)',
    `Pansements (boîte de 20)`: 'Bandages (box of 20)',
    `Thermomètre électronique`: 'Electronic thermometer',
    `Antibiotique (Amoxicilline)`: 'Antibiotic (Amoxicillin)',
    `Contrôle de la vue`: 'Eye examination',
    `Lunettes de vue (monture + verres simples)`: 'Eyeglasses (frame + single vision lenses)',
    `Lunettes pour enfants`: 'Children\'s glasses',
    `Verres anti-reflets`: 'Anti-reflective lenses',
    `Lentilles de contact (paire mensuelle)`: 'Contact lenses (monthly pair)',
    `Verres progressifs`: 'Progressive lenses',
    `Monture de lunettes`: 'Eyeglass frame',
    `Réparation de monture`: 'Frame repair',
    `Traitement anti-rayures`: 'Anti-scratch treatment',
    `Lunettes de soleil`: 'Sunglasses',
    `Consultation standard`: 'Standard consultation',
    `Traitement d'une carie simple`: 'Simple cavity treatment',
    `Extraction d'une dent`: 'Tooth extraction',
    `Détartrage`: 'Scaling',
    `Radiographie panoramique`: 'Panoramic X-ray',
    `Pose d'un implant dentaire`: 'Dental implant placement',
    `Pose d'un bridge`: 'Bridge placement',
    `Couronne céramo-métallique`: 'Ceramo-metallic crown',
    `Appareil orthodontique (par semestre)`: 'Orthodontic appliance (per semester)',
    `Blanchiment des dents`: 'Teeth whitening'
} AS translations
MATCH (n:ElementFacturable) SET n.`care_or_medicine` = translations[n.`soin_ou_medicament`];

MATCH (n:PS) SET n:HealthcarePro;
MATCH (n:Beneficiaire) SET n:Beneficiary;
MATCH (n:Soin) SET n:Care;
MATCH (n:Prescripteur) SET n:Prescriber;
MATCH (n:Executeur) SET n:Executor;