----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   ram package
-- Description  :   package with constants, types and functions
--
-- Authors      :   Philipp Semmel
-- Created      :   12.03.2023
-- Last update  :   15.04.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

PACKAGE comp_pkg IS
    -- system data
    CONSTANT FPGA_CLOCK_FREQUENCY_HZ  : natural := 5e7;
    CONSTANT COMPUTER_CLOCK_FREQUENCY : natural := 1e3;

    -- architeture constants
    CONSTANT BUS_WORD_WIDTH              : natural := 8;
    CONSTANT DATA_WORD_WIDTH             : natural := BUS_WORD_WIDTH;
    CONSTANT RAM_ADDR_WORD_WIDTH         : natural := 4;
    CONSTANT RAM_MEMORY_LOCATIONS        : natural := 2 ** RAM_ADDR_WORD_WIDTH;
    CONSTANT PROGRAMM_COUNTER_WORD_WIDTH : natural := 4;
    CONSTANT PROGRAMM_COUNTER_MAX_VALUE  : natural := 2 ** PROGRAMM_COUNTER_WORD_WIDTH;
    CONSTANT INSTRUCTION_STEPS : natrual := 5;

    -- types
    TYPE ram_memory IS ARRAY (RAM_MEMORY_LOCATIONS - 1 DOWNTO 0) OF std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);

    -- functions
    FUNCTION is_all(sig : unsigned; val : std_logic) RETURN boolean;
END PACKAGE comp_pkg;

PACKAGE BODY comp_pkg IS
    FUNCTION is_all(sig : unsigned; val : std_logic) RETURN boolean IS
        CONSTANT all_bits : unsigned(sig'RANGE) := (OTHERS => val);
    BEGIN
        RETURN sig = all_bits;
    END FUNCTION;
END PACKAGE BODY comp_pkg;
