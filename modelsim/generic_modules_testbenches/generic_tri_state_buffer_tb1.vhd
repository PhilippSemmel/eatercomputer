----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   GenericTriStateBuffer Testbench 1
--
-- Authors      :   Philipp Semmel
-- Created      :   21.03.2023
-- Last update  :   28.03.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_1164.ALL;

ENTITY generic_tri_state_buffer_tb1 IS
END ENTITY generic_tri_state_buffer_tb1;

ARCHITECTURE TESTBENCH OF generic_tri_state_buffer_tb1 IS

    COMPONENT generic_tri_state_buffer
        GENERIC(
            WORD_WIDTH : natural
        );
        PORT(
            out_en   : IN  std_ulogic;
            data_in  : IN  std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0);
            data_out : OUT std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT generic_tri_state_buffer;

    CONSTANT CLOCK_PERIOD    : time    := 10 ns;
    CONSTANT SIMULATION_TIME : time    := 11 * CLOCK_PERIOD;
    CONSTANT WORD_WIDTH      : natural := 8;

    SIGNAL sim_done          : boolean;                               -- @suppress
    SIGNAL out_en            : std_ulogic;
    SIGNAL data_in, data_out : std_ulogic_vector(7 DOWNTO 0);         -- @suppress

BEGIN

    dut : COMPONENT generic_tri_state_buffer
        GENERIC MAP(
            WORD_WIDTH => WORD_WIDTH
        )
        PORT MAP(
            out_en   => out_en,
            data_in  => data_in,
            data_out => data_out
        );

    sim_done_gen : PROCESS IS
    BEGIN
        sim_done <= false;
        WAIT FOR SIMULATION_TIME;
        sim_done <= true;
        WAIT;
    END PROCESS sim_done_gen;

    data_in_gen : PROCESS IS
    BEGIN
        data_in <= "01010101";
        WAIT FOR 2 * CLOCK_PERIOD;
        data_in <= "10101010";
        WAIT FOR 2 * CLOCK_PERIOD;
        data_in <= "11110000";
        WAIT FOR 2 * CLOCK_PERIOD;
        data_in <= "00001111";
        WAIT FOR 4 * CLOCK_PERIOD;
        data_in <= "11111111";
        WAIT;
    END PROCESS data_in_gen;

    enable_gen : PROCESS IS
    BEGIN
        out_en <= '1';
        WAIT FOR 3 * CLOCK_PERIOD;
        out_en <= '0';
        WAIT FOR 2 * CLOCK_PERIOD;
        out_en <= '1';
        WAIT FOR 2 * CLOCK_PERIOD;
        out_en <= '0';
        WAIT FOR 2 * CLOCK_PERIOD;
        out_en <= '1';
        WAIT;
    END PROCESS enable_gen;

END ARCHITECTURE TESTBENCH;
