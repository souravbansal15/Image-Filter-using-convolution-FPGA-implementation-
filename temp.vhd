----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2019 03:03:32 PM
-- Design Name: 
-- Module Name: temp - Behavioral
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
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.Std_Logic_Arith;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity temp is
Port (
    txstartt: in std_logic;
    reset: in std_logic;
    clk: in std_logic;
    rx_in: in std_logic;
    mode_change: in std_logic;
    tx_out: out std_logic;
    rx_regout: out std_logic_vector(7 downto 0);
    tx_dataout: out std_logic_vector(7 downto 0)
);
end temp;

architecture Behavioral of temp is
   signal rx_clk: std_logic :='0';--9600*16 Hz
   signal tx_clk: std_logic :='0';--9600 Hz
   signal timing_tx_start: std_logic :='0';
   signal start_count : integer:=0;
   signal count16 : integer:=0;
   signal bit_count : integer:=0;
   signal tx_data: integer:=0;
   signal rx_reg: std_logic_vector(7 downto 0);
   signal Id_tx: std_logic :='0';
   signal rx_full: std_logic :='1';
   signal tx_empty: std_logic :='1';
   signal rd_addr: integer:=0;
   signal wr_addr1: integer:=0;
   signal integer_in: integer:=0;
   signal wen: std_logic :='0';
   signal wen1: std_logic :='0';
   signal height: integer:=0;
   signal width: integer:=0;
   signal tx_int: integer:=0;
   signal address_ram: integer:=0;
   type filestate_type is ( s1, s2, s5, s6, s7, s8);
        signal filestate: filestate_type;
begin
    receiver_clock : entity work.rx_clk(Behavioral)
        PORT MAP(clk,rx_clk);
    transmitter_clock : entity work.tx_clk(Behavioral)
        PORT MAP(clk,tx_clk);
    memory : entity work.memory(Behavioral)
        PORT MAP(tx_clk,wen1, wr_addr1,integer_in,tx_clk,Id_tx,rd_addr,mode_change,tx_data);
    debounce : entity work.dbclk(Behavioral)
        PORT MAP(clk,txstartt,timing_tx_start);
    receiver : entity work.receiver(Behavioral)
        PORT MAP(rx_clk,rx_in,rx_full,rx_reg);
    transmitter : entity work.transmitter(Behavioral)
        PORT MAP(tx_clk,Id_tx,tx_data,tx_out,tx_empty);
    chartoint : entity work.CharToInt(Behavioral)
        PORT MAP(tx_clk,rx_full,rx_reg,wen1,wr_addr1,integer_in,height,width);
--    RAM : entity work.ram(Behavioral)
--        PORT MAP(tx_clk,wen1,Id_tx,address_ram,integer_in,tx_int);
rx_regout<=rx_reg;
tx_dataout<=std_logic_vector(to_unsigned(tx_data,8));
--if(wen1=1) then
--    address_ram<=wr_addr1;
--end if;
--address_ram<=wr_addr1 when wen='1' else rd_addr;

 --Timing circuit
    process(tx_clk,reset,timing_tx_start)--9600 Hz
    
    begin
    if(reset='1') then
                    filestate<=s1;
                    else if(tx_clk='1' and tx_clk'event) then
            
            case filestate is
            when s1=>
                filestate<=s2;
            when s2=>
                if(timing_tx_start='1') then
                    filestate<=s5;
                    rd_addr<=2;--addded
                    end if;
            when s5=>
                Id_tx<='1';--added
                if((rd_addr) mod width = 0) then
                    rd_addr<=rd_addr+3;
                    else
                    rd_addr<=rd_addr+1;
                    end if;
                filestate<=s6;
            when s6=>
                --Id_tx<='1';--ID_T-X
                Id_tx<='0';--added
                --rd_addr<=rd_addr+1;
                filestate<=s7;
            when s7=>
                if(tx_empty='0') then
                    filestate<=s7;
                    else
                        if(rd_addr>=wr_addr1-3-2*width) then
                        filestate<=s8;
                        else
                        Id_tx<='1';
                        if((rd_addr) mod width = 0) then
                            rd_addr<=rd_addr+3;
                            else
                            rd_addr<=rd_addr+1;
                            end if;
                        filestate<=s6;
                        end if;
                    end if;
            when s8=>
                if(timing_tx_start='1') then 
                    filestate<=s8;
                    else
                    filestate<=s2;
                    wen<='0';--added
                    end if;
            end case;
            end if;
            end if;
    end process;
end Behavioral;
