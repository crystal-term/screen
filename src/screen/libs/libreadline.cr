{% skip_file if flag?(:win32) || flag?(:windows) || flag?(:without_readline) || flag?(:term_screen_no_readline) %}

@[Link("readline")]
{% if flag?(:openbsd) %}
  @[Link("termcap")]
{% elsif flag?(:darwin) %}
  @[Link("edit")]
{% end %}
lib LibReadline
  alias Int = LibC::Int

  fun rl_initialize : LibC::Int
  fun get_screen_size = rl_get_screen_size(rows : Int*, cols : Int*)
end
