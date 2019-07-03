-- Copyright (C) 2019 Pierre Jean Fichet
-- <pierrejean dot fichet at posteo dot net>
-- 
-- Permission to use, copy, modify, and/or distribute this software for any
-- purpose with or without fee is hereby granted, provided that the above
-- copyright notice and this permission notice appear in all copies.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-- WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-- MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-- ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-- WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-- ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-- OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

-- budget prévisionnel

begin transaction;

----------------------------------------------------------------
-- Configuration
----------------------------------------------------------------

create table Configuration
(
	nom text,
	durée,
	année_début integer,
	mois_début integer
);

create view Années 
(
	année,
	nom
) as select
	x,
	année_début + x -1
from (with recursive an(x) as (
	select 1
	union all
	select x+1 from an
	where x < case
				when (select mois_début from Configuration) = 0
				then (select durée from Configuration)
				else (select durée + 1 from Configuration)
			end
) select x from an)
left outer join Configuration;

create table Mois
(
	mois integer,
	nom text
);

insert into Mois
	(mois, nom)
values
	(1, 'janvier'), (2, 'février'), (3, 'mars'),
	(4, 'avril'), (5, 'mai'), (6, 'juin'),
	(7, 'juillet'), (8, 'août'), (9, 'septembre'),
	(10, 'octobre'), (11, 'novembre'), (12, 'décembre');

create view Calendrier
(
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois
) as select
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	(select nom from Années where année = année_réelle) as nom_année,
	(select nom from Mois where mois = mois_réel) as nom_mois
from (select
	mois + 12 * (année - 1) as mois_cumulé,
	durée,
	année,
	mois,
	case
		when mois + mois_début -1 <= 12
			then année 
		else année +1
	end as année_réelle,
	case
		when mois + mois_début -1 <= 12
			then mois + mois_début -1	
		else mois + mois_début -1 - 12
	end as mois_réel
from Années
left outer join Mois
left outer join Configuration where mois_cumulé <= durée * 12);
	
----------------------------------------------------------------
-- Activité 
----------------------------------------------------------------

create table Produits
(
	id integer primary key,
	nom text
);

create table Activité
(
	idproduit integer,
	année integer,
	chiffre_affaires real,
	tva real,
	prix_achat real,
	délai_fournisseur integer,
	délai_client integer
);

create view T_activité
(
	année,
	chiffre_affaires,
	achat_marchandise,
	marge_commerciale
) as select
	année,
	sum(chiffre_affaires),
	sum(chiffre_affaires*prix_achat),
	sum(chiffre_affaires) - sum(chiffre_affaires*prix_achat)
	from Activité group by année;

create table Ventes
(
	idproduit integer,
	année integer,
	mois integer,
	pourcentage real
);

create view V_ventes
(
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	mois_cumulé,
	idproduit,
	pourcentage
) as select
	Calendrier.année,
	Calendrier.mois,
	Calendrier.année_réelle,
	Calendrier.mois_réel,
	Calendrier.nom_année,
	Calendrier.nom_mois,
	Calendrier.mois_cumulé,
	Ventes.idproduit,
	Ventes.pourcentage
from Calendrier
left outer join Ventes
on Calendrier.année = Ventes.année
and Calendrier.mois = Ventes.mois;

create table Stock
(
	idproduit integer,
	année integer,
	mois integer,
	montant real
);

create view V_stock
(
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	mois_cumulé,
	idproduit,
	montant
) as select
	Calendrier.année,
	Calendrier.mois,
	Calendrier.année_réelle,
	Calendrier.mois_réel,
	Calendrier.nom_année,
	Calendrier.nom_mois,
	Calendrier.mois_cumulé,
	Stock.idproduit,
	Stock.montant
from Calendrier join Stock
on Calendrier.année = Stock.année
and Calendrier.mois = Stock.mois
where Stock.montant is not NULL;



----------------------------------------------------------------
-- Personnel 
----------------------------------------------------------------

