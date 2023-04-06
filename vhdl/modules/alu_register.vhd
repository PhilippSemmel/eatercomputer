----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   alu_register
-- Description  :   synchorous reg reads data if load is high
--                  outputs reg to data if out_en is high else high-z
--                  constantly outputs reg to data_out_alu
--                  after reset reg val is 0
--
-- Authors      :   Philipp Semmel
-- Created      :   26.03.2023
-- Last update  :   04.03.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;

ENTITY alu_register IS
    PORT(
        clk          : IN     std_ulogic;
        rst          : IN     std_ulogic;
        load         : IN     std_ulogic;
        out_en       : IN     std_ulogic;
        data         : INOUT  std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
        data_out_alu : BUFFER std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0)
    );
END ENTITY alu_register;

ARCHITECTURE RTL OF alu_register IS

    COMPONENT generic_register IS
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

    COMPONENT generic_tri_state_buffer IS
        GENERIC(
            WORD_WIDTH : natural
        );
        PORT(
            out_en   : IN  std_ulogic;
            data_in  : IN  std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0);
            data_out : OUT std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT generic_tri_state_buffer;

BEGIN

    reg : COMPONENT generic_register
        GENERIC MAP(
            WORD_WIDTH => DATA_WORD_WIDTH
        )
        PORT MAP(
            clk      => clk,
            rst      => rst,
            data_in  => to_stdulogicvector(data),
            load     => load,
            data_out => data_out_alu
        );

    buf : COMPONENT generic_tri_state_buffer
        GENERIC MAP(
            WORD_WIDTH => DATA_WORD_WIDTH
        )
        PORT MAP(
            out_en                      => out_en,
            data_in                     => data_out_alu,
            to_stdlogicvector(data_out) => data
        );

END ARCHITECTURE RTL; 