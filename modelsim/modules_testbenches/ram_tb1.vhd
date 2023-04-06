----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   ram_tb1
--
-- Authors      :   Philipp Semmel
-- Created      :   31.03.2023
-- Last update  :   02.04.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;

ENTITY ram_tb1 IS
END ENTITY ram_tb1;

ARCHITECTURE TESTBENCH OF ram_tb1 IS

    COMPONENT ram
        PORT(
            clk    : IN    std_ulogic;
            load   : IN    std_ulogic;
            addr   : IN    std_ulogic_vector(RAM_ADDR_WORD_WIDTH - 1 DOWNTO 0);
            out_en : IN    std_ulogic;
            data   : INOUT std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT ram;

    CONSTANT CLOCK_PERIOD    : time := 10 ns;
    CONSTANT SIMULATION_TIME : time := 27 * CLOCK_PERIOD;

    SIGNAL sim_done     : boolean;                                    -- @suppress
    SIGNAL clk          : std_ulogic;
    SIGNAL load, out_en : std_ulogic;
    SIGNAL addr         : std_ulogic_vector(RAM_ADDR_WORD_WIDTH - 1 DOWNTO 0);
    SIGNAL data         : std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);

BEGIN

    dut : COMPONENT ram
        PORT MAP(
            clk    => clk,
            load   => load,
            addr   => addr,
            out_en => out_en,
            data   => data
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

    load_gen : PROCESS IS
    BEGIN
        load <= '0';
        WAIT FOR (RAM_MEMORY_LOCATIONS + 2) * CLOCK_PERIOD;
        load <= '1';
        WAIT FOR 3 * CLOCK_PERIOD;
        load <= '0';
        WAIT;
    END PROCESS load_gen;

    out_en_gen : PROCESS IS
    BEGIN
        out_en <= '0';
        WAIT FOR CLOCK_PERIOD;
        out_en <= '1';
        WAIT FOR RAM_MEMORY_LOCATIONS * CLOCK_PERIOD;
        out_en <= '0';
        WAIT FOR 5 * CLOCK_PERIOD;
        out_en <= '1';
        WAIT FOR 3 * CLOCK_PERIOD;
        out_en <= '0';
        WAIT;
    END PROCESS out_en_gen;

    addr_gen : PROCESS IS
    BEGIN
        WAIT FOR CLOCK_PERIOD;
        FOR i IN 0 TO RAM_MEMORY_LOCATIONS - 1 LOOP
            addr <= std_ulogic_vector(to_unsigned(i, addr'length));
            WAIT FOR CLOCK_PERIOD;
        END LOOP;
        WAIT FOR CLOCK_PERIOD;
        addr <= "0110";
        WAIT FOR CLOCK_PERIOD;
        addr <= "1101";
        WAIT FOR CLOCK_PERIOD;
        addr <= "0100";
        WAIT FOR 3 * CLOCK_PERIOD;
        addr <= "1101";
        WAIT FOR CLOCK_PERIOD;
        addr <= "0110";
        WAIT;
    END PROCESS addr_gen;

    data <= (OTHERS => 'L');

    data_gen : PROCESS IS
    BEGIN
        data <= (OTHERS => 'Z');
        WAIT FOR (RAM_MEMORY_LOCATIONS + 2) * CLOCK_PERIOD;
        data <= "00111010";
        WAIT FOR CLOCK_PERIOD;
        data <= "11000101";
        WAIT FOR CLOCK_PERIOD;
        data <= "11000000";
        WAIT FOR CLOCK_PERIOD;
        data <= (OTHERS => 'Z');
        WAIT;
    END PROCESS data_gen;

END ARCHITECTURE TESTBENCH;