create table Fonctions
(
	id integer primary key,
	fonction text
);

create table Personnel
(
	idfonction integer,
	année,
	effectif real,
	mois_embauche integer default 0,
	salaire_brut real,
	charges_salariales real,
	charges_patronales real
);

create view V_salaires
(
	idfonction,
	année,
	salaires,
	charges_sociales
) as select
	idfonction,
	année,
	salaire_brut*effectif*(12-mois_embauche+1) as salaires,
	salaire_brut*effectif*(12-mois_embauche+1)*charges_patronales as charges_sociales
from Personnel;

create View T_salaires
(
	année,
	salaires,
	charges_sociales
) as select
	année,
	sum(salaires),
	sum(charges_sociales)
	from V_salaires
	group by année;

----------------------------------------------------------------
-- Exploitation
----------------------------------------------------------------

create table Frais
(
	id integer primary key,	
	frais text,
	périodicité integer,
	tva real
);

create table Exploitation
(
	idfrais integer,
	année integer,
	montant real
);

create table impôts
(
	idfrais integer,
	année integer,
	montant real
);

create view T_exploitation
(
	année,
	montant
) as select
	année,
	sum(montant)
	from Exploitation, Frais
	where Exploitation.idfrais = Frais.id
	group by année;

create view T_impôts
(
	année,
	montant
) as select
	année,
	sum(montant)
	from Impôts, Frais
	where Impôts.idfrais = Frais.id
	group by année;

----------------------------------------------------------------
-- Investissements 
----------------------------------------------------------------

create table Investissements
(
	id integer primary key,
	nom text,
	montant real,
	durée integer,
	tva real
);

create view Amortissements
(
	idinvestissement,
	année,
	amortissement
) as select
	Investissements.id,
	année,
	case when durée >= année
		then montant/durée else 0
	end as amortissement
from Investissements
join (select année from Calendrier where mois=12);

create view T_amortissements
(
	année,
	amortissement
) as select
	année,
	sum(amortissement)
from Amortissements group by année;

----------------------------------------------------------------
-- Apports 
----------------------------------------------------------------

create table C_fonds
(
	id integer primary key,
	catégorie text
);
insert into C_fonds
	(id, catégorie)
values
	(1, "capital"),
	(2, "subvention d'investissement"),
	(3, "subvention d'exploitation");

create table Fonds 
(
	id integer primary key,
	nom text,
	c_fonds
);

create table Apports
(
	idfonds integer,
	année integer,
	mois integer,
	montant real
);

create view T_Apports
(
	année,
	c_fonds,
	montant
) as select
	année,
	c_fonds,
	sum(montant)
from Apports, Fonds
	where Apports.idfonds = Fonds.id
	group by année, c_fonds order by année;

create view V_apports
(
	année,
	c_fonds,
	montant
) as select
	année_a,
	c_fonds_a,
	montant
from
(select année as année_a from calendrier where mois = 12)
left outer join (select id as c_fonds_a from C_fonds)
left outer join (select année as année_b, c_fonds as c_fonds_b, montant from T_apports) on
année_a = année_b and c_fonds_a = c_fonds_b;

create view Amortissements_apports
(
	année,
	c_fonds,
	montant
) as select
	année_a,
	c_fonds,
	ifnull(montant, 0)/8 + ifnull(précédent, 0)/4 as montant
from (select 
	année as année_a,
	c_fonds,
	montant,
	(select sum(montant) 
		from V_apports T2
		where T2.année < T1.année
		and T2.c_fonds = T1.c_fonds
		group by année) as précédent
from V_apports T1);

----------------------------------------------------------------
-- Emprunts
----------------------------------------------------------------

create table Emprunts
(
	année,
	mois,
	nom text,
	montant real,
	durée integer,
	taux real,
	périodicité integer
);

