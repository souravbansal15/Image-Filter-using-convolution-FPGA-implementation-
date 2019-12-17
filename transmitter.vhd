----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:55:09 10/10/2019 
-- Design Name: 
-- Module Name:    transmitter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.Std_Logic_Arith;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--entity transmitter is
--end transmitter;

--architecture Behavioral of transmitter is

--begin


--end Behavioral;

entity transmitter is
  port(
  tx_clk : in std_logic;
  ld_tx : in std_logic;
  tx_data_in : in integer;
  tx_out : out std_logic;
  tx_empty : out std_logic
  );
end transmitter;

architecture Behavioral of transmitter is
  type state_type is(idle,p1,p2,p3,p4,start,s0,s1,s2,s3,s4,s5,s6,s7);
  signal state : state_type:=idle;
  signal num : integer:= 5;
  signal tx_data:std_logic_vector(7 downto 0):="00100000";
  signal c1:integer:=0;
  signal div:integer:=100;
  signal digit:integer:=6;
  signal check:std_logic:='0';
  signal check2:std_logic:='0';
  signal count: integer:=0;
  begin
    process(tx_clk)
    
    begin
    if(rising_edge(tx_clk)) then
        case state is
        when p3=>
        --if(count=10) then
            --count<=0;
            state<= p1;
            num<=tx_data_in;
            --else
            --state<=p3;
            --count<=count+1;
            --end if;
          when idle =>
          if(ld_tx='1') then
            --state <= start;
           -- num<=tx_data_in;
            div<=100;
            c1<=0;
            state <= p3;
            check<='0';
            check2<='0';
				tx_empty <= '0';
				
          else
            state <= idle;
				tx_out <= '1';
          end if;
          when p1=>
            div<=div/10;
            c1<=c1+1;
            digit<=num/div;
            num<=num mod div;
            state<=p2;
          when p2=>
            if((digit>0 and digit<10) or check='1') then
            check<='1';
               state<=start;
               tx_out <= '0';
               tx_data<=std_logic_vector(to_unsigned(digit+48,8));
               else
               state<=p1;
               end if;
          when start =>
				tx_out <= tx_data(0);
          state <= s0;
          when s0 =>
          state <= s1;
				tx_out <= tx_data(1);
          when s1 =>
          state <= s2;
				tx_out <= tx_data(2);
          when s2 =>
          state <= s3;
				tx_out <= tx_data(3);
          when s3 =>
          state <= s4;
				tx_out <= tx_data(4);
          when s4 =>
          state <= s5;
				tx_out <= tx_data(5);
          when s5 =>
          state <= s6;
				tx_out <= tx_data(6);
          when s6 =>
          state <= s7;
				tx_out <= tx_data(7);
          when s7 =>
          
				tx_out <= '1';
				if(c1>=3 and check2='1') then
				     state <= idle;
			         tx_empty <= '1';
			         c1<=0;
			         div<=100;
			         check<='0';
			         check2<='0';--new
			    elsif(c1>=3 and check2='0') then
			         state<=start;
                     tx_out <= '0';
                     check2<='1';
                     tx_data<=std_logic_vector(to_unsigned(9,8));
			         else
			         state<=p1;
			         
			    end if;
		  when p4=>
		      
        end case;
      end if;
    end process;
end architecture Behavioral;