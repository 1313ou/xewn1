SET SESSION group_concat_max_len = 1000000;

SELECT 
	GROUP_CONCAT(CONCAT('SELECT \'', table_name, '\' table_name,COUNT(*) r FROM ', table_name) SEPARATOR ' UNION ')
INTO @sql 
FROM
(
	(
	SELECT table_name
	FROM information_schema.tables
	WHERE table_schema = DATABASE() AND table_type = 'BASE TABLE' AND table_name NOT REGEXP '.*[0-9]+.*'   
    ) 
    UNION 
    (
	SELECT table_name
	FROM information_schema.tables
	WHERE table_schema = DATABASE() AND table_type = 'BASE TABLE' AND table_name REGEXP '.*[0-9]+.*'
    ORDER BY table_name
    )
) AS table_list;


PREPARE s FROM  @sql;
EXECUTE s;
DEALLOCATE PREPARE s;