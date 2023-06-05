----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   processor_tb1
--
-- Authors      :   Philipp Semmel
-- Created      :   02.05.20231
-- Last update  :   02.05.20231
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;

ENTITY processor_tb1 IS
END ENTITY processor_tb1;

ARCHITECTURE TESTBENCH OF processor_tb1 IS

    COMPONENT processor
        PORT(
            clk          : IN    std_ulogic;
            rst          : IN    std_ulogic;
            load_reg_a   : IN    std_ulogic;
            out_en_reg_a : IN    std_ulogic;
            load_reg_b   : IN    std_ulogic;
            sub          : IN    std_ulogic;
            out_en_alu   : IN    std_ulogic;
            flag_in      : IN    std_ulogic;
            carry        : OUT   std_ulogic;
            zero         : OUT   std_ulogic;
            data_reg_a   : INOUT std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
            data_reg_b   : INOUT std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
            data_alu     : INOUT std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT processor;

    CONSTANT CLOCK_PERIOD    : time := 10 ns;
    CONSTANT SIMULATION_TIME : time := 100 * CLOCK_PERIOD;

    SIGNAL sim_done                  : boolean;                       -- @suppress
    SIGNAL clk                       : std_ulogic;
    SIGNAL rst                       : std_ulogic;
    SIGNAL load_reg_a, load_reg_b    : std_ulogic;
    SIGNAL out_en_reg_a, out_en_alu  : std_ulogic;
    SIGNAL flag_in, carry, zero, sub : std_ulogic;
    SIGNAL data                      : std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);

BEGIN

    dut : COMPONENT processor
        PORT MAP(
            clk          => clk,
            rst          => rst,
            load_reg_a   => load_reg_a,
            out_en_reg_a => out_en_reg_a,
            load_reg_b   => load_reg_b,
            sub          => sub,
            out_en_alu   => out_en_alu,
            flag_in      => flag_in,
            carry        => carry,
            zero         => zero,
            data_reg_a   => data,
            data_reg_b   => data,
            data_alu     => data
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
        WAIT FOR CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR CLOCK_PERIOD;
        rst <= '0';
        WAIT;
    END PROCESS rst_gen;

    data <= (OTHERS => 'L');

    data_gen : PROCESS IS
    BEGIN
        WAIT FOR 6 * CLOCK_PERIOD;
        data <= "01001010";
        WAIT FOR CLOCK_PERIOD;
        data <= (OTHERS => 'Z');
        WAIT FOR 2 * CLOCK_PERIOD;
        data <= "00101100";
        WAIT FOR 2 * CLOCK_PERIOD;
        data <= (OTHERS => 'Z');
        WAIT;
    END PROCESS data_gen;

    load_reg_a_gen : PROCESS IS
    BEGIN
        load_reg_a <= '0';
        WAIT FOR 6 * CLOCK_PERIOD;
        load_reg_a <= '1';
        WAIT FOR CLOCK_PERIOD;
        load_reg_a <= '0';
        WAIT;
    END PROCESS load_reg_a_gen;

    load_reg_b_gen : PROCESS IS
    BEGIN
        load_reg_b <= '0';
        WAIT FOR 9 * CLOCK_PERIOD;
        load_reg_b <= '1';
        WAIT FOR CLOCK_PERIOD;
        load_reg_b <= '0';
        WAIT;
    END PROCESS load_reg_b_gen;

    out_en_reg_a_gen : PROCESS IS
    BEGIN
        out_en_reg_a <= '0';
        WAIT FOR 2 * CLOCK_PERIOD;
        out_en_reg_a <= '1';
        WAIT FOR CLOCK_PERIOD;
        out_en_reg_a <= '0';
        WAIT FOR 4 * CLOCK_PERIOD;
        out_en_reg_a <= '1';
        WAIT FOR CLOCK_PERIOD;
        out_en_reg_a <= '0';
        WAIT;
    END PROCESS out_en_reg_a_gen;

    out_en_alu_gen : PROCESS IS
    BEGIN
        out_en_alu <= '0';
        WAIT FOR 3 * CLOCK_PERIOD;
        out_en_alu <= '1';
        WAIT FOR CLOCK_PERIOD;
        out_en_alu <= '0';
        WAIT FOR 4 * CLOCK_PERIOD;
        out_en_alu <= '1';
        WAIT FOR CLOCK_PERIOD;
        out_en_alu <= '0';
        WAIT FOR 2 * CLOCK_PERIOD;
        out_en_alu <= '1';
        WAIT FOR CLOCK_PERIOD;
        out_en_alu <= '0';
        WAIT;
    END PROCESS out_en_alu_gen;

    sub_gen : PROCESS IS
    BEGIN
        sub <= '0';
        WAIT;
    END PROCESS sub_gen;

    flag_in_gen : PROCESS IS
    BEGIN
        flag_in <= '0';
        WAIT FOR 5 * CLOCK_PERIOD;
        flag_in <= '1';
        WAIT;
    END PROCESS flag_in_gen;

END ARCHITECTURE TESTBENCH;