create view V_Emprunts
(
	année,
	mois,
	nom,
	montant,
	durée,
	taux,
	périodicité,
	taux_périodique,
	nombre_périodes,
	échéance
) as select
	année,
	mois,
	nom,
	montant,
	durée,
	taux,
	périodicité,
	taux/périodicité as taux_périodique,
	durée*périodicité as nombre_périodes,
	-- PMT https://stackoverflow.com/questions/17194957/replicate-pmt-function-in-sql-use-column-values-as-inputs
	-- montant*(taux/périodicité)/1-power(1+taux/périodes, -(périodes*durée))) as échéance,
	montant*(1+taux)/(durée*périodicité) as échéance
from emprunts;


create view Remboursements
(
	année,
	nom,
	montant_payé,
	capital_remboursé,
	intérêts_payés
) as select
	V_emprunts.année,
	V_emprunts.nom,
	V_emprunts.année*périodicité*échéance as montant_payé,

	-- montant * (power(1+taux_périodique, Années.id*périodicit) -1) /
	-- (power(1+taux_périodique, nombre_périodes) -1)
	-- as capital_remboursé,
	7276.71,

	-- Années.id*périodicité*échéance - montant *
	-- (power(1+taux_périodique, Années.id*périodicit) -1) /
	-- (power(1+taux_périodique, nombre_périodes) -1)
	-- as intérêts_payés
	533.54
from V_emprunts
join (select année from Calendrier where mois = 12)
order by V_emprunts.année;

create view Cal_Remboursements
(
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	nom,
	remboursement
) as select * from (select
	Calendrier.mois_cumulé,
	Calendrier.année,
	Calendrier.mois,
	Calendrier.année_réelle,
	Calendrier.mois_réel,
	Calendrier.nom_année,
	Calendrier.nom_mois,
	nom,
	case when V_emprunts.année = Calendrier.année and V_emprunts.mois < Calendrier.mois
		then 0
	else
		case when Calendrier.mois%(12/périodicité) = 0 then échéance
			else 0
		end 
	end as remboursement
from Calendrier
join V_emprunts
order by Calendrier.année, Calendrier.mois)
where remboursement != 0;

----------------------------------------------------------------
-- Résultat
----------------------------------------------------------------

create View Valeur_Ajoutée
(
	année,
	montant
) as select
	année,
	marge_commerciale + ifnull(subventions, 0) - ifnull(charges, 0)
	from T_activité
	left outer join (select
		année as année_b,
		montant as subventions
		from T_apports where c_fonds = 3)
	on T_activité.année = année_b
	left outer join (select
		année as année_c,
		montant as charges
		from T_Exploitation)
	on T_activité.année = année_c;

create View Excédent
(
	année,
	montant
) as select
	Valeur_Ajoutée.année,
	Valeur_Ajoutée.montant - impôts - salaires - charges_sociales
from Valeur_Ajoutée
left outer join (select année as année_b, montant as impôts from T_impôts)
on Valeur_Ajoutée.année = année_b
left outer join T_Salaires on Valeur_Ajoutée.année = T_Salaires.année;

create View Résultat_Exploitation
(
	année,
	montant
) as select
	Excédent.année,
	Excédent.montant - amortissement
from Excédent
left outer join T_Amortissements
on Excédent.année = T_Amortissements.année;

create View Résultat_Courant
(
	année,
	montant
) as select
	Résultat_Exploitation.année,
	Résultat_Exploitation.montant - intérêts
from Résultat_Exploitation
left outer join (select
	année as année_b, sum(intérêts_payés) as intérêts
	from Remboursements group by année)
on Résultat_Exploitation.année = année_b;

create View Produits_Exceptionnels
(
	année,
	montant
) as select
	Année,
	montant
from Amortissements_apports where c_fonds = 2;

create View Impôt_Sociétés
(
	année,
	montant
) as select
	Résultat_Courant.année,
	(Résultat_Courant.montant + Produits_Exceptionnels.montant)*0.15
