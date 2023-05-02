----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   alu_register_tb1
--
-- Authors      :   Philipp Semmel
-- Created      :   28.03.2023
-- Last update  :   30.03.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;

ENTITY alu_register_tb1 IS
END ENTITY alu_register_tb1;

ARCHITECTURE TESTBENCH OF alu_register_tb1 IS

    COMPONENT alu_register IS
        PORT(
            clk          : IN     std_ulogic;
            rst          : IN     std_ulogic;
            load         : IN     std_ulogic;
            out_en       : IN     std_ulogic;
            data         : INOUT  std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
            data_out_alu : BUFFER std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT alu_register;

    CONSTANT CLOCK_PERIOD    : time := 10 ns;
    CONSTANT SIMULATION_TIME : time := 12 * CLOCK_PERIOD;

    SIGNAL sim_done     : boolean;                                    -- @suppress
    SIGNAL clk          : std_ulogic;
    SIGNAL rst          : std_ulogic;
    SIGNAL load         : std_ulogic;
    SIGNAL out_en       : std_ulogic;
    SIGNAL data         : std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
    SIGNAL data_out_alu : std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0); --@suppress

BEGIN

    dut : COMPONENT alu_register
        PORT MAP(
            clk          => clk,
            rst          => rst,
            load         => load,
            out_en       => out_en,
            data         => data,
            data_out_alu => data_out_alu
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
        WAIT FOR 5 * CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR CLOCK_PERIOD;
        rst <= '0';
        WAIT;
    END PROCESS rst_gen;

    load_gen : PROCESS IS
    BEGIN
        load <= '0';
        WAIT FOR 4 * CLOCK_PERIOD;
        load <= '1';
        WAIT FOR CLOCK_PERIOD;
        load <= '0';
        WAIT FOR CLOCK_PERIOD;
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
        out_en <= '0';
        WAIT FOR CLOCK_PERIOD;
        out_en <= '1';
        WAIT FOR 2 * CLOCK_PERIOD;
        out_en <= '0';
        WAIT;
    END PROCESS out_en_gen;
    
    data <= (OTHERS => 'L');

    data_gen : PROCESS IS
    BEGIN
        data <= (OTHERS => 'Z');
        WAIT FOR 4 * CLOCK_PERIOD;
        data <= (OTHERS => '1');
        WAIT FOR CLOCK_PERIOD;
        data <= (OTHERS => 'Z');
        WAIT FOR CLOCK_PERIOD;
        data <= "01010101";
        WAIT FOR CLOCK_PERIOD;
        data <= (OTHERS => 'Z');
        WAIT;
    END PROCESS data_gen;

END ARCHITECTURE TESTBENCH;
