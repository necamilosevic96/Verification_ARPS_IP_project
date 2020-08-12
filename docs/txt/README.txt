Funkcionalana Verifikacija

Folderi:
    doc - dokumenta i slike
    dut - dizajn fajlovi napisani u vhdl-u
    examples - testovi koji se pokrecu
    images_for_arps - txt fajlovi u kojima su smesteni frejmovi
    sim - skripta za pokretanje simulacije
    sv - uvm okruzenje, fajlovi napisani u SystemVerilog-u

Testovi:
    U skripti "run.do" na lokaciji "sim/run.do" , definise se jedan od dva testa koja ce se pokretati.
    -   Prva test sekvenca podrazumeva citanje frejmova iz txt fajla. Pocetni frejmovi se definisu u "ARPS_IP_bram_curr_simple_seq.sv"
        i "ARPS_IP_bram_ref_simple_seq.sv".
        Broj sekvenci tj. txt fajlova koji ce se ucitavati definise se promenljivom "num_of_seq" u fajlovima 
        "ARPS_IP_bram_curr_simple_seq.sv" , "ARPS_IP_bram_ref_simple_seq.sv" i "ARPS_IP_axil_simple_seq.sv"
        
        
    -   Drugi test sekvenca podrazumeva generisanje 4 granicna slucaja i generisanje random sekvenci. Cetiri granicna slucaja obuhavatju
        "beli-beli", "beli-crni", "crni-beli" i "crni-crni" frejm. Nakon ove 4 kombinacije pustaju se radnom sekvence. Broj random sekvenci 
        definise se promenljivom "num_of_seq" u fajlovima "ARPS_IP_bram_curr_simple_seq_2.sv" , "ARPS_IP_bram_ref_simple_seq_2.sv" i "ARPS_IP_axil_simple_seq.sv"
    
    -   Za drugi test stavljen je fiksan seed od 100. U slucaju greske, nakon ispravke mozemo rekonstruisati slucaj u kojem
        se desila greska i time potvrditi da je greska ispravljena. Za prvi test stavljen je random seed iz razloga sto se pustaju unaprade poznate sekvence.
       
Scoreboard:
    U okviru scoreboard-a proverava se dobijene i referentne vrednosti. Referentne vrednosti se dobijaju pomocu referentnog modela koji prikuplja ucitane podatke
    dobijene od strane monitora.
      
Coverage:
    U okviru coverage-a prikupljaju se vrednosti od strane 5 monitora:
        - BRAM_MV:
            - adrese : sve adrese od 0 do 511
            - podaci : svi podaci od 0 do 7 i od -7 do -1
        - Interrupt: 
            - da li je imao vrednost 1
        - BRAM_CURR 
            - adrese : sve adrese od 0 do 16383
        - BRAM_REF 
            - adrese : sve adrese od 0 do 16383 
        - AXI_LITE :
            - adrese : adrese 0 i 4