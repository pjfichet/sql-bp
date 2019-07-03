insert into Configuration
	(nom, durée, année_début, mois_début)
values
	('Librairie', 3, 2019, 5);

insert into Produits (nom) values
	("livres particuliers"),
	("livres collectivités"),
	("papeterie");

insert into Activité
(
	idproduit,
	année,
	chiffre_affaires,
	tva,
	prix_achat,
	délai_fournisseur,
	délai_client
) values
	(1, 1, 243620, 0.055, 0.69, 60, 0),
	(1, 2, 273000, 0.055, 0.68, 60, 0),
	(1, 3, 300300, 0.055, 0.67, 60, 0),
	(2, 1,  40800, 0.055, 0.78, 60, 45),
	(2, 2,  54400, 0.055, 0.77, 60, 45),
	(2, 3,  68000, 0.055, 0.76, 60, 45),
	(3, 1,   7028, 0.200, 0.50, 45, 0),
	(3, 2,   7875, 0.200, 0.50, 45, 0),
	(3, 3,   8663, 0.200, 0.50, 45, 0);


insert into Ventes
(
	idproduit,
	année,
	mois,
	pourcentage
) values
	-- livres particuliers
	-- année 1 mai		-- année 2 mai		-- année 3 mai
	(1, 1,  1, 0.000),   (1, 2,  1, 0.063),   (1, 3,  1, 0.063),
	(1, 1,  2, 0.068),   (1, 2,  2, 0.063),   (1, 3,  2, 0.063),
	(1, 1,  3, 0.071),   (1, 2,  3, 0.067),   (1, 3,  3, 0.067),
	(1, 1,  4, 0.052),   (1, 2,  4, 0.049),   (1, 3,  4, 0.049),
	(1, 1,  5, 0.147),   (1, 2,  5, 0.138),   (1, 3,  5, 0.138),
	(1, 1,  6, 0.125),   (1, 2,  6, 0.117),   (1, 3,  6, 0.117),
	(1, 1,  7, 0.081),   (1, 2,  7, 0.076),   (1, 3,  7, 0.076),
	(1, 1,  8, 0.206),   (1, 2,  8, 0.193),   (1, 3,  8, 0.193),
	(1, 1,  9, 0.061),   (1, 2,  9, 0.057),   (1, 3,  9, 0.057),
	(1, 1, 10, 0.064),   (1, 2, 10, 0.060),   (1, 3, 10, 0.060),
	(1, 1, 11, 0.068),   (1, 2, 11, 0.064),   (1, 3, 11, 0.064),
	(1, 1, 12, 0.057),   (1, 2, 12, 0.053),   (1, 3, 12, 0.053),
	-- papéterie
	-- année 1 mai		-- année 2 mai		-- année 3 mai
	(3, 1,  1, 0.000),   (3, 2,  1, 0.063),   (3, 3,  1, 0.063),
	(3, 1,  2, 0.068),   (3, 2,  2, 0.063),   (3, 3,  2, 0.063),
	(3, 1,  3, 0.071),   (3, 2,  3, 0.067),   (3, 3,  3, 0.067),
	(3, 1,  4, 0.052),   (3, 2,  4, 0.049),   (3, 3,  4, 0.049),
	(3, 1,  5, 0.147),   (3, 2,  5, 0.138),   (3, 3,  5, 0.138),
	(3, 1,  6, 0.125),   (3, 2,  6, 0.117),   (3, 3,  6, 0.117),
	(3, 1,  7, 0.081),   (3, 2,  7, 0.076),   (3, 3,  7, 0.076),
	(3, 1,  8, 0.206),   (3, 2,  8, 0.193),   (3, 3,  8, 0.193),
	(3, 1,  9, 0.061),   (3, 2,  9, 0.057),   (3, 3,  9, 0.057),
	(3, 1, 10, 0.064),   (3, 2, 10, 0.060),   (3, 3, 10, 0.060),
	(3, 1, 11, 0.068),   (3, 2, 11, 0.064),   (3, 3, 11, 0.064),
	(3, 1, 12, 0.057),   (3, 2, 12, 0.053),   (3, 3, 12, 0.053),
	-- collectivités
	-- année 1 mai		-- année 2 mai		-- année 3 mai
	(2, 1,  1, 0.000),   (2, 2,  1, 0.000),   (2, 3,  1, 0.000),
	(2, 1,  2, 0.000),   (2, 2,  2, 0.000),   (2, 3,  2, 0.000),
	(2, 1,  3, 0.000),   (2, 2,  3, 0.000),   (2, 3,  3, 0.000),
	(2, 1,  4, 0.333),   (2, 2,  4, 0.250),   (2, 3,  4, 0.300),
	(2, 1,  5, 0.000),   (2, 2,  5, 0.000),   (2, 3,  5, 0.000),
	(2, 1,  6, 0.000),   (2, 2,  6, 0.000),   (2, 3,  6, 0.000),
	(2, 1,  7, 0.000),   (2, 2,  7, 0.000),   (2, 3,  7, 0.000),
	(2, 1,  8, 0.333),   (2, 2,  8, 0.375),   (2, 3,  8, 0.400),
	(2, 1,  9, 0.000),   (2, 2,  9, 0.000),   (2, 3,  9, 0.000),
	(2, 1, 10, 0.000),   (2, 2, 10, 0.000),   (2, 3, 10, 0.000),
	(2, 1, 11, 0.334),   (2, 2, 11, 0.375),   (2, 3, 11, 0.300),
	(2, 1, 12, 0.000),   (2, 2, 12, 0.000),   (2, 3, 12, 0.000);

