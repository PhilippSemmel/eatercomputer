----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   alu_tb1
--
-- Authors      :   Philipp Semmel
-- Created      :   28.03.2023
-- Last update  :   31.03.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;

ENTITY alu_tb1 IS
END ENTITY alu_tb1;

ARCHITECTURE TESTBENCH OF alu_tb1 IS

    COMPONENT alu IS
        PORT(
            clk       : IN    std_ulogic;
            rst       : IN    std_ulogic;
            sub       : IN    std_ulogic;
            out_en    : IN    std_ulogic;
            flag_in   : IN    std_ulogic;
            data      : INOUT std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
            data_in_a : IN    std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
            data_in_b : IN    std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
            carry     : OUT   std_ulogic;
            zero      : OUT   std_ulogic
        );
    END COMPONENT alu;

    CONSTANT CLOCK_PERIOD    : time := 10 ns;
    CONSTANT SIMULATION_TIME : time := 21 * CLOCK_PERIOD;

    SIGNAL sim_done             : boolean;                            -- @suppress
    SIGNAL clk                  : std_ulogic;
    SIGNAL rst                  : std_ulogic;
    SIGNAL sub, out_en, flag_in : std_ulogic;
    SIGNAL carry, zero          : std_ulogic;                         --@suppress
    SIGNAL data_in_a, data_in_b : std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
    SIGNAL data                 : std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
    

BEGIN

    dut : COMPONENT alu
        PORT MAP(
            clk       => clk,
            rst       => rst,
            sub       => sub,
            out_en    => out_en,
            flag_in   => flag_in,
            data      => data,
            data_in_a => data_in_a,
            data_in_b => data_in_b,
            carry     => carry,
            zero      => zero
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

    rst_gen : PROCESS IS
    BEGIN
        rst <= '0';
        WAIT FOR 2 * CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR CLOCK_PERIOD;
        rst <= '0';
        WAIT FOR 6 * CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR CLOCK_PERIOD;
        rst <= '0';
        WAIT FOR 10 * CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR CLOCK_PERIOD;
        rst <= '0';
        WAIT;
    END PROCESS rst_gen;

    sub_gen : PROCESS IS
    BEGIN
        sub <= '0';
        WAIT FOR 13 * CLOCK_PERIOD;
        sub <= '1';
        WAIT FOR 7 * CLOCK_PERIOD;
        sub <= '0';
        WAIT;
    END PROCESS sub_gen;

    out_en_gen : PROCESS IS
    BEGIN
        out_en <= '0';
        WAIT FOR CLOCK_PERIOD;
        out_en <= '1';
        WAIT FOR 2 * CLOCK_PERIOD;
        out_en <= '0';
        WAIT FOR CLOCK_PERIOD;
        out_en <= '1';
        WAIT FOR 3 * CLOCK_PERIOD;
        out_en <= '0';
        WAIT FOR 2 * CLOCK_PERIOD;
        out_en <= '1';
        WAIT FOR 3 * CLOCK_PERIOD;
        out_en <= '0';
        WAIT FOR CLOCK_PERIOD;
        out_en <= '1';
        WAIT FOR 7 * CLOCK_PERIOD;
        out_en <= '0';
        WAIT;
    END PROCESS out_en_gen;

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

    data <= (OTHERS => 'L');

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
        WAIT FOR 3*CLOCK_PERIOD;
        data_in_b <= (OTHERS => '0');
        WAIT;
    END PROCESS data_in_b_gen;

END ARCHITECTURE TESTBENCH;
