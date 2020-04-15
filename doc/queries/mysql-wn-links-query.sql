SELECT 'WordNet (links)' AS section;

SELECT 'links' AS subsection;

SELECT 'all links' AS comment;
SELECT *
FROM linktypes
ORDER BY linkid;

SELECT 'semantical links' AS subsection;

SELECT 'all semantic links' AS comment;
SELECT link, COUNT(*)
FROM semlinks
LEFT JOIN linktypes USING(linkid)
GROUP BY linkid
ORDER BY linkid;

SELECT 'max semlinks per synset' AS comment;
SELECT synset1id, COUNT(*) AS c, definition
FROM semlinks 
LEFT JOIN synsets AS s ON (s.synsetid = synset1id)
GROUP BY synset1id
ORDER BY c DESC
LIMIT 5;

SELECT 'available semantic links for synset' AS comment;
SELECT sy1.synsetid,sy1.definition,link,COUNT(link)
FROM semlinks 
LEFT JOIN synsets AS sy1 ON (sy1.synsetid = synset1id)
LEFT JOIN linktypes USING (linkid)
WHERE sy1.synsetid = 201612191
GROUP BY linkid;

SELECT 'semantic links for "pull"''s synsets)' AS comment;
SELECT w1.lemma,sy1.definition,link,GROUP_CONCAT(w2.lemma),sy2.definition
FROM semlinks 
LEFT JOIN synsets AS sy1 ON (sy1.synsetid = synset1id)
LEFT JOIN senses AS s1 ON (sy1.synsetid = s1.synsetid)
LEFT JOIN words AS w1 ON (s1.wordid = w1.wordid)
LEFT JOIN synsets AS sy2 ON (sy2.synsetid = synset2id)
LEFT JOIN senses AS s2 ON (sy2.synsetid = s2.synsetid)
LEFT JOIN words AS w2 ON (s2.wordid = w2.wordid)
LEFT JOIN linktypes USING(linkid)
WHERE w1.lemma = 'pull'
GROUP BY sy1.synsetid,w1.lemma,sy1.definition,linkid,link,sy2.synsetid,sy2.synsetid,sy2.definition
ORDER BY sy1.synsetid,linkid;

SELECT 'available semantic links for "pull"''s synsets)' AS comment;
SELECT w1.lemma,sy1.synsetid,sy1.definition,GROUP_CONCAT(DISTINCT link)
FROM semlinks 
LEFT JOIN synsets AS sy1 ON (sy1.synsetid = synset1id)
LEFT JOIN senses AS s1 ON (sy1.synsetid = s1.synsetid)
LEFT JOIN words AS w1 ON (s1.wordid = w1.wordid)
LEFT JOIN linktypes USING (linkid)
WHERE w1.lemma = 'pull'
GROUP BY sy1.synsetid
ORDER BY sy1.synsetid;

SELECT 'lexical links' AS subsection;

SELECT 'all lexical links' AS comment;
SELECT link, COUNT(*)
FROM lexlinks
LEFT JOIN linktypes USING(linkid)
GROUP BY linkid
ORDER BY linkid;

SELECT 'max lexlinks per synset' AS comment;
SELECT synset1id, word1id, COUNT(*) AS c,lemma,GROUP_CONCAT(DISTINCT link),definition
FROM lexlinks 
LEFT JOIN synsets AS s ON (s.synsetid = synset1id)
LEFT JOIN words AS w ON (w.wordid = word1id)
LEFT JOIN linktypes USING(linkid)
GROUP BY word1id,synset1id
ORDER BY c DESC
LIMIT 5;

SELECT 'word lexical links' AS comment;
SELECT w1.lemma,link,w2.lemma,s1.definition,s2.definition
FROM lexlinks 
LEFT JOIN synsets AS s1 ON (s1.synsetid = synset1id)
LEFT JOIN synsets AS s2 ON (s2.synsetid = synset2id)
LEFT JOIN words AS w1 ON (w1.wordid = word1id)
LEFT JOIN words AS w2 ON (w2.wordid = word2id)
LEFT JOIN linktypes USING(linkid)
WHERE w1.lemma = 'pull'
ORDER BY linkid;
