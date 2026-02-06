library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity Timer is
    Port ( 
        clk_50MHz : in  STD_LOGIC;
        rst : in  STD_LOGIC;
        sel : in  STD_LOGIC_VECTOR (2 downto 0); 
        clk_out : out STD_LOGIC 
    );
end Timer;

architecture timer_arc of Timer is
    constant CLK_FREQ : integer := 50_000_000;
    signal clk_limit : integer range 0 to 400_000_000;
    signal counter : integer range 0 to 400_000_000 := 0;
    signal out_state  : std_logic := '0';

begin
    clk_limit <= (to_integer(unsigned(sel)) + 1) * CLK_FREQ;

    process(clk_50MHz, rst)
    begin
        if rst = '1' then
            counter <= 0;
            out_state <= '0';
        elsif rising_edge(clk_50MHz) then
            if counter >= clk_limit - 1 then
                counter <= 0;
                out_state <= not out_state;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    clk_out <= out_state;

end timer_arc;