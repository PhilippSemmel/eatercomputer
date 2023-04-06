----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   GenericRegister Testbench 1
--
-- Authors      :   Philipp Semmel
-- Created      :   21.03.2023
-- Last update  :   28.03.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY generic_register_tb1 IS
END ENTITY generic_register_tb1;

ARCHITECTURE TESTBENCH OF generic_register_tb1 IS

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
    CONSTANT SIMULATION_TIME : time    := 12 * CLOCK_PERIOD;
    CONSTANT WORD_WIDTH      : natural := 8;

    SIGNAL sim_done          : boolean;                               -- @suppress
    SIGNAL clk               : std_ulogic;
    SIGNAL rst               : std_ulogic;
    SIGNAL load              : std_ulogic;
    SIGNAL data_in, data_out : std_ulogic_vector(7 DOWNTO 0);         -- @suppress

BEGIN

    dut : COMPONENT generic_register
        GENERIC MAP(
            WORD_WIDTH => WORD_WIDTH
        )
        PORT MAP(
            clk      => clk,
            rst      => rst,
            data_in  => data_in,
            load     => load,
            data_out => data_out
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

    load_gen : PROCESS IS
    BEGIN
        load <= '0';
        WAIT FOR 3 * CLOCK_PERIOD;
        load <= '1';
        WAIT FOR CLOCK_PERIOD;
        load <= '0';
        WAIT FOR 4 * CLOCK_PERIOD;
        load <= '1';
        WAIT FOR CLOCK_PERIOD;
        load <= '0';
        WAIT FOR CLOCK_PERIOD;
        load <= '1';
        WAIT FOR CLOCK_PERIOD;
        load <= '0';
        WAIT;
    END PROCESS load_gen;

    data_in_gen : PROCESS IS
    BEGIN
        data_in <= (OTHERS => '0');
        WAIT FOR 3 * CLOCK_PERIOD;
        data_in <= "10101010";
        WAIT FOR 3 * CLOCK_PERIOD;
        data_in <= "01010101";
        WAIT FOR 4 * CLOCK_PERIOD;
        data_in <= "00001111";
        WAIT;
    END PROCESS data_in_gen;

END ARCHITECTURE TESTBENCH;