from Résultat_Courant
left outer join Produits_Exceptionnels
on Résultat_Courant.année = Produits_Exceptionnels.année;

create View Résultat_net
(
	année,
	montant
) as select
	Résultat_Courant.année,
	(Résultat_Courant.montant + Produits_Exceptionnels.montant) - (Résultat_Courant.montant + Produits_Exceptionnels.montant)*0.15
from Résultat_Courant
left outer join Produits_Exceptionnels
on Résultat_Courant.année = Produits_Exceptionnels.année;

create view Autofinancement
(
	année,
	montant
) as select
	Résultat_net.année,
	Résultat_net.montant + T_amortissements.amortissement - amortissement_subventions
	from Résultat_net
	left outer join T_amortissements
	on Résultat_net.année = T_amortissements.année
	left outer join (select année as année_b, montant as amortissement_subventions
		from Amortissements_apports where c_fonds = 2)
	on Résultat_net.année = année_b;



create view Résultat
(
	id,
	nom,
	année,
	montant
) as select
	1, "Chiffre d'affaires", année, chiffre_affaires
	from T_Activité
union select
	2, "Achat marchandises vendues", année, achat_marchandise
	from T_Activité
union select
	3, "Marge commerciale", année, marge_commerciale
	from T_Activité
union select
	4, "Charges externes", année, sum(montant)
	from T_Exploitation group by année
union select
	5, "Subventions d'exploitations", année, montant
	from T_Apports where c_fonds = 3
union select
	6, "Valeur ajoutée", année, montant
	from Valeur_Ajoutée
union select
	7, "Impôts et taxes", année, montant
	from T_impôts
union select
	8, 'Salaires', année, salaires
	from T_Salaires
union select
	9, "Charges sociales", année, charges_sociales
	from T_Salaires
union select
	10, "Excédent brut d'exploitation", année, montant
	from Excédent
union select
	11, "Dotation aux amortissements", année, amortissement
	from T_Amortissements
union select
	12, "Résultat d'exploitation", année, montant
	from Résultat_Exploitation
union select
	13, "Intérêt des emprunts", année, sum(intérêts_payés)
	from Remboursements group by année
union select
	14, "Résultat courant", année, montant
	from Résultat_Courant
union select
	15, "Produits exceptionnels", année, montant
	from Produits_Exceptionnels
union select
	16, "Impôt sur les sociétés", année, montant
	from Impôt_Sociétés
union select
	17, "Résultat net", année, montant
	from Résultat_net
union select
	18, "Autofinancement", année, montant
	from Autofinancement;

create view Affectation
(
	id,
	nom,
	année,
	montant
) as select
	1, "Résultat avant affectation", année, montant
	from Résultat_net
union select
	2, "Dotation aux amortissements", année, amortissement
	from T_amortissements
union select
	3, "- Amortissements subventions d'investissement", année, montant
	from Amortissements_apports where c_fonds = 2 
union select
	4, "Autofinancement", année, montant
	from Autofinancement;


----------------------------------------------------------------
-- Calendriers
----------------------------------------------------------------

create view Cal_ventes
(
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	idproduit,
	chiffre_affaires,
	tva
) as select
	mois_cumulé,
	V_ventes.année,
	V_ventes.mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	V_ventes.idproduit,
	chiffre_affaires*(1 + tva) * pourcentage as chiffre_affaires,
	chiffre_affaires * tva * pourcentage as tva
from V_ventes, activité
	where V_ventes.idproduit = Activité.idproduit
	and V_ventes.année = Activité.année
order by V_ventes.mois_cumulé, Activité.idproduit;


create view Cal_achats
(
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	idproduit,
	montant,
	tva
) as select
	mois_cumulé,
	T2.année,
	T2.mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	T2.idproduit,
	(select
		Activité.chiffre_affaires*(1 + Activité.tva) * T1.pourcentage * Activité.prix_achat
		from V_ventes T1, Activité
		where T1.idproduit = Activité.idproduit
		and T1.idproduit = T2.idproduit
		and T1.mois_cumulé = T2.mois_cumulé - cast(round(Activité.délai_fournisseur/30) as integer)
	) as montant,
	T3.chiffre_affaires * T3.tva * T2.pourcentage * T3.prix_achat as tva
