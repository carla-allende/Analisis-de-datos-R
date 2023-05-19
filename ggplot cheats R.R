#mi práctica xd
a <- ggplot(economics, aes(date, unemploy))
a + geom_path(lineend = "butt",
              linejoin = "round", linemitre = 7)

a + geom_ribbon(aes(ymin = unemploy - 1900,
                    ymax = unemploy + 1900))


e <- ggplot(mpg, aes(cty, hwy))


e + geom_label(aes(label = cty), nudge_x = 4,
               nudge_y = 8)


cars <- mpg