MERGE (e:Employee {id:'the_graph_police', first_name: 'Edgebert', last_name: 'Nodeson'}) SET e:Investigator
WITH e
MATCH (b:Boss)
MERGE (e)-[:HAS_MANAGER]->(b);
CREATE ROLE demo IF NOT EXISTS AS COPY OF reader;
GRANT CREATE ON GRAPH neo4j NODE Investigation TO demo;
GRANT CREATE ON GRAPH * RELATIONSHIP HAS_AUTHOR TO demo;
GRANT CREATE ON GRAPH * RELATIONSHIP INVOLVES TO demo; 
GRANT CREATE ON GRAPH * RELATIONSHIP ABOUT TO demo;
GRANT CREATE ON GRAPH * RELATIONSHIP NEXT_STATUS TO demo;
GRANT DELETE ON GRAPH neo4j NODE Investigation TO demo;
GRANT DELETE ON GRAPH * RELATIONSHIP HAS_AUTHOR TO demo;
GRANT DELETE ON GRAPH * RELATIONSHIP INVOLVES TO demo; 
GRANT DELETE ON GRAPH * RELATIONSHIP ABOUT TO demo;
GRANT DELETE ON GRAPH * RELATIONSHIP NEXT_STATUS TO demo;
CREATE USER the_graph_police IF NOT EXISTS SET PASSWORD "myfancypassword";
GRANT ROLE demo to the_graph_police;
GRANT SET PROPERTY {date, comment, author, status} ON GRAPH neo4j NODES Investigation TO demo;