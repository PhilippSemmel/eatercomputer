----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   config
-- Description  :   config values for computer
--
-- Authors      :   Philipp Semmel
-- Created      :   31.03.2023
-- Last update  :   31.03.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;

PACKAGE config IS
        CONSTANT INITIAL_RAM_VALUES : ram_memory := (OTHERS => std_ulogic_vector(to_unsigned(0, DATA_WORD_WIDTH)));
END PACKAGE config;
