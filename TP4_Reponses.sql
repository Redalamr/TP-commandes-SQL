-- ==========================================================
-- TP 4 : COMMANDES SQL - GESTION DES VOYAGEURS
-- Auteur : EL AMRANI MOHAMMED REDA 
-- Date : 5 Février 2026
-- ==========================================================

-- 1. SÉLECTIONS SIMPLES (SELECT / FROM / WHERE)

-- Q1. Afficher tous les voyageurs
SELECT * FROM Voyageur;

-- Q2. Afficher le nom et la région de tous les voyageurs vivant en Corse
SELECT nom, region FROM Voyageur WHERE region = 'Corse';

-- Q3. Afficher les logements situés dans les Alpes
SELECT * FROM Logement WHERE lieu = 'Alpes';

-- Q4. Afficher le nom et le type des logements ayant une capacité supérieure à 30
SELECT nom, type FROM Logement WHERE capacite > 30;

-- Q5. Afficher les logements dont le type est Hôtel ou Gîte
SELECT * FROM Logement WHERE type = 'Hôtel' OR type = 'Gîte';

-- Q6. Afficher les voyageurs dont la région n’est pas Bretagne
SELECT * FROM Voyageur WHERE region != 'Bretagne';

-- Q7. Afficher les séjours commençant avant le jour 20
SELECT * FROM Sejour WHERE debut < 20;

-- Q8. Afficher les activités dont la description contient le mot dériveur
SELECT * FROM Activite WHERE description LIKE '%dériveur%';


-- 2. TRI ET LIMITATION (ORDER BY / LIMIT)

-- Q9. Afficher les voyageurs triés par nom alphabétique
SELECT * FROM Voyageur ORDER BY nom ASC;

-- Q10. Afficher les logements triés par capacité décroissante
SELECT * FROM Logement ORDER BY capacite DESC;

-- Q11. Afficher les 2 logements ayant la plus grande capacité
SELECT * FROM Logement ORDER BY capacite DESC LIMIT 2;



-- 3. CONJONCTION, DISJONCTION ET NÉGATION (AND / OR / NOT)

-- Q12. Afficher les voyageurs habitant Corse ou Bretagne
SELECT * FROM Voyageur WHERE region = 'Corse' OR region = 'Bretagne';

-- Q13. Afficher les logements situés en Corse et de type Gîte
SELECT * FROM Logement WHERE lieu = 'Corse' AND type = 'Gîte';

-- Q14. Afficher les logements non situés en Alpes
SELECT * FROM Logement WHERE lieu != 'Alpes';

-- Q15. Afficher les séjours ayant un début > 15 et une fin < 23
SELECT * FROM Sejour WHERE debut > 15 AND fin < 23;


-- 4. JOINTURES ENTRE TABLES

-- Q16. Nom des voyageurs et nom du logement de chaque séjour
SELECT V.nom, L.nom FROM Sejour S
JOIN Voyageur V ON S.idVoyageur = V.idVoyageur
JOIN Logement L ON S.codeLogement = L.code;

-- Q17. Voyageurs ayant séjourné en Corse
SELECT DISTINCT V.nom FROM Sejour S
JOIN Voyageur V ON S.idVoyageur = V.idVoyageur
JOIN Logement L ON S.codeLogement = L.code
WHERE L.lieu = 'Corse';

-- Q18. Voyageurs ayant séjourné dans les Alpes
SELECT DISTINCT V.nom FROM Sejour S
JOIN Voyageur V ON S.idVoyageur = V.idVoyageur
JOIN Logement L ON S.codeLogement = L.code
WHERE L.lieu = 'Alpes';

-- Q19. Type et lieu des logements visités par Nicolas Bouvier
SELECT DISTINCT L.type, L.lieu FROM Sejour S
JOIN Voyageur V ON S.idVoyageur = V.idVoyageur
JOIN Logement L ON S.codeLogement = L.code
WHERE V.nom = 'Bouvier' AND V.prenom = 'Nicolas';

-- Q20. Activités proposées là où Phileas Fogg a séjourné
SELECT DISTINCT A.description FROM Sejour S
JOIN Voyageur V ON S.idVoyageur = V.idVoyageur
JOIN Activite A ON S.codeLogement = A.codeLogement
WHERE V.nom = 'Fogg';

