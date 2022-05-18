IRB.conf[:PROMPT][:LOCAL] = {
  :AUTO_INDENT => true,
  :PROMPT_I =>  ">> ",
  :PROMPT_S => ".. ", # prompt for continuated strings
  :PROMPT_C => ".. ", # prompt for continuated statement
  :RETURN => "=> %s\n"
}

IRB.conf[:PROMPT_MODE] = :LOCAL
