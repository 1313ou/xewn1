SELECT 'WordNet (basic)' AS section;

SELECT 'lemma lookup' AS subsection;

SELECT 'synsets "option" is member of' AS comment;
SELECT lemma,pos,sensenum,synsetid,SUBSTRING(definition FROM 1 FOR 64)
FROM words
LEFT JOIN senses USING (wordid)
LEFT JOIN synsets USING (synsetid)
WHERE lemma = 'option'
ORDER BY pos,sensenum;

SELECT 'synsets "want" is member of' AS comment;
SELECT lemma,pos,sensenum,synsetid,SUBSTRING(definition FROM 1 FOR 64)
FROM words
LEFT JOIN senses USING (wordid)
LEFT JOIN synsets USING (synsetid)
WHERE lemma = 'want'
ORDER BY pos,sensenum;

SELECT 'synsets verb "like" is member of' AS comment;
SELECT lemma,pos,sensenum,synsetid,SUBSTRING(definition FROM 1 FOR 64)
FROM words
LEFT JOIN senses USING (wordid)
LEFT JOIN synsets USING (synsetid)
WHERE lemma = 'like' AND pos = 'v'
ORDER BY pos,sensenum;

SELECT 'starting with "fear"' AS comment;
SELECT lemma,pos,sensenum,SUBSTRING(definition FROM 1 FOR 64)
FROM words
LEFT JOIN senses USING (wordid)
LEFT JOIN synsets USING (synsetid)
WHERE lemma LIKE 'fear%'
ORDER BY lemma,pos,sensenum;

SELECT 'ending with "wards"' AS comment;
SELECT lemma,pos,sensenum,SUBSTRING(definition FROM 1 FOR 64)
FROM words
LEFT JOIN senses USING (wordid)
LEFT JOIN synsets USING (synsetid)
WHERE lemma LIKE '%wards'
ORDER BY lemma,pos,sensenum;

SELECT 'containing "ipod"' AS comment;
SELECT lemma,pos,sensenum,SUBSTRING(definition FROM 1 FOR 64)
FROM words
LEFT JOIN senses USING (wordid)
LEFT JOIN synsets USING (synsetid)
WHERE lemma LIKE '%ipod%'
ORDER BY lemma,pos,sensenum;

SELECT 'synset members' AS subsection;

SELECT 'synset members' AS comment;
SELECT synsetid,pos,GROUP_CONCAT(lemma),SUBSTRING(definition FROM 1 FOR 60)
FROM synsets
LEFT JOIN senses USING (synsetid)
LEFT JOIN words USING (wordid)
WHERE synsetid IN (200693431,201780873,201781131,201828678,201829904,113796604,105566889,201429048)
GROUP BY synsetid;

SELECT 'members of synsets "want" belongs to' AS comment;
SELECT y.synsetid,y.pos,GROUP_CONCAT(sw2.lemma),SUBSTRING(definition FROM 1 FOR 60)
FROM words AS sw
LEFT JOIN senses AS s USING (wordid)
LEFT JOIN synsets AS y USING (synsetid)
LEFT JOIN senses AS s2 ON (y.synsetid = s2.synsetid)
LEFT JOIN words AS sw2 ON (sw2.wordid = s2.wordid)
WHERE sw.lemma = 'want'
GROUP BY synsetid;

SELECT 'synonyms' AS subsection;

SELECT 'synonyms for "want"' AS comment;
SELECT y.synsetid,y.pos,GROUP_CONCAT(sw2.lemma),SUBSTRING(definition FROM 1 FOR 60)
FROM words AS sw
LEFT JOIN senses AS s USING (wordid)
LEFT JOIN synsets AS y USING (synsetid)
LEFT JOIN senses AS s2 ON (y.synsetid = s2.synsetid)
LEFT JOIN words AS sw2 ON (sw2.wordid = s2.wordid)
WHERE sw.lemma = 'want' AND sw.wordid <> sw2.wordid
GROUP BY synsetid;

SELECT 'semantical links' AS subsection;

SELECT 'get words semantically-linked to "horse"' AS comment;
SELECT s.sensenum,sw.lemma,link,dw.lemma AS linkedlemma,SUBSTRING(definition FROM 1 FOR 60) 
FROM semlinks AS l
LEFT JOIN senses AS s ON (l.synset1id = s.synsetid)
LEFT JOIN words AS sw ON s.wordid = sw.wordid
LEFT JOIN synsets AS sy ON (l.synset1id = sy.synsetid)
LEFT JOIN senses AS d ON (l.synset2id = d.synsetid)
LEFT JOIN words AS dw ON d.wordid = dw.wordid
LEFT JOIN linktypes USING (linkid)
WHERE sw.lemma = 'horse' 
ORDER BY linkid,s.sensenum;