insert into Stock
	(idproduit, année, mois, montant)
values
	(1, 1, 1, 60000),
	(3, 1, 1,  3000);


insert into Fonctions
	(id, fonction)
values
	(1, "Gestionnaire"),
	(2, "Employé");

insert into Personnel
	(idfonction, année, effectif, mois_embauche,
	salaire_brut, charges_salariales, charges_patronales)
values
	(1, 1, 1, 1, 2020, 0.23, 0.40),
	(1, 2, 1, 1, 2020, 0.23, 0.40),
	(1, 3, 1, 1, 2020*(1 + 0.04), 0.23, 0.40),
	(2, 1, 0.9, 1, 1515, 0.23, 0.34),
	(2, 2, 1, 1, 1515, 0.23, 0.34),
	(2, 3, 1, 1, 1515*(1+0.04), 0.23, 0.34);

insert into Frais
	(id, frais, périodicité, tva)
values
	(1, "eau", 2, 0.2),
	(2, "électricité", 12, 0.2),
	(3, "carburant", 4, 0.2),
	(4, "fournitures non administratives", 4, 0.2),
	(5, "fournitures administratives", 4, 0.2),
	(6, "location local", 12, 0),
	(7, "location mobilière", 1, 0.2),
	(8, "maintenance et entretien", 2, 0.2),
	(9, "assurances", 1, 0.2),
	(10, "abonnements", 1, 0.2),
	(11, "documentation", 1, 0.2),
	(12, "honoraires EC et CAC", 4, 0.2),
	(13, "cotisation Urscoop", 1, 0),
	(14, "publicité", 4, 0.2),
	(15, "transports sur achats", 12, 0.2),
	(16, "déplacements", 4, 0.2),
	(17, "mission réception", 4, 0.2),
	(18, "affranchissements", 12, 0.2),
	(19, "télécommunications", 12, 0.2),
	(20, "services bancaires", 4, 0.2),
	(21, "côtisations professionnelles", 1, 0),
	(22, "garantie loyer", 1, 0),
	(23, "Sofia", 1, 0);

insert into Exploitation
	(idfrais, année, montant)
