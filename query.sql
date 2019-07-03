-- queries
.timer on

select * from Années;
select * from Calendrier;
select * from T_Activité;
select * from Stock;
select * from V_ventes;
select * from V_stock;
select * from V_salaires;
select * from T_salaires;
select * from T_exploitation;
select * from T_impôts;
select * from Amortissements;
select * from T_amortissements;
select * from T_apports;
select * from Amortissements_apports;
select * from V_Emprunts;
select * from Remboursements;
select * from Cal_remboursements;
select * from Valeur_Ajoutée;
select * from Excédent;
select * from Résultat_Exploitation;
select * from Résultat_Courant;
select * from Produits_Exceptionnels;
select * from Impôt_Sociétés;
select * from Résultat_net;
select * from Produits_exceptionnels;
select * from Autofinancement;
select * from Affectation;
select * from Cal_ventes where année = 1;
select * from Cal_ventes where année = 1 and idproduit = 2;
select mois, sum(chiffre_affaires) from Cal_ventes where année = 1 group by mois;
select * from Cal_achats where année = 1 and idproduit = 3;
select * from Cal_apports where année =1;
select * from Cal_emprunts where année = 1;
select * from Cal_remboursements where année = 1;
select * from Cal_frais where mois_cumulé = 1;
select sum(montant) from Cal_frais where mois_cumulé = 1;
select * from Cal_salaires where année = 1;
select * from Cal_investissements;
select 'ventes apports emprunts subventions_exploitations total';
select * from Cal_entrées where année = 1;
select * from Cal_sorties where mois_cumulé = 1;
select * from Cal_trésorerie where année = 1;
select * from Cal_tva where année = 1;
select * from tva where année = 1;
select * from Cal_créances_clients where année = 1;
select * from Cal_dettes_fournisseurs where année = 1;
select * from cal_dettes_sociales where année = 1;
select * from cal_bfr where année = 1;