from V_ventes T2, Activité T3
where T2.idproduit = T3.idproduit
and T2.année = T3.année
union select
	Calendrier.mois_cumulé,
	Calendrier.année,
	Calendrier.mois,
	Calendrier.année_réelle,
	Calendrier.mois_réel,
	Calendrier.nom_année,
	Calendrier.nom_mois,
	idproduit as idproduit,
	montant as  montant,
	0 as tva
from Calendrier
join (select
	Stock.mois + (12 * (stock.année -1)) + cast(round(Activité.délai_fournisseur/30) as integer) as mois_a,
	délai_fournisseur,
	Stock.idproduit as idproduit,
	montant as montant
	from Stock, Activité
	where Stock.idproduit = Activité.idproduit
	and Stock.année = Activité.année)
on Calendrier.mois_cumulé = mois_a
union select
	Calendrier.mois_cumulé,
	Calendrier.année,
	Calendrier.mois,
	Calendrier.année_réelle,
	Calendrier.mois_réel,
	Calendrier.nom_année,
	Calendrier.nom_mois,
	Stock.idproduit,
	0 as montant,
	Stock.montant * Activité.tva * Activité.prix_achat as tva
from Calendrier, Stock, Activité
where Stock.idproduit = Activité.idproduit
and Stock.année = Activité.année
and Calendrier.année = Stock.année
and calendrier.mois = Stock.mois;

	
create view Cal_apports
(
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	idfonds,
	montant
) as select
	Calendrier.mois_cumulé,
	Calendrier.année as année,
	Calendrier.mois as mois,
	Calendrier.année_réelle,
	Calendrier.mois_réel,
	Calendrier.nom_année,
	Calendrier.nom_mois,
	Apports.idfonds as idfonds,
	Apports.montant
from Calendrier, Apports
where Calendrier.année = Apports.année
and Calendrier.mois = Apports.mois
order by année, mois, idfonds;

create view Cal_emprunts
(
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	nom,
	montant
) as select
	Calendrier.mois_cumulé,
	Calendrier.année as année,
	Calendrier.mois as mois,
	Calendrier.année_réelle,
	Calendrier.mois_réel,
	Calendrier.nom_année,
	Calendrier.nom_mois,
	V_Emprunts.nom as nom,
	V_emprunts.montant as montant
from Calendrier, V_emprunts
where Calendrier.année = V_emprunts.année
and Calendrier.mois = V_emprunts.mois
order by année, mois, nom;


-- TODO: paiement trimestriel, vs paiement à l'année, etc.

create view Cal_frais
(
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	idfrais,
	montant,
	tva
) as select * from (select
	T1.mois_cumulé,
	T1.année,
	T1.mois,
	T1.année_réelle,
	T1.mois_réel,
	T1.nom_année,
	T1.nom_mois,
	idfrais,
	case when périodicité = 1 then 
		-- Paiement annuel effectué à l'ouverture
		case when T1.mois = 1 then montant/périodicité else 0 end
	else
		-- autres paiement effectués sur la base du mois réel
		case
			-- frais payés en mois 1 --> le mois 1 vaut 12
			when (T1.mois_réel) % (12/périodicité) = 0
				then montant/périodicité
			else 0
		end
	end as montant,
	case when périodicité = 1 then
		-- Paiment annuel effectué à l'ouverture
		case when T1.mois = 1 then montant/périodicité*tva else 0 end
	else
		-- autres paiement effectués sur la base du mois réel
		case
			-- frais payés en mois 1 --> le mois 1 vaut 12
			when (T1.mois_réel) % (12/périodicité) = 0
				then montant/périodicité*tva
			else 0
		end
	end as tva
from Calendrier T1
left outer join
	(select
		Exploitation.année as année_b,
		Frais.id as idfrais,
		Exploitation.montant as montant,
		Frais.tva as tva,
		Frais.périodicité as périodicité
	from Exploitation, Frais
	where Exploitation.idfrais = Frais.id)
on T1.année = année_b)
where montant != 0;

