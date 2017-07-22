with Langkit_Support.Text;

package body Term256 is

   ANSI_Reset : constant String := ASCII.ESC & "[0m";

   -------------------
   -- Style_To_ANSI --
   -------------------

   function Style_To_ANSI (Style : Colors.Token_Style) return String is
      Red   : constant Natural := Natural (Style.Color.Red) * 5 / 255;
      Green : constant Natural := Natural (Style.Color.Green) * 5 / 255;
      Blue  : constant Natural := Natural (Style.Color.Blue) * 5 / 255;

      Bold_Marker         : constant String :=
        (if Style.Bold then "1;" else "");
      Color_Number        : constant Natural :=
        16 + 36 * Red + 6 * Green + Blue;
      Padded_Color_Number : constant String := Natural'Image (Color_Number);
   begin
      return (ASCII.ESC & "[" & Bold_Marker & "38;5;"
              & Padded_Color_Number
                (Padded_Color_Number'First + 1 .. Padded_Color_Number'Last)
              & "m");
   end Style_To_ANSI;

   ----------------
   -- Put_Tokens --
   ----------------

   procedure Put_Tokens
     (Unit       : LAL.Analysis_Unit;
      Highlights : Highlighter.Highlights_Holder;
      S          : Colors.Style_Type;
      Charset    : String)
   is
      --  TODO: use Charset to properly encode token text (see Escape below)

      pragma Unreferenced (Charset);

      function Escape (T : Langkit_Support.Text.Text_Type) return String
      is (Langkit_Support.Text.Image (T));

      procedure Put_Token
        (Text : Langkit_Support.Text.Text_Type;
         HL   : Highlighter.Highlight_Type);
      procedure New_Line;
      procedure Indent (Length : Natural);
      --  Generic parameters for Put_Tokens below

      procedure Put_Token
        (Text : Langkit_Support.Text.Text_Type;
         HL   : Highlighter.Highlight_Type)
      is
      begin
         Put
           (Style_To_ANSI (S.Tok_Styles (HL)) & Escape (Text) & ANSI_Reset);
      end Put_Token;

      procedure New_Line is
      begin
         Put ((1 => ASCII.LF));
      end New_Line;

      procedure Indent (Length : Natural) is
      begin
         Put ((1 .. Length => ' '));
      end Indent;

      procedure Put_Tokens is new Highlighter.Put_Tokens;
   begin
      Put_Tokens (Unit, Highlights);
   end Put_Tokens;

end Term256;
