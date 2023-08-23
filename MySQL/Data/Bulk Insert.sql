

insert into object_user (username,password,email) 
values("ilias2","1234","elangelis2@yahoo.gr"),
("mpou","1234!","kouper2@yahoo.gr"),
("test","12344","testmails2@yahoo.gr"),
("ilias2","12345","kati2@yahoo.gr");


insert into object_category (name,ekat_id) 
values 
("Βρεφικά Είδη","8016e637b54241f8ad242ed1699bf2da"),
("Ποτά - Αναψυκτικά","a8ac6be68b53443bbd93b229e2f9cd34"),
("Καθαριότητα","d41744460283406a86f8e4bd5010a66d"),
("Προσωπική φροντίδα","8e8117f7d9d64cf1a931a351eb15bd69");

insert into object_subcategory (name,category_id,category_name,ekat_id,ekat_cat_id) 
values 
("Πάνες",1,"Βρεφικά Είδη","e0efaa1776714351a4c17a3a9d412602","8016e637b54241f8ad242ed1699bf2da"),
("Βρεφικές τροφές",1,"Βρεφικά Είδη","7e86994327f64e3ca967c09b5803966a","8016e637b54241f8ad242ed1699bf2da"),
("Μπύρες",2,"Ποτά - Αναψυκτικά","329bdd842f9f41688a0aa017b74ffde4","a8ac6be68b53443bbd93b229e2f9cd34"),
("Αναψυκτικά - Ενεργειακά Ποτά",2,"Ποτά - Αναψυκτικά","3010aca5cbdc401e8dfe1d39320a8d1a","a8ac6be68b53443bbd93b229e2f9cd34"),
("Είδη γενικού καθαρισμού",3,"Καθαριότητα","3be81b50494d4b5495d5fea3081759a6","d41744460283406a86f8e4bd5010a66d"),
("Χαρτικά",3,"Καθαριότητα","034941f08ca34f7baaf5932427d7e635","d41744460283406a86f8e4bd5010a66d"),
("Αποσμητικά",4,"Προσωπική φροντίδα","35410eeb676b4262b651997da9f42777","8e8117f7d9d64cf1a931a351eb15bd69"),
("Κρέμες μαλλιών",4,"Προσωπική φροντίδα","cf079c66251342b690040650104e160f","8e8117f7d9d64cf1a931a351eb15bd69");

insert into object_product (name,category_id,subcategory_id,ekat_id,ekat_cat_id,ekat_sub_id) 
values 
("Pantene Μάσκα Μαλ Αναδόμησης 2λεπτ 300ml",4,8,"267","8e8117f7d9d64cf1a931a351eb15bd69","cf079c66251342b690040650104e160f"),
("Le Petit Marseillais Μάσκα Μαλλ Ξηρ 300ml",4,8,"362","8e8117f7d9d64cf1a931a351eb15bd69","cf079c66251342b690040650104e160f"),
("Elvive Color Vive Μάσκα Μαλ 300ml",4,8,"368","8e8117f7d9d64cf1a931a351eb15bd69","cf079c66251342b690040650104e160f"),
("Syoss Cond Βαμμένα Μαλ 500ml",4,8,"587","8e8117f7d9d64cf1a931a351eb15bd69","cf079c66251342b690040650104e160f"),
("Gliss Condition Ultimate Color 200ml",4,8,"837","8e8117f7d9d64cf1a931a351eb15bd69","cf079c66251342b690040650104e160f"),

("Axe Αποσμητικό Σπρέυ Africa 150ml",4,7,"45","8e8117f7d9d64cf1a931a351eb15bd69","35410eeb676b4262b651997da9f42777"),
("Nivea Black/White Invisible 48h Rollon 50ml",4,7,"60","8e8117f7d9d64cf1a931a351eb15bd69","35410eeb676b4262b651997da9f42777"),
("Noxzema Αποσμ Rollon Classic 50ml",4,7,"387","8e8117f7d9d64cf1a931a351eb15bd69","35410eeb676b4262b651997da9f42777"),
("Dove Deodorant Κρέμα Rollon 50ml",4,7,"475","8e8117f7d9d64cf1a931a351eb15bd69","35410eeb676b4262b651997da9f42777"),
("Dove Αποσμ Σπρέυ 150ml",4,7,"885","8e8117f7d9d64cf1a931a351eb15bd69","35410eeb676b4262b651997da9f42777"),

("Softex Χαρτοπετσέτες Λευκές 30x30 56τεμ",3,6,"183","d41744460283406a86f8e4bd5010a66d","034941f08ca34f7baaf5932427d7e635"),
("Delica Χαρτομάντηλα Αυτοκινήτου Λευκά Big 150τεμ",3,6,"274","d41744460283406a86f8e4bd5010a66d","034941f08ca34f7baaf5932427d7e635"),
("Zewa Χαρτί Κουζίνας Με Σχέδια 2τεμ",3,6,"328","d41744460283406a86f8e4bd5010a66d","034941f08ca34f7baaf5932427d7e635"),
("Softex Χαρτί Υγείας Super Giga 2 Φύλλα 12τεμ",3,6,"674","d41744460283406a86f8e4bd5010a66d","034941f08ca34f7baaf5932427d7e635"),
("Zewa Deluxe Χαρτί Υγείας 3 Φύλλα 8τεμ",3,6,"769","d41744460283406a86f8e4bd5010a66d","034941f08ca34f7baaf5932427d7e635"),
 