create view Cal_salaires
(
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	idfonction,
	salaires_net,
	dettes_sociales,
	charges_sociales
) as select
	Calendrier.mois_cumulé,
	Calendrier.année,
	Calendrier.mois,
	Calendrier.année_réelle,
	Calendrier.mois_réel,
	Calendrier.nom_année,
	Calendrier.nom_mois,
	Personnel.idfonction,
	case
		when Personnel.mois_embauche < Calendrier.mois
			then salaire_brut*(1 - charges_salariales) * effectif
		else 0
	end as salaires_net,
	case
		when Personnel.mois_embauche <= Calendrier.mois
			then salaire_brut * effectif * (charges_patronales+charges_salariales)
		else 0
	end as dettes_sociales,
	case
		when Personnel.mois_embauche <= Calendrier.mois - 1
			then salaire_brut * effectif * (charges_patronales+charges_salariales)
		else 0
	end as charges_sociales
--	case when Calendrier.mois_réel % 3 = 0 then
--		case
--			when Personnel.mois_embauche <= Calendrier.mois_id
--			and Personnel.mois_embauche > Calendrier.mois_id -3
--				then salaire_brut * effectif * (charges_patronales + charges_salariales)
--				* (Calendrier.mois_id-Personnel.mois_embauche +1)
--				else salaire_brut * effectif * (charges_patronales+charges_salariales) * 3
--		end	
--	else 0 end as charges_sociales
from Calendrier
left outer join Personnel
on Calendrier.année = Personnel.année;

create view Cal_investissements
(
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	montant,
	tva
) as select * from
	(select * from Calendrier where mois_cumulé = 1)
join (select
	sum(montant*(1+tva)) as montant,
	sum(montant*tva) as tva
from Investissements);

create view Cal_entrées
(
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	ventes,
	apports,
	emprunts,
	subventions_exploitation,
	total
) as select
	mois_cumulé,
	année_id,
	mois_id,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	ventes,
	apports,
	emprunts,
	subventions_exploitation,
	ifnull(ventes, 0) + ifnull(apports, 0) + ifnull(emprunts, 0) + ifnull(subventions_exploitation, 0) as total
from (select
		mois_cumulé as mois_cumulé,
		année as année_id,
		mois as mois_id,
		année_réelle as année_réelle,
		mois_réel as mois_réel,
		nom_année as nom_année,
		nom_mois as nom_mois
	from Calendrier)
left outer join (select
		année as année_a,
		mois as mois_a,
		sum(chiffre_affaires) as ventes
	from Cal_ventes
	group by année, mois)
on année_id = année_a and mois_id = mois_a
left outer join (select
		année as année_b,
		mois as mois_b,
		sum(montant) as apports
	from Cal_apports, Fonds
	where Cal_apports.idfonds = Fonds.id and Fonds.c_fonds !=3
	group by année, mois)
on année_id = année_b and mois_id = mois_b
left outer join (select
		année as année_c,
		mois as mois_c,
		sum(montant) as emprunts
	from Cal_emprunts
	group by année, mois)
on année_id = année_c and mois_id = mois_c
left outer join (select
		année as année_d,
		mois as mois_d,
		sum(montant) as subventions_exploitation
	from Cal_apports, Fonds
	where Cal_apports.idfonds = Fonds.id and Fonds.c_fonds = 3
	group by année, mois)
on année_id = année_d and mois_id = mois_d;

