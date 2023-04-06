----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   Tri-State Buffer
-- Description  :   outputs input if enabled else high impedence
--
-- Authors      :   Philipp Semmel
-- Created      :   21.03.2023
-- Last update  :   24.03.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY generic_tri_state_buffer IS
    GENERIC(
        WORD_WIDTH : natural
    );
    PORT(
        out_en   : IN  std_ulogic;
        data_in  : IN  std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0);
        data_out : OUT std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0)
    );
END ENTITY generic_tri_state_buffer;

ARCHITECTURE RTL OF generic_tri_state_buffer IS

BEGIN

    data_out <= data_in WHEN out_en = '1' ELSE
                (OTHERS => 'Z');

END ARCHITECTURE RTL;
