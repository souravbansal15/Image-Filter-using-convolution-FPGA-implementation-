----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2019 03:59:35 PM
-- Design Name: 
-- Module Name: CharToInt - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use ieee.Std_Logic_Arith;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CharToInt is
   Port (
    clk: in std_logic;
    rx_full: in std_logic;
    rx_data: in std_logic_vector(7 downto 0);
    wen1: out std_logic;
    wr_addr1: out integer;
    integer_in: out integer:=0;
    height: out integer;
    width: out integer
   );
end CharToInt;

architecture Behavioral of CharToInt is
signal int : integer:=0;
signal pixel: integer :=0;
signal done: std_logic:='0';
signal addra : integer:=0;
signal count : integer:=0;
--signal a : integer:=0;
--signal b : integer:=0;
type type_state is ( s1, s2, s3);
        signal state: type_state:=s1;
signal new_rx_data: std_logic_vector(0 to 7) :="00000000";
begin
--    new_rx_data(0)<=rx_data(7);
--    new_rx_data(1)<=rx_data(6);
--    new_rx_data(2)<=rx_data(5);
--    new_rx_data(3)<=rx_data(4);
--    new_rx_data(4)<=rx_data(3);
--    new_rx_data(5)<=rx_data(2);
--    new_rx_data(6)<=rx_data(1);
--    new_rx_data(7)<=rx_data(0);
    int<=to_integer(unsigned(rx_data));
    wr_addr1<=addra;
    process(clk)
    
    begin
        if(clk = '1' and clk'event) then--tx_clk is clk
            wen1<='0';
            case state is
            when s1=>
                if(rx_full='1') then
                    state<=s2;
                    end if;
             when s2=>
                if int>=48 and int<58 then
                    pixel<=pixel*10+int-48;
                    else
                    integer_in<=pixel;
                    pixel<=0;
                    count<=count+1;
                    if(count=0) then
                        height<=pixel;
                    end if;
                    if(count=1) then
                        width<=pixel;
                    end if;   
                    addra<=addra+1;
                    wen1<='1';
                    end if;
                    state<=s3;
              when s3=>
                 if(rx_full='0') then
                 state<=s1;
                 end if;
             end case;
             end if;
    end process;


end Behavioral;
