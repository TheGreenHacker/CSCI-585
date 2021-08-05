CREATE TABLE locations (
     name VARCHAR(15) PRIMARY KEY,
     coord geometry(POINT) NOT NULL
);

INSERT INTO locations (name, coord)
VALUES
    ('Home',ST_GeomFromText('POINT(-118.28421401542461 34.03229997902043)')),
    ('Campus Activity',ST_GeomFromText('POINT(-118.2861445019307 34.020726052181594)')),
    ('Gould',ST_GeomFromText('POINT(-118.28428208711514 34.0188135505108)')),
    ('Asian Library',ST_GeomFromText('POINT(-118.28371451712718 34.0202452899158)')),
    ('Career Center',ST_GeomFromText('POINT(-118.28578738143105 34.020378235920916)')),
    ('Tutor Center',ST_GeomFromText('POINT(-118.28633644370201 34.02047538863911)')),
    ('Tommy Trojan',ST_GeomFromText('POINT(-118.28542956556906 34.02067992031394)')),
    ('Salvatori Hall',ST_GeomFromText('POINT(-118.28805766138291 34.021385550808795)')),
    ('Taper Hall',ST_GeomFromText('POINT(-118.28455353363111 34.02233149552958)')),
    ('Town and Gown',ST_GeomFromText('POINT(-118.28423273320313 34.019237961495605)')),
    ('Leavey Library',ST_GeomFromText('POINT(-118.28279530051624 34.021809948933424)')),
    ('Transportation',ST_GeomFromText('POINT(-118.28243131541525 34.02060833428381)')),
    ('Ronald Hall',ST_GeomFromText('POINT(-118.28952594026482 34.020219723352476)'));

SELECT ST_AsText(ST_ConvexHull(
    ST_Collect(ARRAY( SELECT coord FROM locations ))
));

SELECT name, ST_AsText(coord) FROM locations
WHERE name != 'Home'
ORDER BY ST_Distance(locations.coord, ST_GeomFromText('POINT(-118.28421401542461 34.03229997902043)'))
LIMIT 4;
