----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   clock_TB1
--
-- Authors      :   Philipp Semmel
-- Created      :   21.04.2023
-- Last update  :   02.05.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;

ENTITY clock_TB1 IS
END ENTITY clock_TB1;

ARCHITECTURE TESTBENCH OF clock_TB1 IS

    COMPONENT clock
        GENERIC(
            INPUT_FREQUENCY  : natural := FPGA_CLOCK_FREQUENCY_HZ;
            OUTPUT_FREQUENCY : natural := COMPUTER_CLOCK_FREQUENCY
        );
        PORT(
            sys_clk : IN  std_ulogic;
            rst     : IN  std_ulogic;
            hlt     : IN  std_ulogic;
            out_clk : OUT std_ulogic
        );
    END COMPONENT clock;

    CONSTANT CLOCK_PERIOD     : time    := 10 ns;
    CONSTANT SIMULATION_TIME  : time    := 65 * CLOCK_PERIOD;
    CONSTANT INPUT_FREQUENCY  : Integer := 1e8;
    CONSTANT OUTPUT_FREQUENCY : Integer := 1e7;

    SIGNAL sim_done : boolean;                                        --@suppress
    SIGNAL sys_clk  : std_ulogic;
    SIGNAL rst      : std_ulogic;
    SIGNAL hlt      : std_ulogic;
    SIGNAL out_clk  : std_ulogic;                                     --@suppress

BEGIN

    dut : COMPONENT clock
        GENERIC MAP(
            INPUT_FREQUENCY  => INPUT_FREQUENCY,
            OUTPUT_FREQUENCY => OUTPUT_FREQUENCY
        )
        PORT MAP(
            sys_clk => sys_clk,
            rst     => rst,
            hlt     => hlt,
            out_clk => out_clk
        );

    sim_done_gen : PROCESS IS
    BEGIN
        sim_done <= false;
        WAIT FOR SIMULATION_TIME;
        sim_done <= true;
        WAIT;
    END PROCESS sim_done_gen;

    sys_clk_gen : PROCESS IS
    BEGIN
        sys_clk <= '1';
        WAIT FOR CLOCK_PERIOD / 2;
        sys_clk <= '0';
        WAIT FOR CLOCK_PERIOD / 2;
        IF sim_done THEN
            WAIT;
        END IF;
    END PROCESS sys_clk_gen;

    rst_gen : PROCESS IS
    BEGIN
        rst <= '0';
        WAIT FOR CLOCK_PERIOD;
        rst <= '1';
        WAIT FOR CLOCK_PERIOD;
        rst <= '0';
        WAIT;
    END PROCESS rst_gen;

    hlt_gen : PROCESS IS
    BEGIN
        hlt <= '0';
        WAIT FOR 23 * CLOCK_PERIOD;
        hlt <= '1';
        WAIT FOR ((INPUT_FREQUENCY / OUTPUT_FREQUENCY) + 3) * CLOCK_PERIOD;
        hlt <= '0';
        WAIT FOR 6 * CLOCK_PERIOD;
        hlt <= '1';
        WAIT FOR 10 * CLOCK_PERIOD;
        hlt <= '0';
        WAIT;
    END PROCESS hlt_gen;

END ARCHITECTURE TESTBENCH;
