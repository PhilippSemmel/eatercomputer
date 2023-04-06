----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   ram package
-- Description  :   package with constants and types
--
-- Authors      :   Philipp Semmel
-- Created      :   12.03.2023
-- Last update  :   31.03.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

PACKAGE comp_pkg IS
    -- word widht and max values
    CONSTANT BUS_WORD_WIDTH              : natural := 8;
    CONSTANT DATA_WORD_WIDTH             : natural := BUS_WORD_WIDTH;
    CONSTANT RAM_ADDR_WORD_WIDTH         : natural := 4;
    CONSTANT RAM_MEMORY_LOCATIONS        : natural := 2 ** RAM_ADDR_WORD_WIDTH;
    CONSTANT PROGRAMM_COUNTER_WORD_WIDTH : natural := 4;
    CONSTANT PROGRAMM_COUNTER_MAX_VALUE  : natural := 2 ** PROGRAMM_COUNTER_WORD_WIDTH;

    -- types
    TYPE ram_memory IS ARRAY (RAM_MEMORY_LOCATIONS - 1 DOWNTO 0) OF std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
END PACKAGE comp_pkg;