create view Cal_sorties
(
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	achats,
	frais,
	salaires,
	charges_sociales,
	investissements,
	remboursements_emprunts,
	total
) as select
	mois_cumulé,
	année_id as année,
	mois_id as mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	achats,
	frais,
	salaires,
	charges_sociales,
	investissements,
	remboursements_emprunts,
	ifnull(achats, 0) + ifnull(frais, 0) + ifnull(salaires, 0)
		+ ifnull(charges_sociales, 0) + ifnull(investissements, 0) 
		+ ifnull(remboursements_emprunts, 0) as total
from (select
	mois_cumulé as mois_cumulé,
	année as année_id,
	mois as mois_id,
	année_réelle as année_réelle,
	mois_réel as mois_réel,
	nom_année as nom_année,
	nom_mois as nom_mois
	from Calendrier)
left outer join (select
	année as année_a,
	mois as mois_a,
	sum(montant) as achats
	from Cal_achats group by année, mois)
on année_id = année_a and mois_id = mois_a
left outer join (select
	année as année_b,
	mois as mois_b,
	sum(montant) as frais
	from Cal_frais group by année, mois)
on année_id = année_b and mois_id = mois_b
left outer join (select
	année as année_c,
	mois as mois_c,
	sum(salaires_net) as salaires,
	sum(charges_sociales) as charges_sociales
	from Cal_salaires group by année, mois)
on année_id = année_c and mois_id = mois_c
left outer join (select
	année as année_d,
	mois as mois_d,
	montant as investissements
	from Cal_investissements group by année, mois)
on année_id = année_d and mois_id = mois_d
left outer join (select
	année as année_e,
	mois as mois_e,
	sum(remboursement) as remboursements_emprunts
	from Cal_Remboursements group by mois_cumulé)
on année_id = année_e and mois_id = mois_e;

create view Cal_trésorerie
(
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	entrées,
	sorties,
	solde_mensuel,
	solde_cumulé
) as select
	T1.mois_cumulé,
	T1.année,
	T1.mois,
	T1.année_réelle,
	T1.mois_réel,
	T1.nom_année,
	T1.nom_mois,
	T1.total as entrées,
	T2.total as sorties,
	T1.total - T2.total as solde_mensuel,
	(select sum(Cal_entrées.total) - sum(Cal_sorties.total)
		from Cal_entrées, Cal_sorties
		where Cal_entrées.mois_cumulé = Cal_sorties.mois_cumulé
		and Cal_entrées.mois_cumulé <= T1.mois_cumulé)
		as solde_cumulé
from Cal_entrées T1, Cal_sorties T2
where T1.année = T2.année
and T1.mois = T2.mois;

create view Cal_tva
(
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	sur_ventes,
	sur_achats,
	sur_frais,
	sur_immobilisations
) as select
	T1.mois_cumulé,
	T1.année,
	T1.mois,
	T1.année_réelle,
	T1.mois_réel,
	T1.nom_année,
	T1.nom_mois,
	(select sum(tva) from Cal_ventes
		where T1.mois_cumulé = Cal_ventes.mois_cumulé)
	as sur_ventes,
	(select sum(tva) from Cal_achats
		where T1.mois_cumulé = Cal_achats.mois_cumulé)
	as sur_achats,
	(select sum(tva) from Cal_frais
		where T1.mois_cumulé = Cal_frais.mois_cumulé)
	as sur_frais,
	(select sum(tva) from Cal_investissements
		where T1.mois_cumulé = Cal_investissements.mois_cumulé)
	as sur_immobilisations
from Calendrier T1;

create view tva
(
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	montant
) as select
	T1.mois_cumulé,
	T1.année,
	T1.mois,
	T1.année_réelle,
	T1.mois_réel,
	T1.nom_année,
	T1.nom_mois,
	(select
		sum(T2.sur_ventes) - sum(T2.sur_achats)
		- sum(T2.sur_frais) - sum(T2.sur_immobilisations)
	from Cal_tva as T2
	where T1.mois_cumulé >= T2.mois_cumulé)
from Cal_tva as T1;