SELECT 'get hypernyms for "horse"' AS comment;
SELECT s.sensenum,sw.lemma,link,dw.lemma AS linkedlemma,SUBSTRING(definition FROM 1 FOR 60) 
FROM semlinks AS l
LEFT JOIN senses AS s ON (l.synset1id = s.synsetid)
LEFT JOIN words AS sw ON s.wordid = sw.wordid
LEFT JOIN synsets AS sy ON (l.synset1id = sy.synsetid)
LEFT JOIN senses AS d ON (l.synset2id = d.synsetid)
LEFT JOIN words AS dw ON d.wordid = dw.wordid
LEFT JOIN linktypes USING (linkid)
WHERE sw.lemma = 'horse' AND linkid=1 AND sy.pos='n'
ORDER BY linkid,s.sensenum;

SELECT 'get hyponyms for "horse"' AS comment;
SELECT s.sensenum,sw.lemma,link,dw.lemma AS linkedlemma,SUBSTRING(definition FROM 1 FOR 60) 
FROM semlinks AS l
LEFT JOIN senses AS s ON (l.synset1id = s.synsetid)
LEFT JOIN words AS sw ON s.wordid = sw.wordid
LEFT JOIN synsets AS sy ON (l.synset1id = sy.synsetid)
LEFT JOIN senses AS d ON (l.synset2id = d.synsetid)
LEFT JOIN words AS dw ON d.wordid = dw.wordid
LEFT JOIN linktypes USING (linkid)
WHERE sw.lemma = 'horse' AND linkid=2 AND sy.pos='n'
ORDER BY linkid,s.sensenum;

SELECT 'get words semantically-linked to "horse" grouped by type' AS comment;
SELECT s.sensenum,sw.lemma,link,GROUP_CONCAT(dw.lemma) AS linkedlemma,SUBSTRING(definition FROM 1 FOR 60) 
FROM semlinks AS l
LEFT JOIN senses AS s ON (l.synset1id = s.synsetid)
LEFT JOIN words AS sw ON s.wordid = sw.wordid
LEFT JOIN synsets AS sy ON (l.synset1id = sy.synsetid)
LEFT JOIN senses AS d ON (l.synset2id = d.synsetid)
LEFT JOIN words AS dw ON d.wordid = dw.wordid
LEFT JOIN linktypes USING (linkid)
WHERE sw.lemma = 'horse'
GROUP BY linkid, link, s.sensenum, sw.lemma, definition
ORDER BY linkid,s.sensenum;

SELECT 'lexical links' AS subsection;

SELECT 'get words lexically-linked to "black"' AS comment;
SELECT s.sensenum,sw.lemma,sy.pos,link,dw.lemma AS linkedlemma,SUBSTRING(definition FROM 1 FOR 60) 
FROM lexlinks AS l
LEFT JOIN senses AS s ON (l.synset1id = s.synsetid AND l.word1id = s.wordid)
LEFT JOIN words AS sw ON s.wordid = sw.wordid
LEFT JOIN synsets AS sy ON (l.synset1id = sy.synsetid)
LEFT JOIN senses AS d ON (l.synset2id = d.synsetid AND l.word2id = d.wordid)
LEFT JOIN words AS dw ON d.wordid = dw.wordid
LEFT JOIN linktypes USING (linkid)
WHERE sw.lemma = 'black'
ORDER BY linkid,sy.pos,s.sensenum;

SELECT 'get antonym to adjective "black"' AS comment;
SELECT s.sensenum,sw.lemma,sy.pos,link,dw.lemma AS linkedlemma,SUBSTRING(definition FROM 1 FOR 60) 
FROM lexlinks AS l
LEFT JOIN senses AS s ON (l.synset1id = s.synsetid AND l.word1id = s.wordid)
LEFT JOIN words AS sw ON s.wordid = sw.wordid
LEFT JOIN synsets AS sy ON (l.synset1id = sy.synsetid)
LEFT JOIN senses AS d ON (l.synset2id = d.synsetid AND l.word2id = d.wordid)
LEFT JOIN words AS dw ON d.wordid = dw.wordid
LEFT JOIN linktypes USING (linkid)
WHERE sw.lemma = 'black' AND linkid=30 AND sy.pos='a'
ORDER BY linkid,s.sensenum;

