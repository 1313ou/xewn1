CREATE INDEX IF NOT EXISTS index_words_lemma ON words(lemma);
CREATE INDEX IF NOT EXISTS index_senses_wordid ON senses(wordid);
CREATE INDEX IF NOT EXISTS index_senses_synsetid ON senses(synsetid);
CREATE INDEX IF NOT EXISTS index_synsets_synsetid ON synsets(synsetid);
CREATE INDEX IF NOT EXISTS index_casedwords_wordid_casedwordid ON casedwords(wordid,casedwordid);
CREATE INDEX IF NOT EXISTS index_semlinks_synset1id ON semlinks(synset1id);
CREATE INDEX IF NOT EXISTS index_semlinks_linkid ON semlinks(linkid);
CREATE INDEX IF NOT EXISTS index_samples_synsetid ON samples(synsetid);

