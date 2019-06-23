library(ggplot2)
library(simmer)
library(simmer.plot)

set.seed(1234)

boat <-
  trajectory("Boat path") %>%
  
  seize("Nadglednik", 1) %>%
  timeout(function() rnorm(1, 10)) %>%
  release("Nadglednik", 1) %>%

  seize("Brod_u_luci", 1) %>%
  timeout(function() rnorm(1, 60)) %>%
  release("Brod_u_luci", 1) 

env <- simmer("Luka")

env %>%
  add_resource("Nadglednik", 1) %>%
  add_resource("Brod_u_luci", 50) %>%
  add_generator("Boat", boat, function() rnorm(1, 10, 0.5)) %>%
  run(until=720)


env_arrivals <- get_mon_arrivals(env)
env_resources <- get_mon_resources(env)

head(env_arrivals)
head(env_resources)

plot(env_resources, metric = "usage", c("Nadglednik", "Brod_u_luci"),
     items=c("queue", "server"))

plot(env_resources, metric="utilization", c("Nadglednik", "Brod_u_luci"))

plot(env_arrivals, metric = "waiting_time")