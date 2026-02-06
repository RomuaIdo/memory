library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Game_Controller is
    Port (
        clk_50MHz : in std_logic;
        reset : in std_logic;
        
        confirm_btn : in std_logic;
        input_sw : in std_logic_vector(9 downto 0);
        rand_num_in : in std_logic_vector(9 downto 0); 
        timer_tick : in std_logic;
        

        timer_rst_out : out std_logic;
        leds_out : out std_logic_vector(9 downto 0);
        
        score_out : out integer range 0 to 255;
        lives_out : out integer range 0 to 3;
        speed_out : out integer range 0 to 7
    );
end Game_Controller;

architecture Game_Controller_arc of Game_Controller is

    type State_Type is (START, GEN_PATTERN, SHOW_LEDS, WAIT_INPUT, CHECK_RESULT, GAME_OVER);
    signal current_state : State_Type := START;


    signal target_pattern : std_logic_vector(9 downto 0) := (others => '0');
    signal score : integer range 0 to 255 := 0;
    signal lives : integer range 0 to 3 := 3;
    signal speed_level : integer range 0 to 7 := 0;
    signal correct_streak : integer range 0 to 3 := 0;


    signal confirm_last : std_logic := '0';
    signal timer_last : std_logic := '0';
    signal timer_expired : std_logic := '0';
    signal confirm_pulse : std_logic := '0';

begin

    score_out <= score;
    lives_out <= lives;
    speed_out <= speed_level;

    process(clk_50MHz, reset)
    begin
        if reset = '0' then
            current_state <= START;
            score <= 0;
            lives <= 3;
            speed_level <= 0;
            correct_streak <= 0;
            leds_out <= (others => '0');
            timer_rst_out <= '1';
            
        elsif rising_edge(clk_50MHz) then
            
            confirm_pulse <= '0';
            if confirm_btn = '0' and confirm_last = '1' then
                confirm_pulse <= '1';
            end if;
            confirm_last <= confirm_btn;

            timer_expired <= '0';
            if timer_tick /= timer_last then
                timer_expired <= '1';
            end if;
            timer_last <= timer_tick;

            case current_state is
                
                when START =>
                    lives <= 3;
                    score <= 0;
                    speed_level <= 0;
                    correct_streak <= 0;
                    current_state <= GEN_PATTERN;

                when GEN_PATTERN =>
                    target_pattern <= rand_num_in;
                    timer_rst_out <= '1';
                    current_state <= SHOW_LEDS;

                when SHOW_LEDS =>
                    timer_rst_out <= '0';
                    leds_out <= target_pattern;
                    
                    if timer_expired = '1' then
                        current_state <= WAIT_INPUT;
                    end if;

                when WAIT_INPUT =>
                    leds_out <= input_sw;
                    timer_rst_out <= '1'; 
                    
                    if confirm_pulse = '1' then
                        current_state <= CHECK_RESULT;
                    end if;

                when CHECK_RESULT =>
                    if input_sw = target_pattern then
                        if score < 99 then 
                            score <= score + (speed_level + 1);
                        end if;

                        if correct_streak = 2 then
                            correct_streak <= 0;
                            if speed_level < 7 then
                                speed_level <= speed_level + 1;
                            end if;
                        else
                            correct_streak <= correct_streak + 1;
                        end if;
                        current_state <= GEN_PATTERN;
                    else
                        correct_streak <= 0;
                        if lives > 0 then
                            lives <= lives - 1;
                            if lives = 1 then 
                                current_state <= GAME_OVER;
                            else
                                current_state <= GEN_PATTERN;
                            end if;
                        else
                            current_state <= GAME_OVER;
                        end if;
                    end if;

                when GAME_OVER =>
                    current_state <= START;

                when others =>
                    current_state <= START;
            end case;
        end if;
    end process;

end Game_Controller_arc;