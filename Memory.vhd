library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Memory is
    Port(
        clk_50MHz : in std_logic;
        reset : in std_logic;
        confirm : in std_logic;
        input : in std_logic_vector(9 downto 0);
        
        scorehex : out std_logic_vector(13 downto 0);
        velocityhex : out std_logic_vector(6 downto 0);
        lifeshex : out std_logic_vector(6 downto 0);
        leds_out : out std_logic_vector(9 downto 0)
    );
end Memory;

architecture Memory_arc of Memory is
    component Game_Controller is
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
    end component;

    component Timer is
        Port ( 
            clk_50MHz : in  STD_LOGIC;
            rst : in STD_LOGIC;
            sel : in STD_LOGIC_VECTOR (2 downto 0); 
            clk_out : out STD_LOGIC 
        );
    end component;

    component leds is
        Port(
            clk_50mhz : in std_logic;
            led_out : out std_logic_vector(9 downto 0)
        );
    end component;

    component bin_to_dec is
        Port ( 
            input : in STD_LOGIC_VECTOR (2 downto 0); 
            display : out STD_LOGIC_VECTOR (6 downto 0) 
        );
    end component;

    component bin_to_dec_2dig is
        Port ( 
            in_8bits : in STD_LOGIC_VECTOR (7 downto 0);
            unity_display : out STD_LOGIC_VECTOR (6 downto 0);
            decimal_display : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

 
    signal rand_data : std_logic_vector(9 downto 0);
    signal timer_tick : std_logic;
    signal timer_rst_ctrl : std_logic;
    
    signal score_int : integer range 0 to 255;
    signal lives_int : integer range 0 to 3;
    signal speed_int : integer range 0 to 7;
    
    signal timer_sel_vec : std_logic_vector(2 downto 0);
    signal lives_vec : std_logic_vector(2 downto 0);
    signal velocity_vec : std_logic_vector(2 downto 0);
    signal score_vec : std_logic_vector(7 downto 0);

begin


    timer_sel_vec <= std_logic_vector(to_unsigned(7 - speed_int, 3));

    lives_vec <= std_logic_vector(to_unsigned(lives_int, 3));
    velocity_vec <= std_logic_vector(to_unsigned(speed_int + 1, 3)); 
    score_vec <= std_logic_vector(to_unsigned(score_int, 8));


    U_CONTROLLER: Game_Controller port map (
        clk_50MHz => clk_50MHz,
        reset => reset,
        confirm_btn => confirm,
        input_sw => input,
        rand_num_in => rand_data,
        timer_tick => timer_tick,
        timer_rst_out => timer_rst_ctrl,
        leds_out => leds_out,
        score_out => score_int,
        lives_out => lives_int,
        speed_out => speed_int
    );

    U_PRNG: leds port map (
        clk_50mhz => clk_50MHz,
        led_out => rand_data
    );

    U_TIMER: Timer port map (
        clk_50MHz => clk_50MHz,
        rst => timer_rst_ctrl,
        sel => timer_sel_vec,
        clk_out => timer_tick
    );

    U_DISP_LIVES: bin_to_dec port map (
        input => lives_vec,
        display => lifeshex
    );

    U_DISP_VEL: bin_to_dec port map (
        input => velocity_vec,
        display => velocityhex
    );

    U_DISP_SCORE: bin_to_dec_2dig port map (
        in_8bits => score_vec,
        unity_display => scorehex(6 downto 0),
        decimal_display => scorehex(13 downto 7)
    );

end Memory_arc;