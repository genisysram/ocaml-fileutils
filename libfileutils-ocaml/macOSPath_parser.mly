/**************************************************************************/
/*   Ocaml-fileutils                                                      */
/*                                                                        */
/*   Copyright (C) 2003, 2004 Sylvain Le Gall <sylvain@le-gall.net>       */
/*                                                                        */
/*   This program is free software; you can redistribute it and/or        */
/*   modify it under the terms of the GNU Library General Public          */
/*   License as published by the Free Software Foundation; either         */
/*   version 2 of the License, or any later version ; with the OCaml      */
/*   static compilation exception.                                        */
/*                                                                        */
/*   This program is distributed in the hope that it will be useful,      */
/*   but WITHOUT ANY WARRANTY; without even the implied warranty of       */
/*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                 */
/*   See the LICENCE file for more details.                               */
/*                                                                        */
/*   You should have received a copy of the GNU General Public License    */
/*   along with this program; if not, write to the Free Software          */
/*   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA             */
/*   02111-1307  USA                                                      */
/*                                                                        */
/*   Contact: sylvain@le-gall.net                                         */
/*                                                                        */
/**************************************************************************/

%{

open FilePath_type;;

%}

%token SEPARATOR
%token EOF
%token DOT
%token <string> IDENT
%start main_filename
%type <FilePath_type.filename_part list> main_filename
%start main_path_variable
%type <FilePath_type.filename list> main_path_variable

%%
no_separator:
  IDENT no_separator { add_string $1 $2 }
| EOF                { begin_string "" [] }
;
end_normal_filename:
  IDENT end_normal_filename       { add_string $1 $2 }
| SEPARATOR begin_normal_filename { begin_string "" $2 }
| EOF                             { begin_string "" [] }
;
begin_normal_filename:
  IDENT end_normal_filename       { end_string(add_string $1 $2) }
| SEPARATOR begin_normal_filename { ParentDir :: $2 }
| EOF                             { [] }
;
main_filename:
  IDENT SEPARATOR begin_normal_filename { (Root $1) :: $3 }
| SEPARATOR begin_normal_filename       { (CurrentDir Long) :: $2 }
| IDENT no_separator                    { end_string(add_string $1 $2) }
| EOF                                   { [ CurrentDir Short ] }
;
main_path_variable:
  IDENT main_path_variable { $1 :: $2 }
| EOF                      { [] }
;
