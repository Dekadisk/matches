with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;
with Alea;

--------------------------------------------------------------------------------
--  Author   : Dekadisk
--------------------------------------------------------------------------------

procedure Matches is
    
    NB_INIT_MATCHES : CONSTANT Integer := 13;
    MX_MATCHES_PER_TURN : CONSTANT Integer := 3;
    NB_LINES : CONSTANT Integer := 3; 
    BLOCK_COLUMNS : CONSTANT Integer := 5;
  
    package Alea_1_max is
            new Alea (1, MX_MATCHES_PER_TURN);
    use Alea_1_max;

    User_Will_Play : Boolean;
    PC_Level : Character;
    Joueur_Commence : Character;
    Nombre_Allumettes_Restantes : Integer := NB_INIT_MATCHES;
    Nombre_Allumettes_Choisies : Integer;
    Nombre_Allumettes_Valide : Boolean;

begin

   -- Saisir de façon conviviale le niveau de l'ordinateur.
    
       Put("Niveau de l'ordinateur (n)aïf, (d)istrait, (r)apide ou (e)xpert ? ");
       Get(PC_Level);
    
       -- Afficher le niveau de l'ordinateur.
            
           case PC_Level is
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
            User_Will_Play := True;
        else
            User_Will_Play := False;
        end if;

    -- Faire se dérouler le jeu.
    
        loop
        
        -- Afficher les allumettes sous forme de bâtons.
        
            for Rangee in 1..NB_LINES loop
                New_Line;
                for i in 1..Nombre_Allumettes_Restantes loop
                    Put("|");
                    if i mod BLOCK_COLUMNS = 0 then
                        Put(" ");
                    end if;
                end loop;
            end loop;
            New_Line;
            New_Line;
            
	-- Faire choisir le joueur suivant.

	    loop
    
                if not(User_Will_Play) then
	
                -- Faire choisir l'ordinateur.
                    case PC_Level is
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
                            if Nombre_Allumettes_Restantes < MX_MATCHES_PER_TURN then
                                Nombre_Allumettes_Choisies := Nombre_Allumettes_Restantes;
                            else
                                Nombre_Allumettes_Choisies := MX_MATCHES_PER_TURN;
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
            
	            if PC_Level = 'd' or PC_Level = 'D' or User_Will_Play then
                        if Nombre_Allumettes_Choisies > MX_MATCHES_PER_TURN then
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
	
        User_Will_Play := not(User_Will_Play);
        
        exit when Nombre_Allumettes_Restantes = 0;
    end loop;

    -- Afficher le gagnant.
    
        if User_Will_Play then
    	    New_Line;
	    Put_Line("Vous avez gagné !");
        else
            Put_Line("J'ai gagné !");
        end if;

end Allumettes;