create view Cal_créances_clients
(
 	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	idproduit,
	montant
) as select
 	Calendrier.mois_cumulé,
	Calendrier.année,
	Calendrier.mois,
	Calendrier.année_réelle,
	Calendrier.mois_réel,
	Calendrier.nom_année,
	Calendrier.nom_mois,
	V_ventes.idproduit,
	chiffre_affaires * pourcentage * (1 + tva)
from Calendrier, V_ventes, Activité
where V_ventes.idproduit = Activité.idproduit
and V_ventes.année = Activité.année
and Activité.délai_client > 0
-- Vente.mois <= Calendrier.mois_id < Vente.mois + délai
-- avec délai réel = délai + fin de mois
and Calendrier.mois_cumulé >= V_ventes.mois_cumulé
and Calendrier.mois_cumulé - V_ventes.mois_cumulé - Activité.délai_client/30 < 1;



create view Cal_dettes_fournisseurs
(
 	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	idproduit,
	montant
) as select
 	Calendrier.mois_cumulé,
	Calendrier.année,
	Calendrier.mois,
	Calendrier.année_réelle,
	Calendrier.mois_réel,
	Calendrier.nom_année,
	Calendrier.nom_mois,
	V_ventes.idproduit,
	chiffre_affaires * pourcentage * prix_achat * (1 + tva)
from Calendrier, V_ventes, Activité
where V_ventes.idproduit = Activité.idproduit
and V_ventes.année = Activité.année
and Activité.délai_fournisseur > 0
-- corriger pour mois 1 année 2
and Calendrier.mois_cumulé - V_ventes.mois_cumulé - Activité.délai_fournisseur/30 < 1
and Calendrier.mois_cumulé >= V_ventes.mois_cumulé
union select
 	Calendrier.mois_cumulé,
	Calendrier.année,
	Calendrier.mois,
	Calendrier.année_réelle,
	Calendrier.mois_réel,
	Calendrier.nom_année,
	Calendrier.nom_mois,
	V_stock.idproduit,
	V_stock.montant * (1 + tva)
from Calendrier, V_stock, Activité
where V_stock.idproduit = Activité.idproduit
and V_stock.année = Activité.année
and Activité.délai_fournisseur > 0
and Calendrier.mois_cumulé - V_stock.mois_cumulé - Activité.délai_fournisseur/30 < 1
and Calendrier.mois_cumulé >= V_stock.mois_cumulé;

create view Cal_dettes_sociales
(
 	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	montant
) as select
 	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	(select sum(dettes_sociales) - sum(charges_sociales)
		from Cal_salaires
		where Cal_salaires.mois_cumulé <= T1.mois_cumulé
		group by année, mois) as montant
from Calendrier T1;

create view Cal_bfr
(
 	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	stock,
	créances_clients,
	dettes_fournisseurs,
	dettes_sociales,
	tva,
	bfr
) as select
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	stock,
	créances_clients,
	dettes_fournisseurs,
	dettes_sociales,
	tva,
	stock
		+ créances_clients
		- dettes_fournisseurs
		- dettes_sociales
		+ tva as bfr
from (select
	mois_cumulé,
	année,
	mois,
	année_réelle,
	mois_réel,
	nom_année,
	nom_mois,
	(select montant from Stock) as stock,
	(select sum(montant)
		from Cal_créances_clients
		where T1.mois_cumulé = Cal_créances_clients.mois_cumulé
	) as créances_clients,
	(select sum(montant)
		from Cal_dettes_fournisseurs
		where T1.mois_cumulé = Cal_dettes_fournisseurs.mois_cumulé
	) as dettes_fournisseurs,
	(select sum(montant)
		from Cal_dettes_sociales
		where T1.mois_cumulé = Cal_dettes_sociales.mois_cumulé
	) as dettes_sociales,
	(select montant
		from tva
		where T1.mois_cumulé = tva.mois_cumulé
	) as tva
from Calendrier T1);


commit;
.quit