-- Q21. Séjours avec nom voyageur et lieu du logement
SELECT S.idSejour, V.nom, L.lieu FROM Sejour S
JOIN Voyageur V ON S.idVoyageur = V.idVoyageur
JOIN Logement L ON S.codeLogement = L.code;

-- Q24. Tous les voyageurs, avec leurs séjours s'ils existent (LEFT JOIN)
SELECT V.nom, S.idSejour FROM Voyageur V
LEFT JOIN Sejour S ON V.idVoyageur = S.idVoyageur;

-- Q25. Voyageurs n'ayant effectué AUCUN séjour
SELECT V.nom FROM Voyageur V
LEFT JOIN Sejour S ON V.idVoyageur = S.idVoyageur
WHERE S.idSejour IS NULL;

-- Q26. Tous les logements avec leurs activités si elles existent
SELECT L.nom, A.description FROM Logement L
LEFT JOIN Activite A ON L.code = A.codeLogement;

-- Q29. Logements qui ne proposent aucune activité
SELECT L.nom FROM Logement L
LEFT JOIN Activite A ON L.code = A.codeLogement
WHERE A.codeActivite IS NULL;

-- Question image (Logement | CodeActivite)
SELECT L.nom AS logement, A.codeActivite 
FROM Logement L 
LEFT JOIN Activite A ON L.code = A.codeLogement;


-- 5. AGRÉGATS (COUNT, AVG, MAX, SUM, GROUP BY)

-- Q36. Compter le nombre total de voyageurs
SELECT COUNT(*) FROM Voyageur;

-- Q37. Compter le nombre de logements par type
SELECT type, COUNT(*) FROM Logement GROUP BY type;

-- Q38. Compter le nombre de séjours effectués par chaque voyageur
SELECT V.nom, COUNT(S.idSejour) FROM Voyageur V
LEFT JOIN Sejour S ON V.idVoyageur = S.idVoyageur
GROUP BY V.nom;

-- Q40. Capacité moyenne des logements
SELECT AVG(capacite) FROM Logement;

-- Q41. Logement ayant la capacité maximale
SELECT nom, capacite FROM Logement 
WHERE capacite = (SELECT MAX(capacite) FROM Logement);


-- 6. SOUS-REQUÊTES & ENSEMBLISTES

-- Q44. Voyageurs ayant fait un séjour dans les Alpes (EXISTS)
SELECT * FROM Voyageur V 
WHERE EXISTS (
    SELECT 1 FROM Sejour S 
    JOIN Logement L ON S.codeLogement = L.code 
    WHERE S.idVoyageur = V.idVoyageur AND L.lieu = 'Alpes'
);

-- Q49. Liste des régions des voyageurs OU des lieux de logement (UNION)
SELECT region FROM Voyageur
UNION
SELECT lieu FROM Logement;

-- Q50. Régions communes aux voyageurs et aux lieux (INTERSECT)
SELECT region FROM Voyageur
INTERSECT
SELECT lieu FROM Logement;


-- 7. POUR ALLER PLUS LOIN

-- Q52. Voyageurs et nombre total de jours passés en séjour
SELECT V.nom, SUM(S.fin - S.debut) AS Total_Jours
FROM Voyageur V
JOIN Sejour S ON V.idVoyageur = S.idVoyageur
GROUP BY V.nom;

-- Q53. Liste des voyageurs avec les activités qu'ils ont pu pratiquer
SELECT DISTINCT V.nom, A.description
FROM Voyageur V
JOIN Sejour S ON V.idVoyageur = S.idVoyageur
JOIN Logement L ON S.codeLogement = L.code
JOIN Activite A ON L.code = A.codeLogement;

-- Q54. Logements ayant toutes les activités disponibles dans la base
SELECT L.nom 
FROM Logement L
JOIN Activite A ON L.code = A.codeLogement
GROUP BY L.nom
HAVING COUNT(DISTINCT A.codeActivite) = (SELECT COUNT(DISTINCT codeActivite) FROM Activite);

-- Q55. Voyageurs qui ont séjourné dans toutes les régions existantes
SELECT V.nom 
FROM Voyageur V
JOIN Sejour S ON V.idVoyageur = S.idVoyageur
JOIN Logement L ON S.codeLogement = L.code
GROUP BY V.nom
HAVING COUNT(DISTINCT L.lieu) = (SELECT COUNT(DISTINCT lieu) FROM Logement);