("Viakal Υγρό Καθαρισμού Κατά Των Αλάτων 500ml",3,5,"770","d41744460283406a86f8e4bd5010a66d","3be81b50494d4b5495d5fea3081759a6"),
("Klinex Καθ Πατώματος Λεμόνι 1λιτ",3,5,"788","d41744460283406a86f8e4bd5010a66d","3be81b50494d4b5495d5fea3081759a6"),
("Ajax Καθαριστικό Ultra 7 Φυσ Σαπούνι 1λιτ",3,5,"792","d41744460283406a86f8e4bd5010a66d","3be81b50494d4b5495d5fea3081759a6"),
("Lenor Μαλακτικό Gold Orchid 26πλ",3,5,"793","d41744460283406a86f8e4bd5010a66d","3be81b50494d4b5495d5fea3081759a6"),
("Quanto Μαλακτ Μη Συμπ Μπλε 2λιτ",3,5,"870","d41744460283406a86f8e4bd5010a66d","3be81b50494d4b5495d5fea3081759a6"),
 
("Λουξ Πορτοκαλάδα Ανθρ 330ml",2,4,"876","a8ac6be68b53443bbd93b229e2f9cd34","3010aca5cbdc401e8dfe1d39320a8d1a"),
("Coca Cola Πλαστ 4Χ500ml",2,4,"934","a8ac6be68b53443bbd93b229e2f9cd34","3010aca5cbdc401e8dfe1d39320a8d1a"),
("Coca Cola 500ml",2,4,"1013","a8ac6be68b53443bbd93b229e2f9cd34","3010aca5cbdc401e8dfe1d39320a8d1a"),
("Coca Cola 2Χ1,5λιτ",2,4,"1152","a8ac6be68b53443bbd93b229e2f9cd34","3010aca5cbdc401e8dfe1d39320a8d1a"),
("Fanta Πορτοκαλάδα 1,5λιτ",2,4,"1322","a8ac6be68b53443bbd93b229e2f9cd34","3010aca5cbdc401e8dfe1d39320a8d1a"),

("Heineken Μπύρα 330ml",2,3,"1340","a8ac6be68b53443bbd93b229e2f9cd34","329bdd842f9f41688a0aa017b74ffde4"),
("Stella Artois Μπύρα 330ml",2,3,"426","a8ac6be68b53443bbd93b229e2f9cd34","329bdd842f9f41688a0aa017b74ffde4"),
("Fix Hellas Μπύρα 6X330ml",2,3,"602","a8ac6be68b53443bbd93b229e2f9cd34","329bdd842f9f41688a0aa017b74ffde4"),
("Μηλοκλέφτης Μηλίτης 330ml",2,3,"830","a8ac6be68b53443bbd93b229e2f9cd34","329bdd842f9f41688a0aa017b74ffde4"),
("Βεργίνα Μπύρα 500ml",2,3,"1042","a8ac6be68b53443bbd93b229e2f9cd34","329bdd842f9f41688a0aa017b74ffde4"),

("Γιώτης Κρέμα Παιδικη Φαρίν Λακτέ Μπισκότο 300γρ",1,2,"852","8016e637b54241f8ad242ed1699bf2da","7e86994327f64e3ca967c09b5803966a"),
("Nestle Φαρίν Λακτέ 350γρ",1,2,"27","8016e637b54241f8ad242ed1699bf2da","7e86994327f64e3ca967c09b5803966a"),
("Γιώτης Μπισκοτόκρεμα 300γρ",1,2,"67","8016e637b54241f8ad242ed1699bf2da","7e86994327f64e3ca967c09b5803966a"),
("Γιώτης Φρουτόκρεμα 5 Φρούτα 300γρ",1,2,"126","8016e637b54241f8ad242ed1699bf2da","7e86994327f64e3ca967c09b5803966a"),
("Γιώτης Κρέμα Παιδική Φαρίν Λακτέ 300γρ",1,2,"308","8016e637b54241f8ad242ed1699bf2da","7e86994327f64e3ca967c09b5803966a"),

("Pampers Premium Care No 5 11-18κιλ 44τεμ",1,1,"315","8016e637b54241f8ad242ed1699bf2da","e0efaa1776714351a4c17a3a9d412602"),
("Libero Swimpants Πάνες Midi 10-16κιλ 6τεμ",1,1,"420","8016e637b54241f8ad242ed1699bf2da","e0efaa1776714351a4c17a3a9d412602"),
("Babylino Sensitive No6 Econ 15-30κιλ 40τεμ",1,1,"444","8016e637b54241f8ad242ed1699bf2da","e0efaa1776714351a4c17a3a9d412602"),
("Babylino Πάνες Μωρού Sensitive 3-6κιλ Nο 2 26τεμ",1,1,"510","8016e637b54241f8ad242ed1699bf2da","e0efaa1776714351a4c17a3a9d412602"),
("Pampers Πάνες Μωρού Premium Care Newborn 2-5κιλ 26τεμ",1,1,"565","8016e637b54241f8ad242ed1699bf2da","e0efaa1776714351a4c17a3a9d412602");




