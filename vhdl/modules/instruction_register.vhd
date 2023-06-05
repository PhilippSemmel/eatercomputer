----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   instruction_register
-- Description  :   description
--
-- Authors      :   Philipp Semmel
-- Created      :   05.06.2023
-- Last update  :   05.06.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;

ENTITY instruction_register IS
    PORT(
        clk                : IN    std_ulogic;
        rst                : IN    std_ulogic;
        load               : IN    std_ulogic;
        out_en             : IN    std_ulogic;
        data               : INOUT std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
        control_logic_addr : out   std_ulogic_vector(3 DOWNTO 0)
    );
END ENTITY instruction_register;

ARCHITECTURE RTL OF instruction_register IS

    COMPONENT generic_register
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

    SIGNAL reg_out : std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
    SIGNAL buf_in : std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
    
BEGIN

    reg : generic_register
        GENERIC MAP(
            WORD_WIDTH => DATA_WORD_WIDTH
        )
        PORT MAP(
            clk      => clk,
            rst      => rst,
            data_in  => std_ulogic_vector(data),
            load     => load,
            data_out => reg_out
        );
        
    buf_in <= "ZZZZ" & reg_out(3 DOWNTO 0);

    buf : generic_tri_state_buffer
        GENERIC MAP(
            WORD_WIDTH => DATA_WORD_WIDTH
        )
        PORT MAP(
            out_en                      => out_en,
            data_in                     => buf_in,
            to_stdlogicvector(data_out) => data
        );

    control_logic_addr <= reg_out(7 DOWNTO 4);

END ARCHITECTURE RTL;
