library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity leds is
	Port(
		clk_50mhz : in std_logic;
		led_out : out std_logic_vector(9 downto 0)
	);
end leds;

architecture rtl of leds is
	signal bit_counter : unsigned(9 downto 0) := (others => '0');
	
	begin
	process(clk_50mhz)
	begin
		if rising_edge(clk_50mhz) then
			bit_counter <= bit_counter + 1;
		end if;
	end process;
	led_out <= std_logic_vector(bit_counter);
end rtl;