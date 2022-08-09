corpus = """
    long_text = "Donec placerat nunc justo, ut volutpat sem volutpat quis. Sed eleifend at purus at pulvinar. Vestibulum sed orci id sapien hendrerit varius. Duis egestas, felis eget euismod vestibulum, mauris purus bibendum tellus, at commodo nibh nisl sit amet sapien. Nullam scelerisque erat a ipsum eleifend, et fermentum metus luctus. Proin tempor cursus arcu, ut commodo sem faucibus scelerisque. Suspendisse vulputate, arcu vel bibendum laoreet, mauris tellus accumsan sapien, et consequat risus est varius velit. Mauris pulvinar, quam vitae efficitur varius, libero leo tincidunt velit, vel gravida nunc lectus vitae mauris. Nulla lacinia dolor ac maximus maximus. Proin vel neque et mi convallis semper. Proin lacus elit, dignissim sit amet maximus et, condimentum accumsan justo. Etiam a risus posuere, luctus dolor sed, euismod ligula. Donec placerat nunc justo, ut volutpat sem volutpat quis. Sed eleifend at purus at pulvinar. Vestibulum sed orci id sapien hendrerit varius. Duis egestas, felis eget euismod vestibulum, mauris purus bibendum tellus, at commodo nibh nisl sit amet sapien. Nullam scelerisque erat a ipsum eleifend, et fermentum metus luctus. Proin tempor cursus arcu, ut commodo sem faucibus scelerisque. Suspendisse vulputate, arcu vel bibendum laoreet, mauris tellus accumsan sapien, et consequat risus est varius velit. Mauris pulvinar, quam vitae efficitur varius, libero leo tincidunt velit, vel gravida nunc lectus vitae mauris. Nulla lacinia dolor ac maximus maximus. Proin vel neque et mi convallis semper. Proin lacus elit, dignissim sit amet maximus et, condimentum accumsan justo. Etiamarisusposuereluctusfindmedolorsed, euismod ligula."
"""

pattern = """
Proin vel neque et mi convallis semper. Proin lacus elit, dignissim sit amet maximus et, condimentum accumsan justo. Etiamarisusposuereluctusfindmedolorsed
"""

short_pattern = "ligula"


Benchee.run(
  %{
    "String" => fn %{corpus: corpus, pattern: pattern} ->
      BoyerMoore.Implementations.String.contains?(corpus, pattern)
    end,

    "Nif" => fn %{corpus: corpus, pattern: pattern} ->
      BoyerMoore.Implementations.Nif.contains?(corpus, pattern)
    end,

    "String.contains?"=> fn %{corpus: corpus, pattern: pattern} ->
      String.contains?(corpus, pattern)
    end,

  },
  inputs: %{
    #    "graphemes" => %{corpus: String.graphemes(corpus), pattern: String.graphemes(pattern)},
    "strings" => %{corpus: corpus, pattern: pattern, compiled_pattern: BoyerMoore.Implementations.String.compile(pattern)},
    # "graphemes with a short pattern" => %{
    #   corpus: String.graphemes(corpus),
    #   pattern: String.graphemes(short_pattern)
    # },
    "strings with a short pattern" => %{corpus: corpus, pattern: short_pattern, compiled_pattern: BoyerMoore.Implementations.String.compile(short_pattern)}
  },
  formatters: [
    {Benchee.Formatters.HTML, file: "samples_output/my.html"},
    Benchee.Formatters.Console
  ]
)
