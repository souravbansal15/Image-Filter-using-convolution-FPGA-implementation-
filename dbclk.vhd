----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2019 02:53:45 PM
-- Design Name: 
-- Module Name: dbclk - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dbclk is
  Port (
  clk: in std_logic;
  in_sig: in std_logic;
  out_sig: out std_logic
   );
end dbclk;

architecture Behavioral of dbclk is
signal dbclk: std_logic:='0';
begin
process(clk)
        variable kcount : integer := 0;
        begin
        if(clk = '1' and clk'event) then
            kcount := kcount + 1;
            if(kcount=2500000) then
                dbclk <= not dbclk;
                kcount := 0;
            end if;
        end if;
        end process;
  
 process(dbclk)
   begin
   if(dbclk='1' and dbclk'event) then
       out_sig<=in_sig;
   end if;
   end process;


end Behavioral;