values
	-- eau
	(1, 1, 150),
	(1, 2, 152),
	(1, 3, 155),
	-- électricité
	(2, 1, 2400),
	(2, 2, 2436),
	(2, 3, 2473),
	-- carburant
	(3, 1, 300),
	(3, 2, 305),
	(3, 3, 309),
	-- fournitures non administratives
	(4, 1, 800),
	(4, 2, 812),
	(4, 3, 824),
	-- fournitures administratives
	(5, 1, 1200),
	(5, 2, 1218),
	(5, 3, 1236),
	-- location local
	(6, 1, 6300),
	(6, 2, 6395),
	(6, 3, 6490),
	-- location mobilière
	(7, 1, 216),
	(7, 2, 219),
	(7, 3, 223),
	-- maintenance et entretien
	(8, 1, 1100),
	(8, 2, 1117),
	(8, 3, 1133),
	-- assurances
	(9, 1, 2900),
	(9, 2, 2944),
	(9, 3, 2988),
	-- abonnements
	(10, 1, 3200),
	(10, 2, 3248),
	(10, 3, 3297),
	-- documentation
	(11, 1, 1300),
	(11, 2, 1320),
	(11, 3, 1339),
	-- honoraires EC et CAC
	(12, 1, 2520),
	(12, 2, 2558),
	(12, 3, 2596),
	-- autres honoraires
	(13, 1, 1800),
	(13, 2, 0),
	(13, 3, 0),
	-- publicité
	(14, 1, 3400),
	(14, 2, 3451),
	(14, 3, 3503),
	-- transports sur achats
	(15, 1, 6412),
	(15, 2, 8717),
	(15, 3, 9801),
	-- déplacements
	(16, 1, 600),
	(16, 2, 609),
	(16, 3, 618),
	-- mission réception
	(17, 1, 1500),
	(17, 2, 1523),
	(17, 3, 1545),
	-- affranchissements
	(18, 1, 240),
	(18, 2, 244),
	(18, 3, 247),
	-- télécommunications
	(19, 1, 720),
	(19, 2, 731),
	(19, 3, 742),
	-- services bancaires
	(20, 1, 1640),
	(20, 2, 1887),
	(20, 3, 2121),
	-- cotisations professionnelles
	(21, 1, 1563),
	(21, 2, 1570),
	(21, 3, 1615),
	-- garantie loyer
	(22, 1, 950),
	(22, 2, 0),
	(22, 3, 0);

insert into impôts
	(idfrais, année, montant)
values
	(23, 1, 4848),
	(23, 2, 5714),
	(23, 3, 6580);

insert into Investissements
	(nom, montant, durée, tva)
values
	("Études", 1000, 1, 0),
	("Incorporels", 3000, 3, 0),
	("Dépôt de garantie loyer", 525, 0, 0),
	("Agencements", 5000, 7, 0.2),
	("Mobilier", 5000, 5, 0.2),
	("Matériel informatique", 3000, 3, 0.2),
	("Travaux", 3000, 5, 0.2);


insert into Fonds
	(id, nom, c_fonds)
values
	(1, "Capital social", 1),
	(2, "Subvention région ESS", 2),
	(3, "Subvention Alca fonds", 2),
	(4, "Subvention Alca salaires", 3),
	(5, "Subvention d'exploitation Grand Angoulême", 3);

insert into Apports
	(idfonds, année, mois, montant)
values
	-- capital social
	(1, 1, 1, 34100),
	(1, 2, 1, 5000),
	(1, 3, 1, 5000),
	-- subvention région
	(2, 1, 7, 34100),
	-- subvention alca fonds
	(3, 1, 7, 12000),
	-- subvention alca salaires
	(4, 1, 7, 12181),
	(4, 2, 6, 7613),
	-- subvention Grand Angoulême
	(5, 1, 4, 10000);


insert into Emprunts
	(année, mois, nom, montant, durée, taux, périodicité)
values
	(1, 2, "Crédit Mutuel", 30000, 4, 0.02, 12),
	(1, 3, "Socoden", 15000, 4, 0.033, 4),
	(1, 3, "France Active", 15000, 4, 0.033, 4);

