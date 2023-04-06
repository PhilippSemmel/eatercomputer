----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   GenericRam_TB1
--
-- Authors      :   Philipp Semmel
-- Created      :   23.02.2023
-- Last update  :   02.04.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;

ENTITY generic_ram_tb1 IS
END generic_ram_tb1;

ARCHITECTURE TESTBENCH OF generic_ram_tb1 IS

    COMPONENT generic_ram
        GENERIC(
            INITIAL_VALUES : ram_memory
        );
        PORT(
            clk      : IN  std_ulogic;
            load     : IN  std_ulogic;
            addr     : IN  unsigned(RAM_ADDR_WORD_WIDTH - 1 DOWNTO 0);
            data_in  : IN  std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
            data_out : OUT std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT generic_ram;

    CONSTANT CLOCK_PERIOD    : time := 10 ns;
    CONSTANT SIMULATION_TIME : time := 22 * CLOCK_PERIOD;

    SIGNAL sim_done : boolean;                                        -- @suppress
    SIGNAL clk      : std_ulogic;
    SIGNAL write_en : std_ulogic;
    SIGNAL addr     : unsigned(RAM_ADDR_WORD_WIDTH - 1 DOWNTO 0);
    SIGNAL data_in  : std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
    SIGNAL data_out : std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0); -- @suppress

BEGIN

    dut : COMPONENT generic_ram
        GENERIC MAP(
            INITIAL_VALUES => (
                0      => "01001010",
                2      => "11111111",
                3      => "01011110",
                10     => "10000000",
                OTHERS => "00000000"
            )
        )
        PORT MAP(
            clk      => clk,
            load     => write_en,
            addr     => addr,
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

    we_gen : PROCESS
    BEGIN
        write_en <= '0';
        WAIT FOR (RAM_MEMORY_LOCATIONS + 3) * CLOCK_PERIOD;
        write_en <= '1';
        WAIT FOR 2 * CLOCK_PERIOD;
        write_en <= '0';
        WAIT;
    END PROCESS;

    addr_gen : PROCESS IS
    BEGIN
        addr <= (OTHERS => '0');
        WAIT FOR CLOCK_PERIOD;
        FOR i IN 0 TO RAM_MEMORY_LOCATIONS - 1 LOOP
            addr <= to_unsigned(i, addr'length);
            WAIT FOR CLOCK_PERIOD;
        END LOOP;
        WAIT FOR 2 * CLOCK_PERIOD;
        addr <= "1001";
        WAIT FOR CLOCK_PERIOD;
        addr <= "0100";
        WAIT;
    END PROCESS addr_gen;

    data_in_gen : PROCESS IS
    BEGIN
        data_in <= (OTHERS => '0');
        WAIT FOR (RAM_MEMORY_LOCATIONS + 3) * CLOCK_PERIOD;
        data_in <= "11010011";
        WAIT FOR CLOCK_PERIOD;
        data_in <= "00100101";
        WAIT;
    END PROCESS data_in_gen;

END ARCHITECTURE;
