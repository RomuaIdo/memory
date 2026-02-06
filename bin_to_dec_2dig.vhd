library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin_to_dec_2dig is
    Port ( 
        in_8bits : in  STD_LOGIC_VECTOR (7 downto 0);
        unity_display: out STD_LOGIC_VECTOR (6 downto 0);
        decimal_display : out STD_LOGIC_VECTOR (6 downto 0)
    );
end bin_to_dec_2dig;

architecture bin_to_dec_2dig_arc of bin_to_dec_2dig is
    signal integer_value : integer range 0 to 255;
    signal uni_digit    : integer range 0 to 9;
    signal dec_digit    : integer range 0 to 9;
	 
    function decodificar_7seg(digit : integer) return std_logic_vector is
    begin
        case digit is
            when 0 => return "1000000";
            when 1 => return "1111001";
            when 2 => return "0100100";
            when 3 => return "0110000";
            when 4 => return "0011001";
            when 5 => return "0010010";
            when 6 => return "0000010";
            when 7 => return "1111000";
            when 8 => return "0000000";
            when 9 => return "0010000";
            when others => return "1111111";
        end case;
    end function;

begin
    integer_value <= to_integer(unsigned(in_8bits));
    uni_digit <= integer_value mod 10;
    dec_digit <= (integer_value / 10) mod 10; 

    unity_display <= decodificar_7seg(uni_digit);
    decimal_display  <= decodificar_7seg(dec_digit);

end bin_to_dec_2dig_arc;