with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;
with Alea;

--------------------------------------------------------------------------------
--  Auteur   : Julien LEONARD
--  Objectif : Permettre à l'utilisateur de jouer contre l'ordinateur au jeu de 13 allumettes, en sélectionnant le niveau de difficulté de celui-ci, ainsi que le joueur débutant la partie.
--------------------------------------------------------------------------------

procedure Allumettes is
    
    NOMBRE_ALLUMETTES_INITIAL : CONSTANT Integer := 13;
    ALLUMETTES_PAR_PRISE_MAX : CONSTANT Integer := 3;
    NB_LIGNES : CONSTANT Integer := 3; 
    BLOC_COLONNES : CONSTANT Integer := 5;
  
    package Alea_1_max is
            new Alea (1, ALLUMETTES_PAR_PRISE_MAX);
    use Alea_1_max;

    Utilisateur_Va_Jouer : Boolean;
    Niveau_Ordinateur : Character;
    Joueur_Commence : Character;
    Nombre_Allumettes_Restantes : Integer := NOMBRE_ALLUMETTES_INITIAL;
    Nombre_Allumettes_Choisies : Integer;
    Nombre_Allumettes_Valide : Boolean;

begin

   -- Saisir de façon conviviale le niveau de l'ordinateur.
    
       Put("Niveau de l'ordinateur (n)aïf, (d)istrait, (r)apide ou (e)xpert ? ");
       Get(Niveau_Ordinateur);
    
       -- Afficher le niveau de l'ordinateur.
            
           case Niveau_Ordinateur is
               when 'n'|'N' =>
                   Put_Line("Mon niveau est naïf.");
               when 'd' | 'D' =>
                   Put_Line("Mon niveau est distrait.");
               when 'r' | 'R' =>
                   Put_Line("Mon niveau est rapide.");
               when Others =>
                   Put_Line("Mon niveau est expert.");
           end case;

    -- Définir quel joueur commence la partie.
    
        Put("Est-ce que vous commencez (o/n) ? " );
        Get(Joueur_Commence);
        
        if Joueur_Commence ='o' or Joueur_Commence = 'O' then
            Utilisateur_Va_Jouer := True;
        else
            Utilisateur_Va_Jouer := False;
        end if;

    -- Faire se dérouler le jeu.
    
        loop
        
        -- Afficher les allumettes sous forme de bâtons.
        
            for Rangee in 1..NB_LIGNES loop
                New_Line;
                for i in 1..Nombre_Allumettes_Restantes loop
                    Put("|");
                    if i mod BLOC_COLONNES = 0 then
                        Put(" ");
                    end if;
                end loop;
            end loop;
            New_Line;
            New_Line;
            
	-- Faire choisir le joueur suivant.

	    loop
    
                if not(Utilisateur_Va_Jouer) then
	
                -- Faire choisir l'ordinateur.
                    case Niveau_Ordinateur is
                        when 'n'|'N' =>
                        -- Jouer en mode naïf.
			-- Analyser de cette façon le mode naîf permet de rendre le code plus évolutif.
			-- Il suffit de modifier le nombre maximal d'allumettes à prendre autorisé en début de programme pour reporter ce changement ici.
                            loop
		    	        Alea_1_max.Get_Random_Number(Nombre_Allumettes_Choisies);
			    exit when Nombre_Allumettes_Choisies <= Nombre_Allumettes_Restantes ;
		            end loop;
                        when 'r'| 'R' =>
                        -- Jouer en mode rapide.
                            if Nombre_Allumettes_Restantes < ALLUMETTES_PAR_PRISE_MAX then
                                Nombre_Allumettes_Choisies := Nombre_Allumettes_Restantes;
                            else
                                Nombre_Allumettes_Choisies := ALLUMETTES_PAR_PRISE_MAX;
                            end if;
                        when 'd' | 'D' =>
                        -- Jouer en mode distrait.
                            Alea_1_max.Get_Random_Number(Nombre_Allumettes_Choisies);
                        when others =>
                        -- Jouer en mode expert.
			-- l'ordinateur cherche en permanence à ramener l'utilisateur à 4n+1 allumettes pour s'assurer qu'il perde (4 correspond à un nombre d'allumettes que l'on est sûr de pouvoir retirer en un tour d'ordinateur et joueur consécutifs).
                            if (Nombre_Allumettes_Restantes - 1) mod 4 /= 0 then
                                Nombre_Allumettes_Choisies := (Nombre_Allumettes_Restantes - 1) mod 4;
                            else
                                Nombre_Allumettes_Choisies := 1 ;
                            end if;
                    end case;
                
                    -- Afficher par une phrase le nombre d'allumettes prises par l'ordinateur.
                
                    if Nombre_Allumettes_Choisies = 1 then
	    	        Put_Line("Je prends" & Integer'Image(Nombre_Allumettes_Choisies) & " allumette.");
                    else
	    	        Put_Line("Je prends" & Integer'Image(Nombre_Allumettes_Choisies) & " allumettes.");
	            end if;
	 
                else
                
                -- Faire choisir l'utilisateur.
                
	            Put("Combien d'allumettes prenez vous ? ");
                    Get(Nombre_Allumettes_Choisies);
	        end if;

                -- Examiner le nombre d'allumettes prises.
            
	            if Niveau_Ordinateur = 'd' or Niveau_Ordinateur = 'D' or Utilisateur_Va_Jouer then
                        if Nombre_Allumettes_Choisies > ALLUMETTES_PAR_PRISE_MAX then
                            Put_Line("La prise est limitée à 3 allumettes maximum !");
                            Nombre_Allumettes_Valide := False;
                        elsif Nombre_Allumettes_Choisies <= 0 then
                            Put_Line("La prise doit comprendre au moins une allumette !");
                            Nombre_Allumettes_Valide := False;
                        elsif Nombre_Allumettes_Choisies > Nombre_Allumettes_Restantes and Nombre_Allumettes_Restantes = 1 then
                            Put_Line("Il reste une seule allumette.");
                            Nombre_Allumettes_Valide := False;
                        elsif Nombre_Allumettes_Choisies > Nombre_Allumettes_Restantes and Nombre_Allumettes_Restantes = 2 then
                            Put_Line("Il reste deux allumettes.");
                            Nombre_Allumettes_Valide := False;
			else
			    Nombre_Allumettes_Valide := True;
                        end if;
		    else
			Nombre_Allumettes_Valide := True;
		    end if;
                
             exit when Nombre_Allumettes_Valide;
	 end loop;
	
        -- Mettre à jour le nombre d'allumettes restantes.
        
            Nombre_Allumettes_Restantes := Nombre_Allumettes_Restantes - Nombre_Allumettes_Choisies;
	
        Utilisateur_Va_Jouer := not(Utilisateur_Va_Jouer);
        
        exit when Nombre_Allumettes_Restantes = 0;
    end loop;

    -- Afficher le gagnant.
    
        if Utilisateur_Va_Jouer then
    	    New_Line;
	    Put_Line("Vous avez gagné !");
        else
            Put_Line("J'ai gagné !");
        end if;

end Allumettes;
