----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   Program Counter Testbench 1
--
-- Authors      :   Philipp Semmel
-- Created      :   20.02.2023
-- Last update  :   30.03.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;

ENTITY program_counter_tb1 IS
END ENTITY program_counter_tb1;

ARCHITECTURE TESTBENCH OF program_counter_tb1 IS

    COMPONENT program_counter
        PORT(
            clk      : IN    std_ulogic;
            rst      : IN    std_ulogic;
            load     : IN    std_ulogic;
            count_en : IN    std_ulogic;
            out_en   : IN    std_ulogic;
            count    : INOUT std_logic_vector(PROGRAMM_COUNTER_WORD_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT program_counter;

    CONSTANT CLOCK_PERIOD    : time := 10 ns;
    CONSTANT SIMULATION_TIME : time := 53 * CLOCK_PERIOD;

    SIGNAL sim_done               : boolean;                          -- @suppress
    SIGNAL clk                    : std_ulogic;
    SIGNAL rst                    : std_ulogic;
    SIGNAL load, count_en, out_en : std_ulogic;
    SIGNAL count                  : std_logic_vector(PROGRAMM_COUNTER_WORD_WIDTH - 1 DOWNTO 0);

BEGIN

    dut : COMPONENT program_counter
        PORT MAP(
            clk      => clk,
            rst      => rst,
            load     => load,
            count_en => count_en,
            out_en   => out_en,
            count    => count
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
        WAIT FOR 2 * CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR CLOCK_PERIOD;
        rst <= '0';
        WAIT FOR (PROGRAMM_COUNTER_MAX_VALUE + 3) * CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR 2 * CLOCK_PERIOD;
        rst <= '0';
        WAIT FOR 6 * CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR CLOCK_PERIOD;
        rst <= '0';
        WAIT;
    END PROCESS reset_gen;

    enable_gen : PROCESS IS
    BEGIN
        count_en <= '0';
        WAIT FOR 4 * CLOCK_PERIOD;
        count_en <= '1';
        WAIT FOR (PROGRAMM_COUNTER_MAX_VALUE + 6) * CLOCK_PERIOD;
        count_en <= '0';
        WAIT FOR 9 * CLOCK_PERIOD;
        count_en <= '1';
        WAIT FOR 4 * CLOCK_PERIOD;
        count_en <= '0';
        WAIT FOR CLOCK_PERIOD;
        count_en <= '1';
        WAIT FOR 4 * CLOCK_PERIOD;
        count_en <= '0';
        WAIT FOR 4 * CLOCK_PERIOD;
        count_en <= '1';
        WAIT FOR 4 * CLOCK_PERIOD;
        count_en <= '0';
        WAIT;
    END PROCESS enable_gen;

    load_gen : PROCESS IS
    BEGIN
        load <= '0';
        WAIT FOR (PROGRAMM_COUNTER_MAX_VALUE + 12) * CLOCK_PERIOD;
        load <= '1';
        WAIT FOR CLOCK_PERIOD;
        load <= '0';
        WAIT FOR 4 * CLOCK_PERIOD;
        load <= '1';
        WAIT FOR CLOCK_PERIOD;
        load <= '0';
        WAIT FOR 8 * CLOCK_PERIOD;
        load <= '1';
        WAIT FOR CLOCK_PERIOD;
        load <= '0';
        WAIT FOR 3 * CLOCK_PERIOD;
        load <= '1';
        WAIT FOR CLOCK_PERIOD;
        load <= '0';
        WAIT;
    END PROCESS load_gen;

    out_en_gen : PROCESS IS
    BEGIN
        out_en <= '1';
        WAIT FOR (PROGRAMM_COUNTER_MAX_VALUE + 11) * CLOCK_PERIOD;
        out_en <= '0';
        WAIT FOR 2 * CLOCK_PERIOD;
        out_en <= '1';
        WAIT FOR CLOCK_PERIOD;
        out_en <= '0';
        WAIT FOR CLOCK_PERIOD;
        out_en <= '1';
        WAIT FOR CLOCK_PERIOD;
        out_en <= '0';
        WAIT FOR 2 * CLOCK_PERIOD;
        out_en <= '1';
        WAIT FOR CLOCK_PERIOD;
        out_en <= '0';
        WAIT FOR 4 * CLOCK_PERIOD;
        out_en <= '1';
        WAIT FOR CLOCK_PERIOD;
        out_en <= '0';
        WAIT FOR 4 * CLOCK_PERIOD;
        out_en <= '1';
        WAIT FOR CLOCK_PERIOD;
        out_en <= '0';
        WAIT FOR CLOCK_PERIOD;
        out_en <= '1';
        WAIT FOR 5 * CLOCK_PERIOD;
        out_en <= '0';
        WAIT;
    END PROCESS out_en_gen;
    
    count <= (OTHERS => 'L');

    count_gen : PROCESS IS
    BEGIN
        count <= (OTHERS => 'Z');
        WAIT FOR (PROGRAMM_COUNTER_MAX_VALUE + 12) * CLOCK_PERIOD;
        count <= "1101";
        WAIT FOR CLOCK_PERIOD;
        count <= (OTHERS => 'Z');
        WAIT FOR 4 * CLOCK_PERIOD;
        count <= "1110";
        WAIT FOR CLOCK_PERIOD;
        count <= (OTHERS => 'Z');
        WAIT FOR 8 * CLOCK_PERIOD;
        count <= "1010";
        WAIT FOR CLOCK_PERIOD;
        count <= (OTHERS => 'Z');
        WAIT;
    END PROCESS count_gen;

END ARCHITECTURE TESTBENCH;
