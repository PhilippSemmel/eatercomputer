----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   GenericRegister
-- Description  :   after reset reg val is 0
--                  synchronously loads data_in in reg if load is high 
--
-- Authors      :   Philipp Semmel
-- Created      :   21.03.2023
-- Last update  :   08.05.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY generic_register IS
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
END ENTITY generic_register;

ARCHITECTURE RTL OF generic_register IS

    SIGNAL data_ff, data_nxt : std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0);

BEGIN

    seq : PROCESS(clk, rst) IS
    BEGIN
        IF rst = '1' THEN
            data_ff <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            data_ff <= data_nxt;
        END IF;
    END PROCESS seq;

    data_nxt <= data_in WHEN load = '1' ELSE data_ff;

    data_out <= data_ff;

END ARCHITECTURE RTL;
