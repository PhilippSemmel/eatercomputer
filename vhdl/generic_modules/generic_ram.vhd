----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   Generic RAM
-- Description  :   continuously outputs word from addr to data_out
--                  synchronously write data_in to addr if enabled 
--
-- Authors      :   Philipp Semmel
-- Created      :   22.02.2023
-- Last update  :   02.04.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;


ENTITY generic_ram IS
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
END ENTITY;

ARCHITECTURE RAM OF generic_ram IS

    SIGNAL ram : ram_memory := INITIAL_VALUES;

BEGIN

    seq : PROCESS(ALL) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF load = '1' THEN
                ram(to_integer(addr)) <= data_in;
            END IF;
        END IF;

    END PROCESS seq;

    data_out <= ram(to_integer(addr));

END ARCHITECTURE RAM;
