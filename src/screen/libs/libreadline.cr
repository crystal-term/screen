@[Link("readline")]
{% if flag?(:openbsd) %}
  @[Link("termcap")]
{% if flag?(:darwin) %}
  @[Link("libedit")]
{% end %}
lib LibReadline
  alias Int = LibC::Int

  fun get_screen_size = rl_get_screen_size(rows : Int*, cols : Int*)
end
