----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   generic_register Testbench 2
--
-- Authors      :   Philipp Semmel
-- Created      :   21.03.2023
-- Last update  :   28.03.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;

ENTITY generic_register_tb2 IS
END ENTITY generic_register_tb2;

ARCHITECTURE TESTBENCH OF generic_register_tb2 IS

    COMPONENT generic_register
        GENERIC(
            WORD_WIDTH : natural
        );
        PORT(
            clk      : IN  std_ulogic;
            rst      : IN  std_ulogic;
            data_in  : IN  std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0);
            load     : IN  std_ulogic;
            data_out : OUT std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT generic_register;

    CONSTANT CLOCK_PERIOD    : time    := 10 ns;
    CONSTANT SIMULATION_TIME : time    := 100 * CLOCK_PERIOD;
    CONSTANT WORD_WIDTH      : natural := 2;

    SIGNAL sim_done                    : boolean;                     -- @suppress
    SIGNAL clk                         : std_ulogic;
    SIGNAL rst                         : std_ulogic;
    SIGNAL flag_in                     : std_ulogic;
    SIGNAL carry_flag_in, zero_flag_in : std_ulogic;
    SIGNAL carry, zero                 : std_ulogic;                  -- @suppress
    SIGNAL data_in, flag_out           : std_ulogic_vector(1 DOWNTO 0); -- @suppress
    SIGNAL a, b, sum                   : unsigned(DATA_WORD_WIDTH DOWNTO 0);
    SIGNAL data_in_a, data_in_b        : std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);

BEGIN

    -- input wiring
    a <= resize(unsigned(data_in_a), DATA_WORD_WIDTH + 1);
    b <= resize(unsigned(data_in_b), DATA_WORD_WIDTH + 1);

    -- calc
    sum           <= a - b WHEN sub = '1' ELSE a + b;
    carry_flag_in <= sum(DATA_WORD_WIDTH);
    zero_flag_in  <= '1' WHEN is_all(sum(7 DOWNTO 0), '0') ELSE '0';
    data_in       <= (0 => carry_flag_in, 1 => zero_flag_in);

    flag_reg : COMPONENT generic_register
        GENERIC MAP(
            WORD_WIDTH => WORD_WIDTH
        )
        PORT MAP(
            clk      => clk,
            rst      => rst,
            data_in  => data_in,
            load     => flag_in,
            data_out => flag_out
        );

    -- output wiring
    carry <= flag_out(0);
    zero  <= flag_out(1);

    sim_done_gen : PROCESS IS
    BEGIN
        sim_done <= false;
        WAIT FOR SIMULATION_TIME;
        sim_done <= true;
        WAIT;
    END PROCESS sim_done_gen;

    clock_gen : PROCESS IS
    BEGIN
        clk <= '1';
        WAIT FOR CLOCK_PERIOD / 2;
        clk <= '0';
        WAIT FOR CLOCK_PERIOD / 2;
        IF sim_done THEN
            WAIT;
        END IF;
    END PROCESS clock_gen;

    reset_gen : PROCESS IS
    BEGIN
        rst <= '0';
        WAIT FOR CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR CLOCK_PERIOD;
        rst <= '0';
        WAIT FOR 4.5 * CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR 0.5 * CLOCK_PERIOD;
        rst <= '0';
        WAIT FOR 3 * CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR CLOCK_PERIOD;
        rst <= '0';
        WAIT;
    END PROCESS reset_gen;

    flag_in_gen : PROCESS IS
    BEGIN
        flag_in <= '0';
        WAIT FOR 4 * CLOCK_PERIOD;
        flag_in <= '1';
        WAIT FOR 4 * CLOCK_PERIOD;
        flag_in <= '0';
        WAIT FOR 5 * CLOCK_PERIOD;
        flag_in <= '1';
        WAIT FOR 6 * CLOCK_PERIOD;
        flag_in <= '0';
        WAIT;
    END PROCESS flag_in_gen;

    data_in_a_gen : PROCESS IS
    BEGIN
        data_in_a <= (OTHERS => '0');
        WAIT FOR 4 * CLOCK_PERIOD;
        data_in_a <= "01001010";
        WAIT FOR 5 * CLOCK_PERIOD;
        data_in_a <= (OTHERS => 'L');
        WAIT FOR 6 * CLOCK_PERIOD;
        data_in_a <= "01110101";
        WAIT FOR 5 * CLOCK_PERIOD;
        data_in_a <= (OTHERS => '0');
        WAIT;
    END PROCESS data_in_a_gen;

    data_in_b_gen : PROCESS IS
    BEGIN
        data_in_b <= (OTHERS => '0');
        WAIT FOR 5 * CLOCK_PERIOD;
        data_in_b <= "00101100";
        WAIT FOR CLOCK_PERIOD;
        data_in_b <= "11101100";
        WAIT FOR 4 * CLOCK_PERIOD;
        data_in_b <= (OTHERS => 'L');
        WAIT FOR 5 * CLOCK_PERIOD;
        data_in_b <= "00011101";
        WAIT FOR CLOCK_PERIOD;
        data_in_b <= "01110101";
        WAIT FOR CLOCK_PERIOD;
        data_in_b <= (OTHERS => '1');
        WAIT FOR 3 * CLOCK_PERIOD;
        data_in_b <= (OTHERS => '0');
        WAIT;
    END PROCESS data_in_b_gen;

END ARCHITECTURE TESTBENCH;
