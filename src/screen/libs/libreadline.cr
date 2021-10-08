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
