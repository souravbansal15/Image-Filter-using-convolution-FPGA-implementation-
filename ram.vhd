LIBRARY ieee;
USE ieee.std_logic_1164.all;		
USE ieee.std_logic_arith.all;
 
entity ram is 	  
  generic ( w : integer := 32; 
              -- number of bits per RAM word
            r : integer := 102); 
              -- 2^r = number of words in RAM 
  port (clk : in std_logic;  
        we  : in std_logic;
        en  : in std_logic;      
        addr   : in integer;   
        di  : in integer;   
        do  : out integer);   
end ram;
 		 		   
architecture behavioral of ram is   
  type ram_type is array (2**r-1 downto 0) of integer;   
  signal RAM : ram_type;	 

begin   
  process (clk)   
  begin   
    if (clk'event and clk = '1') then   
      if (en = '1') then 
        do <= RAM(addr);
        if (we = '1') then   
           RAM(addr) <= di;
        end if; 
      end if;  						
    end if;   
  end process;    
end behavioral;