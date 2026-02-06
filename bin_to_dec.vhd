library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bin_to_dec is
    Port ( 
        input : in  STD_LOGIC_VECTOR (2 downto 0); 
        display : out STD_LOGIC_VECTOR (6 downto 0) 
    );
end bin_to_dec;

architecture bin_to_dec_arc of bin_to_dec is
begin

    process(input)
    begin
        case input is
            when "000" => display <= "1000000"; -- Mostra 0
            when "001" => display <= "1111001"; -- Mostra 1
            when "010" => display <= "0100100"; -- Mostra 2
            when "011" => display <= "0110000"; -- Mostra 3
            when "100" => display <= "0011001"; -- Mostra 4
            when "101" => display <= "0010010"; -- Mostra 5
            when "110" => display <= "0000010"; -- Mostra 6
            when "111" => display <= "1111000"; -- Mostra 7
            
            when others => display <= "1111111"; 
        end case;
    end process;

end bin_to_dec_arc;