insert into object_shop (name,address,description,latitude,longitude) 
values 
("Αρισμαρί & Μέλι","","supermarket",38.0240842,23.8055564),
("Παλία Αγορά Τρόφιμα","","convenience",38.0236250,23.7864978),
("Mini Market","Βασ. Γεωργίου Β 11","convenience",38.0208411,23.7775027),
("Σκλαβενίτης","Κηφισίας 7","supermarket",37.9875008,23.7620167),
("Ψιλικά","Πανόρμου 12","convenience",37.9883574,23.7582721),
("Κατσογιάννης","Λαμίας","supermarket",37.9889045,23.7602338),
("Mini Market1","Λαμίας 24","convenience",37.9890495,23.7591570),
("Μασούτης","Λαμίας","supermarket",37.9886895,23.7603626),
("Mini Market2","","convenience",37.9889262,23.7630400),
("Mini Market3","","convenience",37.9893308,23.7621603),
("African Asian food matket","","convenience",37.9888139,23.7633409),
("Tindahan NG Bayan","","convenience",37.9877045,23.7580536),
("Mini Market4","Πανόρμου 34","convenience",37.9908687,23.7595339),
("Ανατολίτικη Αύρα, Μπαχαρικά -Βότανα","","convenience",38.0273294,23.8429315),
("Η Μικρή Αγορά (MiniMarket)","","convenience",38.0273022,23.8429942),
("Bazaar","supermarket","",38.0237165,23.8037239),
("Market In","Μεταμορφώσεως","supermarket",38.0256943,23.8231777),
("Mini Market5","","convenience",38.0105910,23.7950829),
("AB city supermarket","","convenience",38.0111206,23.7944046),
("Ισιδώρα","Ύδρας","convenience",38.0194653,23.8429315),
("Ok! Anytime markets","","supermarket",38.0200100,23.8035107),
("Μασούτης 2","","supermarket",38.0104033,23.8009731),
("Mini Market6","25ης Μαρτίου 20-22","convenience",38.0197310,23.7961284),
("Mini Market7","Ψαρών","convenience",38.0164028,23.7979668),
("Small Market","","Εθνικής Αντιστάσεως",38.0157496,23.7925468),
("Mini Market8","Μπιζανίου","convenience",38.0135562,23.7950614),
("Mini Market9","Διονύσου 18","convenience",38.0208465,23.8081298);



insert into object_offer (shop_id,product_id,has_stock,creation_user_id,likes,dislikes,product_price) 
values 
(1,1,TRUE,1,15,3,4.75),
(1,2,TRUE,1,15,3,4.75),
(1,3,TRUE,1,15,3,4.75),
(1,4,TRUE,1,15,3,4.75),
(1,5,TRUE,1,15,3,4.75),
(1,6,TRUE,1,15,3,4.75),
(3,1,TRUE,1,15,3,4.75),
(3,2,TRUE,1,15,3,4.75),
(4,11,TRUE,1,15,3,4.75),
(4,13,TRUE,1,15,3,4.75),
(4,12,TRUE,1,15,3,4.75),
(4,5,TRUE,1,15,3,4.75),
(4,6,TRUE,1,15,3,4.75),
(4,7,TRUE,1,15,3,4.75),
(5,8,TRUE,1,15,3,4.75),
(5,7,TRUE,1,15,3,4.75),
(5,6,TRUE,1,15,3,4.75),
(5,5,TRUE,1,15,3,4.75),
(5,4,TRUE,1,15,3,4.75),
(5,3,TRUE,1,15,3,4.75),
(5,2,TRUE,1,15,3,4.75),
(8,1,TRUE,1,15,3,4.75),
(9,1,TRUE,1,15,3,4.75),
(10,1,TRUE,1,15,3,4.75),
(11,1,TRUE,1,15,3,4.75),
(12,1,TRUE,1,15,3,4.75),
(13,1,TRUE,1,15,3,4.75),
(14,1,TRUE,1,15,3,4.75),
(15,1,TRUE,1,15,3,4.75),
(16,1,TRUE,1,15,3,4.75),
(17,1,TRUE,1,15,3,4.75),
(18,1,TRUE,1,15,3,4.75),
(19,1,TRUE,1,15,3,4.75),
(20,1,TRUE,1,15,3,4.75),
(21,1,TRUE,1,15,3,4.75),
(22,1,TRUE,1,15,3,4.75),
(23,1,TRUE,1,15,3,4.75),
(24,1,TRUE,1,15,3,4.75);


INSERT INTO Archive_user_score_history (user_id,offer_id,date,score)
VALUES 
(1,1,CURRENT_TIMESTAMP,1000),
(2,20,CURRENT_TIMESTAMP,500),
(3,21,CURRENT_TIMESTAMP,200),
(4,22,CURRENT_TIMESTAMP,100);