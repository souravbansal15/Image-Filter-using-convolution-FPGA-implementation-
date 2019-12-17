----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2019 02:19:23 PM
-- Design Name: 
-- Module Name: tx_clk - Behavioral
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

entity tx_clk is
 Port ( clk: in std_logic :='0';
       out_clk: out std_logic
);
end tx_clk;

architecture Behavioral of tx_clk is
-- 9600*16 generation of clock
signal clk_sig:std_logic:='0';
begin

process(clk)
    variable count : integer := 0;
    begin
        if(clk = '1' and clk'event) then
            count := count + 1;
        if(count=5208) then
            clk_sig <= not clk_sig;
            count := 0;
            end if;
        end if;
end process;
out_clk<=clk_sig;
end Behavioral;
