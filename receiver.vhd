----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2019 01:20:05 PM
-- Design Name: 
-- Module Name: receiver - Behavioral
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

entity receiver is
 Port (
 rx_clk: in std_logic;
 rx_in: in std_logic;
 rx_full: out std_logic;
 rx_data: out std_logic_vector(7 downto 0)
  );
end receiver;
    


architecture Behavioral of receiver is
    type state_type is (idle, start, si);
    signal state: state_type := idle;
    signal start_count : integer:=0;
    signal bit_count : integer:=0;
    signal count16 : integer:=0;
    signal reg: std_logic_vector(7 downto 0) :="00000000";

begin
    process(rx_clk)
    variable c: integer :=0;
    begin
    
--    if(reset='1') then
--        rx_full<='1';
--        state<=idle;
   
--        reg<="00000000";
--        rx_reg<="00000000";
--        start_count <=0;
--    end if;
    if(rx_clk = '1' and rx_clk'event) then
      --  if(c=32) then
          --  rx_full<='0';
          --  else
           -- c:=c+1;
            --end if;
        case state is
        
            when idle=>
                if(rx_in='0') then
                    state<=start;
                    start_count<=0;
                end if;
                
            when start=>
                if(start_count=8) then 
                    rx_full<='0';
                    state<=si;
                    start_count<=0;
                     bit_count<=0;
                else
                    if(rx_in='0') then
                        start_count<=start_count+1;
                    else 
                        start_count<=0;
                        --rx_full<='1';
                        state<=idle;
                        bit_count<=0;
                    end if;
                end if;
            
            when si=>
                if(bit_count=8)then
                    reg (bit_count)<= rx_in;
                    
                    state<=idle;
                    bit_count<=0;
                    count16<=0;
                    rx_data<=reg;
                    rx_full<='1';--tx_start changes
                    c:=0;
                    
                else
                count16<=count16+1;
                    if(count16=15) then
                        reg (bit_count)<= rx_in;
                        bit_count<=bit_count+1;
                        count16<=0;
                    
                    end if;
                end if;
        end case;
    end if;
    end process;

end Behavioral;
