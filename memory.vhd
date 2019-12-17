library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory is
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC;
    addra : IN integer;
    dina : IN integer;
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN integer;
    mode :IN std_logic;
    --tran_start: out std_logic;
    doutb : OUT integer:=0
  );
end memory;

architecture Behavioral of memory is
    signal r: integer;
    signal c: integer;
    signal convoluted: integer:=0;
	type Memory_type is array (0 to 255) of integer range 0 to 255;
	signal Memory_array : Memory_type;
	signal t : integer:=0;
	signal con : std_logic:='0';
	signal ans: integer:=0;
begin
    r<=Memory_array(1);
    c<=Memory_array(2);
	process (clkb)
	begin
    if rising_edge(clkb) then    
        if (enb = '1') then
            t <= addrb;
            ans<=0;
            con<='1';
            
            --doutb <= std_logic_vector(to_unsigned(Memory_array (t),8)); 
        end if;
    end if;
    end process;
	convoluted<=((Memory_array (t)+Memory_array (t+2)+Memory_array (t+2*c)+Memory_array (t+2*c+2))/16+(Memory_array (t+1)+Memory_array (t+c)+Memory_array (t+c+2)+Memory_array (t+1+2*c))/16*2+(Memory_array (t+c+1))/16*4) when (mode='1') else
	       ((Memory_array (t)+Memory_array (t+2)+Memory_array (t+2*c)+Memory_array (t+2*c+2))/9*(-1)+(Memory_array (t+1)+Memory_array (t+c)+Memory_array (t+c+2)+Memory_array (t+1+2*c))/9*(-1)+(Memory_array (t+c+1))/9*17);
	
	doutb<=convoluted when (convoluted>0 and convoluted<256) else 
	       1 when convoluted<=0 else
	        255;
--	process(con)
--	variable c:integer:=0;
--	begin
--	for i in 0 to 2 loop
--	   for j in 0 to 2 loop
--	       c:=c+Memory_array (t+i*c+j);
--	   end loop;
--	end loop;
--	ans<=c/16;
--	end process;
	
	
	process (clka)
	begin
		if rising_edge(clka) then	
			if (wea = '1') then
				Memory_array (addra) <= dina;	
			end if;
		end if;
	end process;
end Behavioral;