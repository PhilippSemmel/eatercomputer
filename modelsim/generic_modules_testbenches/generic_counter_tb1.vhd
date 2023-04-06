----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   GenericPresettableCounter_TB1
--
-- Authors      :   Philipp Semmel
-- Created      :   21.02.2023
-- Last update  :   28.03.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY generic_counter_tb1 IS
END ENTITY generic_counter_tb1;

ARCHITECTURE TESTBENCH OF generic_counter_tb1 IS

    COMPONENT generic_counter
        GENERIC(
            COUNT_MAX : natural
        );
        PORT(
            clk       : IN     std_ulogic;
            rst       : IN     std_ulogic;
            count_en  : IN     std_ulogic;
            load      : IN     std_ulogic;
            count_in  : IN     unsigned(integer(ceil(log2(real(COUNT_MAX)))) - 1 DOWNTO 0);
            count_out : BUFFER unsigned(integer(ceil(log2(real(COUNT_MAX)))) - 1 DOWNTO 0);
            overflow  : OUT    std_ulogic
        );
    END COMPONENT generic_counter;

    CONSTANT CLOCK_PERIOD    : time    := 10 ns;
    CONSTANT SIMULATION_TIME : time    := 40 * CLOCK_PERIOD;
    CONSTANT COUNT_MAX       : integer := 5;
    CONSTANT CNT_LEN         : natural := integer(ceil(log2(real(COUNT_MAX))));

    SIGNAL sim_done            : boolean;                             -- @suppress
    SIGNAL clk                 : std_ulogic;
    SIGNAL rst, count_en, load : std_ulogic;
    SIGNAL overflow            : std_ulogic;                          -- @suppress
    SIGNAL count_in, count_out : unsigned(CNT_LEN - 1 DOWNTO 0);      -- @suppress

BEGIN

    dut : COMPONENT generic_counter
        GENERIC MAP(
            COUNT_MAX => COUNT_MAX
        )
        PORT MAP(
            clk       => clk,
            rst       => rst,
            count_en  => count_en,
            load      => load,
            count_in  => count_in,
            count_out => count_out,
            overflow  => overflow
        );

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
        WAIT FOR 13 ns;
        rst <= '1';
        WAIT FOR 12 ns;
        rst <= '0';
        WAIT FOR 14 * CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR 23 ns;
        rst <= '0';
        WAIT FOR 2 * CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR 15 ns;
        rst <= '0';
        WAIT FOR 17 ns;
        WAIT FOR 8 * CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR CLOCK_PERIOD;
        rst <= '0';
        WAIT FOR 5 * CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR CLOCK_PERIOD;
        rst <= '0';
        WAIT;
    END PROCESS reset_gen;

    enable_gen : PROCESS IS
    BEGIN
        count_en <= '0';
        WAIT FOR 43 ns;
        count_en <= '1';
        WAIT FOR 12 * CLOCK_PERIOD;
        count_en <= '0';
        WAIT FOR 17 ns;
        WAIT FOR 2 * CLOCK_PERIOD;
        count_en <= '1';
        WAIT FOR 10 * CLOCK_PERIOD;
        count_en <= '0';
        WAIT FOR 3 * CLOCK_PERIOD;
        count_en <= '1';
        WAIT FOR 3 * CLOCK_PERIOD;
        count_en <= '0';
        WAIT;
    END PROCESS enable_gen;

    load_gen : PROCESS IS
    BEGIN
        load <= '0';
        WAIT FOR 29 * CLOCK_PERIOD;
        load <= '1';
        WAIT FOR CLOCK_PERIOD;
        load <= '0';
        WAIT FOR CLOCK_PERIOD;
        load <= '1';
        WAIT FOR CLOCK_PERIOD;
        load <= '0';
        WAIT FOR 2 * CLOCK_PERIOD;
        load <= '1';
        WAIT FOR CLOCK_PERIOD;
        load <= '0';
        WAIT;
    END PROCESS load_gen;

    count_in_gen : PROCESS IS
    BEGIN
        count_in <= to_unsigned(0, CNT_LEN);
        WAIT FOR 29 * CLOCK_PERIOD;
        count_in <= to_unsigned(3, CNT_LEN);
        WAIT FOR CLOCK_PERIOD;
        count_in <= to_unsigned(1, CNT_LEN);
        WAIT FOR 4 * CLOCK_PERIOD;
        count_in <= to_unsigned(2, CNT_LEN);
        WAIT;
    END PROCESS count_in_gen;

END ARCHITECTURE TESTBENCH; 